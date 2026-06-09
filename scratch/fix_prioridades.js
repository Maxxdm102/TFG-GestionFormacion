/**
 * fix_prioridades.js  — conexión directa (sin Electron)
 * Renumera las prioridades de tareas activas por empleado, sin duplicados.
 * Ejecución: node scratch/fix_prioridades.js
 */

const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '..', '.env') });
const sql = require('mssql');

// ── Leer Config.xml directamente ─────────────────────────────
const fs = require('fs');
const configPath = path.join(__dirname, '..', 'dist', 'Config.xml');
if (!fs.existsSync(configPath)) {
  console.error('No se encontró dist/Config.xml');
  process.exit(1);
}
const raw = fs.readFileSync(configPath, 'utf-8');

const conexNodes = [...raw.matchAll(/<Conexion[^>]+Valor="([^"]+)"/g)];
const conexiones = conexNodes.map(m => m[1]);
const conexActualId = (() => {
  const m = raw.match(/<ConexionActual[^>]+Id="([^"]+)"/);
  return m ? m[1] : '1';
})();
const serverRaw = conexiones[parseInt(conexActualId) - 1] || conexiones[0];
const baseDatosMatch = raw.match(/<BaseDatos>\s*<Valor>([^<]*)<\/Valor>/);
const database = baseDatosMatch ? baseDatosMatch[1].trim() : 'GestionFormacion';

let server = serverRaw.trim();
let port = 1433;
if (server.includes(',')) {
  const [s, p] = server.split(',');
  server = s.trim();
  port = parseInt(p.trim()) || 1433;
}

console.log(`Conectando a ${server}:${port} / ${database} ...`);

const SERVICE_USER = process.env.DB_USER || 'us_AccesoTotal';
const SERVICE_PASSWORD = process.env.DB_PASSWORD;

async function fixPrioridades() {
  const pool = await sql.connect({
    server, port, database,
    user: SERVICE_USER,
    password: SERVICE_PASSWORD,
    options: { encrypt: false, trustServerCertificate: true, enableArithAbort: true, useUTC: false },
    pool: { max: 5, min: 0, idleTimeoutMillis: 30000 }
  });

  console.log('Conexión OK. Leyendo tareas activas...');

  // Leer tareas sin finalizar ni comprobar, ordenadas por asignado → prioridad → id
  const res = await pool.request().query(`
    SELECT IdTarea, idPersonal_Asigna, Prioridad
    FROM dbo.Tareas
    WHERE FComprobada IS NULL
    ORDER BY idPersonal_Asigna, Prioridad, IdTarea
  `);

  const rows = res.recordset;
  console.log(`Tareas activas encontradas: ${rows.length}`);

  // Calcular nueva prioridad (1, 2, 3...) por empleado
  const contador = {};
  const updates = [];
  for (const row of rows) {
    const emp = row.idPersonal_Asigna ?? 0;
    contador[emp] = (contador[emp] || 0) + 1;
    const nuevaPrio = contador[emp];
    if (nuevaPrio !== row.Prioridad) {
      updates.push({ id: row.IdTarea, prio: nuevaPrio, old: row.Prioridad });
    }
  }

  console.log(`Tareas que necesitan ajuste: ${updates.length}`);

  if (updates.length === 0) {
    console.log('✅ No hay duplicados que corregir. Todo OK.');
    await pool.close();
    process.exit(0);
  }

  // Aplicar en transacción
  const tx = new sql.Transaction(pool);
  await tx.begin();
  try {
    for (const u of updates) {
      await new sql.Request(tx)
        .input('id', sql.Int, u.id)
        .input('prio', sql.Int, u.prio)
        .query('UPDATE dbo.Tareas SET Prioridad = @prio WHERE IdTarea = @id');
      console.log(`  Tarea ${u.id}: Prioridad ${u.old} → ${u.prio}`);
    }
    await tx.commit();
    console.log('\n✅ Prioridades corregidas correctamente.');
  } catch (err) {
    await tx.rollback();
    console.error('❌ Error, rollback aplicado:', err.message);
    await pool.close();
    process.exit(1);
  }

  await pool.close();
  process.exit(0);
}

fixPrioridades().catch(err => {
  console.error('Error fatal:', err.message);
  process.exit(1);
});
