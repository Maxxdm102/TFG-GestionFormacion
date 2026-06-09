/* ═══════════════════════════════════════════════════════════════
   DATABASE/DB.JS — Conexión SQL Server dinámica
   ═══════════════════════════════════════════════════════════════ */

const sql = require('mssql');
const path = require('path');
const fs = require('fs');
const os = require('os');
const { app } = require('electron');

/* ─── Credenciales de servicio ──────────────────────────────── */
require('dotenv').config();
const SERVICE_USER = process.env.DB_USER || 'us_AccesoTotal';
const SERVICE_PASSWORD = process.env.DB_PASSWORD; // Configurado mediante .env para no subir credenciales reales

/* ─── Ruta del archivo XML de configuración ─────────────────── */
function getConfigPath() {
  if (app.isPackaged) {
    return path.join(process.resourcesPath, 'Config.xml');
  }
  return path.join(app.getAppPath(), 'dist', 'Config.xml');
}

/* ─── Leer configuración desde XML ──────────────────────────── */
function readConfig() {
  const configPath = getConfigPath();
  if (!fs.existsSync(configPath)) {
    throw new Error('No hay configuración de conexión guardada. Configura la conexión primero.');
  }

  const raw = fs.readFileSync(configPath, 'utf-8');

  const getText = (tag) => {
    const match = raw.match(new RegExp(`<${tag}[^>]*>([^<]*)</${tag}>`));
    return match ? match[1].trim() : '';
  };

  const conexNodes = [...raw.matchAll(/<Conexion[^>]+Valor="([^"]+)"/g)];
  const conexiones = conexNodes.map(m => m[1]);

  const conexActualId = (() => {
    const m = raw.match(/<ConexionActual[^>]+Id="([^"]+)"/);
    return m ? m[1] : '1';
  })();

  const baseDatosMatch = raw.match(/<BaseDatos>\s*<Valor>([^<]*)<\/Valor>/);
  const database = baseDatosMatch ? baseDatosMatch[1].trim() : '';

  return {
    conexiones,
    server: conexiones[parseInt(conexActualId) - 1] || conexiones[0],
    database,
    conexionActualId: conexActualId
  };
}

/* ─── Guardar configuración en XML ──────────────────────────── */
function saveConfig({ server, database, conexiones }) {
  const configPath = getConfigPath();

  // Usar la lista que manda el frontend (contiene todo el desplegable)
  let finalConexiones = conexiones
    ? [...new Set(conexiones.filter(Boolean))]
    : [];

  // Asegurar que el servidor activo está en la lista
  if (server && !finalConexiones.includes(server)) {
    finalConexiones.push(server);
  }

  // Preservar RutaFondo si ya existía
  let rutaFondo = '';
  if (fs.existsSync(configPath)) {
    try {
      const raw = fs.readFileSync(configPath, 'utf-8');
      const m = raw.match(/<RutaFondo>(.*?)<\/RutaFondo>/);
      if (m) rutaFondo = `\n  <RutaFondo>${m[1]}<\/RutaFondo>`;
    } catch { /* ignorar */ }
  }

  const idx = finalConexiones.indexOf(server) + 1;

  const conexLines = finalConexiones
    .map((c, i) => `  <Conexion Id="${i + 1}" Valor="${c}"/>`)
    .join('\n');

  const xml = `<?xml version="1.0" encoding="utf-8"?>
<Main>
${conexLines}
  <ConexionActual Id="${idx}"/>
  <BaseDatos>
    <Valor>${database || ''}</Valor>
  </BaseDatos>${rutaFondo}
</Main>`;

  fs.writeFileSync(configPath, xml, 'utf-8');
}

/* ─── Parsear servidor y puerto ─────────────────────────────── */
function parseServer(raw) {
  let server = (raw || 'localhost').trim();
  let port = 1433;
  if (server.includes(',')) {
    const [s, p] = server.split(',');
    server = s.trim();
    port = parseInt(p.trim()) || 1433;
  }
  return { server, port };
}

/* ─── Singleton del pool de conexión ────────────────────────── */
let pool = null;

async function getPool() {
  if (pool && pool.connected) return pool;

  const config = readConfig();
  const { server, port } = parseServer(config.server);

  pool = await sql.connect({
    server,
    port,
    database: config.database || 'master',
    user: SERVICE_USER,
    password: SERVICE_PASSWORD,
    options: { encrypt: false, trustServerCertificate: true, enableArithAbort: true, useUTC: false },
    pool: { max: 10, min: 0, idleTimeoutMillis: 30000 }
  });

  console.log('[DB] Pool conectado →', server, '/', config.database);
  pool.on('error', (err) => { console.error('[DB] Pool error:', err); pool = null; });
  return pool;
}

async function closePool() {
  if (pool) { await pool.close(); pool = null; }
}

/* ─── Probar conexión desde pantalla de configuración ───────── */
const TEST_USER = 'us_limitado_tareasYpresencia';
const TEST_PASSWORD = 'uslimitado';

async function testConnectionWith({ server: rawServer, database }) {
  const { server, port } = parseServer(rawServer);

  const testPool = await sql.connect({
    server,
    port,
    database: database || 'master',
    user: TEST_USER,
    password: TEST_PASSWORD,
    options: { encrypt: false, trustServerCertificate: true, useUTC: false },
    pool: { max: 1, min: 0, idleTimeoutMillis: 5000 },
    connectionTimeout: 8000
  });

  const result = await testPool.request()
    .query('SELECT @@SERVERNAME AS servidor, DB_NAME() AS baseDatos, GETDATE() AS hora');

  await testPool.close();
  return result.recordset[0];
}

/* ─────────────────────────────────────────────────────────────────
   AUTENTICACIÓN — SeguridadUnificada_Identidad_Select
   
   Dos modos:
     1. Solo @Usuario (usuario Windows) → chequeo automático al arrancar
     2. @Usuario + @Contrasena          → login manual desde formulario
   
   Devuelve el registro del usuario si tiene permiso, o lanza error.
───────────────────────────────────────────────────────────────── */
async function checkIdentidad({ usuario, contrasena = null }) {
  // Verificar que hay config antes de intentar conectar
  let config;
  try {
    config = readConfig();
  } catch {
    throw new Error('NO_CONFIG');
  }

  const p = await getPool();
  const request = p.request()
    .input('Usuario', sql.NVarChar(200), usuario)
    .input('IdAplicacionConPermiso', sql.Int, 40);

  if (contrasena !== null) {
    request.input('Contrasena', sql.NVarChar(200), contrasena);
  }

  const result = await request.execute('SeguridadUnificada_Identidad_Select');

  if (!result.recordset || result.recordset.length === 0) {
    throw new Error('NO_PERMISO');
  }

  return result.recordset[0];
}

/* ─── Obtener usuario de Windows actual ─────────────────────── */
function getWindowsUser() {
  return os.userInfo().username;
}

/* ─── Autenticar usuario (login manual) ─────────────────────── */
async function authenticateUser({ user, password }) {
  if (user === 'adminTareas' && password === 'adminTareas108*') {
    return {
      IdIdentidad: -1,
      IdUsuario: -1,
      Nombre: 'adminTareas',
      NombreCompleto: 'Administrador Global',
      isAdmin: true
    };
  }
  return checkIdentidad({ usuario: user, contrasena: password });
}

/* ─── Chequeo automático con usuario Windows ────────────────── */
async function checkWindowsUser() {
  const winUser = getWindowsUser();
  return checkIdentidad({ usuario: winUser });
}

/* ─── Guardar y leer fondo en Config.xml ────────────────────── */
function saveFondo(fondoPath) {
  const configPath = getConfigPath();
  const configDir = path.dirname(configPath);
  
  // Convertir a ruta relativa respecto al directorio del XML
  let finalPath = fondoPath;
  try {
    finalPath = path.relative(configDir, fondoPath);
  } catch (e) {
    // Si falla (p.ej. discos distintos en Windows), dejar la original
  }

  let xmlContent = '';

  if (fs.existsSync(configPath)) {
    xmlContent = fs.readFileSync(configPath, 'utf-8');
    if (xmlContent.includes('<RutaFondo>')) {
      xmlContent = xmlContent.replace(/<RutaFondo>.*?<\/RutaFondo>/, `<RutaFondo>${finalPath}</RutaFondo>`);
    } else {
      xmlContent = xmlContent.replace('</Main>', `  <RutaFondo>${finalPath}</RutaFondo>\n</Main>`);
    }
  } else {
    xmlContent = `<?xml version="1.0" encoding="utf-8"?>
<Main>
  <RutaFondo>${finalPath}</RutaFondo>
</Main>`;
  }

  fs.writeFileSync(configPath, xmlContent, 'utf-8');
}

function getFondo() {
  const configPath = getConfigPath();
  if (!fs.existsSync(configPath)) return null;
  const raw = fs.readFileSync(configPath, 'utf-8');
  const match = raw.match(/<RutaFondo>(.*?)<\/RutaFondo>/);
  const value = match ? String(match[1] || '').trim() : '';
  if (!value) return null;
  
  // Si la ruta guardada es absoluta (por compatibilidad), la devolvemos
  if (path.isAbsolute(value)) return value;
  
  // Si es relativa, la resolvemos respecto al directorio del XML
  return path.resolve(path.dirname(configPath), value);
}

module.exports = {
  getPool, closePool,
  testConnectionWith,
  authenticateUser,
  checkWindowsUser,
  getWindowsUser,
  saveConfig, readConfig,
  saveFondo, getFondo,
  sql
};
