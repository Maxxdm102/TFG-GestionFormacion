/* ═══════════════════════════════════════════════
   IPC/IPCHANDLERS.JS
   ═══════════════════════════════════════════════ */

const { ipcMain, shell, dialog } = require('electron');

const { authenticateUser, checkWindowsUser, testConnectionWith, saveConfig, readConfig, saveFondo, getFondo, getPool, sql } = require('../database/db');

const TareaController = require('../controllers/TareaController');
const ClienteController = require('../controllers/ClienteController');
const PresupuestoController = require('../controllers/PresupuestoController');
const ContactoController = require('../controllers/ContactoController');
const PersonalModel = require('../models/PersonalModel');

// ── Sesión del usuario autenticado ───────────────────────────
// Se guarda al hacer login y se expone vía auth:getSession.
// currentSession._idPersonal se resuelve tras el login cruzando
// gf_Personal.IdIdentidad con el IdIdentidad del usuario autenticado.
let currentSession = null;

/**
 * Dado el IdIdentidad del usuario logueado, obtiene su IdPersonal
 * en gf_Personal buscando por la columna IdIdentidad.
 * Devuelve null si no se encuentra.
 */
async function resolveIdPersonal(idIdentidad, sessionData = null) {
  // Si no hay IdIdentidad ni datos de sesión, no podemos resolver
  if (!idIdentidad && !sessionData) return null;
  const lookupIdIdentidad = idIdentidad || (sessionData && (sessionData.IdIdentidad || sessionData.Id));
  try {
    const pool = await getPool();
    // Intentar por IdIdentidad en gf_Personal
    if (lookupIdIdentidad) {
      const result = await pool.request()
        .input('IdIdentidad', sql.Int, lookupIdIdentidad)
        .query('SELECT TOP 1 IdPersonal FROM dbo.gf_Personal WHERE IdIdentidad = @IdIdentidad');
      const idPersonal = result.recordset[0]?.IdPersonal ?? null;
      if (idPersonal) return idPersonal;
    }

    // Fallback: usar datos de sesión (Nombre/Usuario) si están disponibles,
    // o leer la identidad desde la tabla para extraer campos útiles.
    try {
      let nombreFull = '';
      let usuario = '';
      if (sessionData) {
        nombreFull = (sessionData.Nombre || sessionData.NombreCompleto || sessionData.UsuarioNombre || '').toString().trim();
        usuario = (sessionData.Usuario || sessionData.UsuarioNombre || '').toString().trim();
      }

      // Si no tenemos nombre pero sí tenemos usuario en sessionData, ejecutamos
      // el SP de seguridad para obtener el Nombre (el SP devuelve Nombre).
      if (!nombreFull && sessionData && sessionData.Usuario) {
        try {
          const spRes = await pool.request()
            .input('Usuario', sql.NVarChar(200), sessionData.Usuario)
            .input('IdAplicacionConPermiso', sql.Int, 40)
            .execute('SeguridadUnificada_Identidad_Select');
          const spRow = spRes.recordset[0] || {};
          nombreFull = nombreFull || (spRow.Nombre || spRow.NombreCompleto || '');
          usuario = usuario || (spRow.Usuario || sessionData.Usuario || '');
        } catch (e) {
          // Ignore SP errors and continue to other fallbacks
          console.warn('[WARN] resolveIdPersonal: SP fallback falló:', e.message);
        }
      }

      if ((!nombreFull && !usuario) && lookupIdIdentidad) {
        const ident = await pool.request()
          .input('IdIdentidad', sql.Int, lookupIdIdentidad)
          .query('SELECT TOP 1 * FROM SeguridadUnificada_Identidad WHERE IdIdentidad = @IdIdentidad');
        const usuarioRow = ident.recordset[0] || {};
        nombreFull = nombreFull || (usuarioRow.Nombre || usuarioRow.UsuarioNombre || usuarioRow.UsuarioNombreSimple || usuarioRow.NombreCompleto || '');
        usuario = usuario || (usuarioRow.Usuario || usuarioRow.UsuarioNombre || '');
        console.log('[DEBUG] resolveIdPersonal: identidad row keys:', Object.keys(usuarioRow));
        console.log('[DEBUG] resolveIdPersonal: identidad row sample:', usuarioRow);
      }

      if (nombreFull || usuario) {
        const parts = (nombreFull || '').replace(/\s+/g, ' ').split(' ').filter(Boolean);
        const first = parts[0] || '';
        const second = parts.length > 1 ? parts[1] : '';

        const candReq = pool.request()
          .input('first', sql.VarChar(200), first ? `%${first}%` : null)
          .input('second', sql.VarChar(200), second ? `%${second}%` : null)
          .input('usuario', sql.VarChar(200), usuario || null);

        const candQ = `
          SELECT TOP 1 IdPersonal
          FROM dbo.gf_Personal
          WHERE (@first IS NOT NULL AND @second IS NOT NULL AND Nombre LIKE @first AND PrimerApellido LIKE @second)
             OR (@usuario IS NOT NULL AND Documento = @usuario)
        `;

        const cand = await candReq.query(candQ);
        const found = cand.recordset[0]?.IdPersonal ?? null;
        if (found) {
          console.log('[WARN] resolveIdPersonal: matched by name/usuario → IdPersonal:', found);
          return found;
        }
      }
    } catch (e) {
      console.warn('[WARN] resolveIdPersonal fallback falló:', e.message);
    }

    return null;
  } catch (err) {
    console.warn('[WARN] resolveIdPersonal falló:', err.message);
    return null;
  }
}

function toTinyIntOrNull(value) {
  if (value === null || value === undefined) return null;
  if (typeof value === 'boolean') return value ? 1 : 0;
  if (typeof value === 'number') return Number.isFinite(value) ? (value ? 1 : 0) : null;
  const raw = String(value).trim().toLowerCase();
  if (!raw) return null;
  if (['1', 'si', 'sí', 's', 'true', 't', 'yes', 'y'].includes(raw)) return 1;
  if (['0', 'no', 'n', 'false', 'f'].includes(raw)) return 0;
  return null;
}

function toIntOrNull(value) {
  if (value === null || value === undefined) return null;
  const n = Number(value);
  return Number.isFinite(n) ? n : null;
}

function registerIpcHandlers() {

  // ── LOGIN ────────────────────────────────────────────────────
  ipcMain.handle('auth:login', async (_event, { user, password }) => {
    try {
      const info = await authenticateUser({ user, password });
      currentSession = info;
      console.log('[DEBUG] auth:login session keys:', Object.keys(currentSession || {}));
      console.log('[DEBUG] auth:login session sample:', currentSession);
      // Resolver IdPersonal a partir del IdIdentidad para filtrar tareas por usuario
      currentSession._idPersonal = await resolveIdPersonal(currentSession.IdIdentidad, currentSession);
      console.log('[DEBUG] auth:login IdIdentidad:', currentSession.IdIdentidad, '→ IdPersonal:', currentSession._idPersonal);
      console.log('[DEBUG] IdUsuario sesión:', currentSession.IdUsuario);
      console.log('[DEBUG] IdIdentidad sesión:', currentSession.IdIdentidad);
      return { ok: true, data: info };
    } catch (err) {
      let msg;
      if (err.message === 'NO_CONFIG') {
        msg = 'No hay configuración de conexión. Configura el servidor primero.';
      } else if (err.message === 'NO_PERMISO') {
        msg = 'Usuario o contraseña incorrectos.';
      } else if (err.message.includes('network') || err.message.includes('connect') || err.message.includes('ECONNREFUSED')) {
        msg = 'No se pudo conectar al servidor. Revisa la configuración de conexión.';
      } else {
        msg = 'Error al iniciar sesión: ' + err.message;
      }
      return { ok: false, error: msg };
    }
  });

  // ── SESIÓN ACTUAL ────────────────────────────────────────────
  ipcMain.handle('auth:getSession', async () => {
    if (!currentSession) return { ok: false, data: null };
    return {
      ok: true,
      data: {
        // Los campos exactos dependen del SP SeguridadUnificada_Identidad_Select.
        // Ajusta los nombres de columna si difieren en tu BD.
        id: currentSession.Id || currentSession.IdIdentidad || null,
        idPersonal: currentSession._idPersonal ?? null,
        nombre: currentSession.Nombre || currentSession.NombreCompleto || '',
      }
    };
  });

  // ── AUTH: chequeo automático usuario Windows ─────────────────
  ipcMain.handle('auth:checkWindows', async () => {
    try {
      const data = await checkWindowsUser();
      currentSession = data;
      console.log('[DEBUG] auth:checkWindows session keys:', Object.keys(currentSession || {}));
      console.log('[DEBUG] auth:checkWindows session sample:', currentSession);
      currentSession._idPersonal = await resolveIdPersonal(currentSession.IdIdentidad, currentSession);
      console.log('[DEBUG] auth:checkWindows IdIdentidad:', currentSession.IdIdentidad, '→ IdPersonal:', currentSession._idPersonal);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  // ── CONEXIÓN: probar sin guardar ─────────────────────────────
  ipcMain.handle('db:testConnection', async (_event, params) => {
    try {
      const info = await testConnectionWith(params);
      return { ok: true, data: info };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  // ── CONEXIÓN: guardar configuración ─────────────────────────
  ipcMain.handle('db:saveConfig', async (_event, config) => {
    try {
      saveConfig(config);
      return { ok: true };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  // ── CONEXIÓN: leer configuración guardada ────────────────────
  ipcMain.handle('db:getConfig', async () => {
    try {
      const config = readConfig();
      return {
        ok: true, data: {
          server: config.server,
          database: config.database,
          conexiones: config.conexiones
        }
      };
    } catch {
      return { ok: false, data: null };
    }
  });

  // ── FONDO ────────────────────────────────────────────────────
  ipcMain.handle('config:setFondo', async (_e, { fondo }) => {
    try {
      saveFondo(fondo);
      return { ok: true };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('config:getFondo', async () => {
    try {
      const fondo = getFondo();
      return { fondo };
    } catch {
      return { fondo: null };
    }
  });

  // ── TAREAS ───────────────────────────────────────────────────
  ipcMain.handle('tareas:getAll', async (_e, filtros) => {
    const finalFiltros = { ...(filtros || {}) };
    if (currentSession) {
      if (finalFiltros.idSociedad == null) {
        const sesionIdSociedad = toIntOrNull(currentSession.IdSociedad ?? currentSession.IdSociedadId);
        if (sesionIdSociedad != null) finalFiltros.idSociedad = sesionIdSociedad;
      }
      // Filtrar tareas por el IdPersonal del usuario autenticado.
      // _idPersonal se resuelve al hacer login cruzando gf_Personal.IdIdentidad.
      if (finalFiltros.idPersonalAsignado == null) {
        if (currentSession._idPersonal != null) {
          finalFiltros.idPersonalAsignado = currentSession._idPersonal;
        } else {
          // No existe mapeo entre IdIdentidad e IdPersonal: por seguridad
          // devolvemos lista vacía para que el usuario no vea tareas ajenas.
          return { ok: true, data: [] };
        }
      }
    }
    return TareaController.getAll(finalFiltros);
  });
  ipcMain.handle('tareas:getById', async (_e, id) => TareaController.getById(id));
  ipcMain.handle('tareas:create', async (_e, datos) => {
    if (currentSession) {
      if (datos) {
        const sesionIdSociedad = toIntOrNull(currentSession.IdSociedad ?? currentSession.IdSociedadId);
        if (sesionIdSociedad != null) datos.idSociedad = sesionIdSociedad;

        const sesionPublicada = toTinyIntOrNull(currentSession.Publicada ?? currentSession.Publicado);
        if (sesionPublicada != null) datos.publicada = sesionPublicada;
      }
    }
    return TareaController.create(datos);
  });
  ipcMain.handle('tareas:update', async (_e, { id, datos }) => TareaController.update(id, datos));
  ipcMain.handle('tareas:delete', async (_e, id) => TareaController.delete(id));

  // Tiempos de tarea
  ipcMain.handle('tareas:getTiempos', async (_e, idTarea) => TareaController.getTiempos(idTarea));

  ipcMain.handle('tareas:registrarTiempo', async (_e, payload) => {
    // Si el frontend no envía idIdentidad, usar el de la sesión activa
    if (!payload.idIdentidad && currentSession) {
      payload.idIdentidad = currentSession.Id || currentSession.IdIdentidad || null;
    }
    return TareaController.registrarTiempo(payload);
  });

  // Listado de tiempos (una fila por registro)
  ipcMain.handle('tiempos:getAll', async (_e, filtros) => {
    const finalFiltros = { ...(filtros || {}) };
    if (currentSession) {
      if (finalFiltros.idSociedad == null) {
        const sesionIdSociedad = toIntOrNull(currentSession.IdSociedad ?? currentSession.IdSociedadId);
        if (sesionIdSociedad != null) finalFiltros.idSociedad = sesionIdSociedad;
      }
      // Forzar filtro por responsable autenticado
      if (currentSession._idPersonal != null) {
        finalFiltros.idPersonalAsignado = currentSession._idPersonal;
      } else {
        return { ok: true, data: [] };
      }
    }
    return TareaController.getTiemposListado(finalFiltros);
  });

  ipcMain.handle('tiempos:create', async (_e, payload) => {
    if (!payload) return { ok: false, error: 'Payload vacío.' };
    if (!payload.idIdentidad && currentSession) {
      payload.idIdentidad = currentSession.Id || currentSession.IdIdentidad || null;
    }
    return TareaController.createTiempo(payload);
  });

  ipcMain.handle('tiempos:update', async (_e, payload) => {
    if (!payload) return { ok: false, error: 'Payload vacío.' };
    if (!payload.idIdentidad && currentSession) {
      payload.idIdentidad = currentSession.Id || currentSession.IdIdentidad || null;
    }
    return TareaController.updateTiempo(payload);
  });

  ipcMain.handle('tiempos:delete', async (_e, payload) => {
    if (!payload) return { ok: false, error: 'Payload vacío.' };
    return TareaController.deleteTiempo(payload);
  });

  // ── CLIENTES ─────────────────────────────────────────────────
  ipcMain.handle('clientes:getAll', async (_e, filtros) => ClienteController.getAll(filtros));
  ipcMain.handle('clientes:getById', async (_e, id) => ClienteController.getById(id));
  ipcMain.handle('clientes:create', async (_e, datos) => ClienteController.create(datos));
  ipcMain.handle('clientes:update', async (_e, { id, datos }) => ClienteController.update(id, datos));
  ipcMain.handle('clientes:delete', async (_e, id) => ClienteController.delete(id));

  // ── PRESUPUESTOS ─────────────────────────────────────────────
  ipcMain.handle('presupuestos:getAll', async (_e, filtros) => PresupuestoController.getAll(filtros));
  ipcMain.handle('presupuestos:getById', async (_e, id) => PresupuestoController.getById(id));
  ipcMain.handle('presupuestos:getLineas', async (_e, id) => PresupuestoController.getLineas(id));
  ipcMain.handle('presupuestos:create', async (_e, datos) => PresupuestoController.create(datos));
  ipcMain.handle('presupuestos:update', async (_e, { id, datos }) => PresupuestoController.update(id, datos));
  ipcMain.handle('presupuestos:delete', async (_e, id) => PresupuestoController.delete(id));

  // ── CONTACTOS ────────────────────────────────────────────────
  ipcMain.handle('contactos:getAll', async (_e, filtros) => {
    const finalFiltros = { ...(filtros || {}) };
    if (currentSession && finalFiltros.idPersonal == null) {
      if (currentSession._idPersonal != null) {
        finalFiltros.idPersonal = currentSession._idPersonal;
      }
    }
    return ContactoController.getAll(finalFiltros);
  });
  ipcMain.handle('contactos:getById', async (_e, id) => ContactoController.getById(id));
  ipcMain.handle('contactos:create', async (_e, datos) => ContactoController.create(datos));
  ipcMain.handle('contactos:update', async (_e, { id, datos }) => ContactoController.update(id, datos));
  ipcMain.handle('contactos:delete', async (_e, id) => ContactoController.delete(id));

  // ── PERSONAL ─────────────────────────────────────────────────
  ipcMain.handle('personal:getAll', async (_e, filtros) => {
    try {
      const data = await PersonalModel.getAll(filtros || {});
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  // ── SHELL ─────────────────────────────────────────────────────
  ipcMain.handle('shell:openPath', async (_e, rutaPath) => {
    const err = await shell.openPath(rutaPath);
    if (err) return { ok: false, error: err };
    return { ok: true };
  });

  // ── DIALOG ───────────────────────────────────────────────────
  ipcMain.handle('dialog:openCarpeta', async () => {
    const result = await dialog.showOpenDialog({
      title: 'Seleccionar carpeta de trabajo',
      properties: ['openDirectory']
    });
    if (result.canceled || result.filePaths.length === 0) return { filePath: null };
    return { filePath: result.filePaths[0] };
  });

  // Si se establece RUN_IPC_TEST=1, ejecutar una comprobación rápida de clientes
  if (process.env.RUN_IPC_TEST === '1') {
    (async () => {
      try {
        const res = await ClienteController.getAll({});
        console.log('[TEST] clientes:getAll →', JSON.stringify(res, null, 2));
      } catch (err) {
        console.error('[TEST] clientes:getAll error →', err && err.message ? err.message : err);
      }
    })();
  }

  console.log('[IPC] Todos los handlers registrados');
}

module.exports = { registerIpcHandlers };
