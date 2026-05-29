/* ═══════════════════════════════════════════════
   IPC/IPCHANDLERS.JS
   ═══════════════════════════════════════════════ */

const { ipcMain, shell, dialog, app, BrowserWindow } = require('electron');
const os = require('os');
const path = require('path');
const fs = require('fs/promises');

const { authenticateUser, checkWindowsUser, testConnectionWith, saveConfig, readConfig, saveFondo, getFondo, getPool, sql } = require('../database/db');
const { checkForUpdates, launchUpdaterAndQuit } = require('../update/updateService');

const TareaController = require('../controllers/TareaController');
const ClienteController = require('../controllers/ClienteController');
const PresupuestoController = require('../controllers/PresupuestoController');
const ContactoController = require('../controllers/ContactoController');
const PersonalModel = require('../models/PersonalModel');
const PresenciaController = require('../controllers/PresenciaController');

// ── Sesión del usuario autenticado ───────────────────────────
// Se guarda al hacer login y se expone vía auth:getSession.
// currentSession._idPersonal se resuelve tras el login cruzando
// gf_Personal.IdIdentidad con el IdIdentidad del usuario autenticado.
let currentSession = null;

function getLocalIpAddress() {
  const nets = os.networkInterfaces();
  for (const name of Object.keys(nets)) {
    const items = nets[name] || [];
    for (const net of items) {
      if (!net) continue;
      if (net.family === 'IPv4' && !net.internal) {
        return net.address;
      }
    }
  }
  return '';
}

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

function parseFichajeDateFromRow(row) {
  if (!row) return null;
  const raw = row?.FechaHora ?? row?.Fecha ?? row?.FechaRegistro ?? row?.FechaHoraLocal ?? row?.fechaHora ?? row?.fechahora;
  if (raw) {
    const d = new Date(raw);
    if (!Number.isNaN(d.getTime())) return d;
  }
  const fecha = row?.Fecha ?? row?.fecha;
  const hora = row?.Hora ?? row?.hora;
  if (fecha && hora) {
    const fechaTxt = String(fecha).substring(0, 10);
    const horaTxt = String(hora).substring(0, 8);
    const d = new Date(`${fechaTxt}T${horaTxt}`);
    if (!Number.isNaN(d.getTime())) return d;
  }
  return null;
}

function parseFichajeDateFromPayload(payload) {
  if (!payload) return null;
  if (payload.fechaHora) {
    const d = new Date(payload.fechaHora);
    if (!Number.isNaN(d.getTime())) return d;
  }
  if (payload.fecha && payload.hora) {
    const d = new Date(`${payload.fecha}T${payload.hora}:00`);
    if (!Number.isNaN(d.getTime())) return d;
  }
  return null;
}

function normalizeFichajeForAudit(row) {
  if (!row) return null;
  const dt = parseFichajeDateFromRow(row);
  const idRaw = row?.IdControlPresenciaFichaje ?? row?.Id ?? row?.id ?? null;
  const tipoRaw =
    row?.IdControlPresenciaTipoEvento ??
    row?.IdTipoEvento ??
    row?.TipoEventoId ??
    row?.IdTipo ??
    row?.IdControlPresenciaTipo ??
    null;
  const comentarios = row?.Comentarios ?? row?.Comentario ?? row?.Observaciones ?? null;
  const dispositivo = row?.IpDispositivo ?? row?.Dispositivo ?? row?.Equipo ?? null;

  return {
    id: idRaw != null ? Number(idRaw) : null,
    tipoEvento: tipoRaw != null ? Number(tipoRaw) : null,
    fechaHoraIso: dt ? dt.toISOString() : null,
    fechaHoraLocal: dt ? dt.toLocaleString('es-ES', { hour12: false }) : null,
    comentarios: comentarios != null ? String(comentarios) : null,
    dispositivo: dispositivo != null ? String(dispositivo) : null
  };
}

function normalizeAfterFromPayload(payload, before = null) {
  if (!payload && !before) return null;
  const dt = parseFichajeDateFromPayload(payload);
  const idRaw = payload?.idControlPresenciaFichaje ?? before?.id ?? null;
  const tipoRaw = payload?.idControlPresenciaTipoEvento ?? before?.tipoEvento ?? null;
  return {
    id: idRaw != null ? Number(idRaw) : null,
    tipoEvento: tipoRaw != null ? Number(tipoRaw) : null,
    fechaHoraIso: dt ? dt.toISOString() : null,
    fechaHoraLocal: dt ? dt.toLocaleString('es-ES', { hour12: false }) : null,
    comentarios: before?.comentarios ?? null,
    dispositivo: before?.dispositivo ?? null
  };
}

function buildAuditUser(session) {
  if (!session) return null;
  return {
    idIdentidad: session.IdIdentidad ?? session.Id ?? null,
    idUsuario: session.IdUsuario ?? null,
    idPersonal: session._idPersonal ?? null,
    nombre: session.Nombre || session.NombreCompleto || session.UsuarioNombre || session.Usuario || '',
    usuario: session.Usuario || session.UsuarioNombre || ''
  };
}

function truncateValue(value, maxLen) {
  if (value === null || value === undefined) return null;
  const str = String(value);
  if (str.length <= maxLen) return str;
  const keep = Math.max(0, maxLen - 3);
  return str.slice(0, keep) + '...';
}

function formatLogDateTime(iso) {
  if (!iso) return null;
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return String(iso);
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  const h = String(d.getHours()).padStart(2, '0');
  const min = String(d.getMinutes()).padStart(2, '0');
  const s = String(d.getSeconds()).padStart(2, '0');
  return `${y}-${m}-${day} ${h}:${min}:${s}`;
}

function buildLogResumen(audit) {
  if (!audit) return null;
  const parts = [];
  if (audit.fechaHoraIso) parts.push(`fechaHora=${formatLogDateTime(audit.fechaHoraIso)}`);
  if (audit.tipoEvento != null) parts.push(`tipo=${audit.tipoEvento}`);
  if (audit.comentarios) parts.push(`comentario=${audit.comentarios}`);
  if (audit.dispositivo) parts.push(`ip=${audit.dispositivo}`);
  return parts.length ? parts.join('; ') : null;
}

function resolveAuditUserName(session) {
  if (!session) return '';
  return String(
    session.Usuario ||
    session.UsuarioNombre ||
    session.Nombre ||
    session.NombreCompleto ||
    ''
  ).trim();
}

async function insertHorarioAuditLogs(entries, session) {
  if (!entries || !entries.length) return;
  try {
    const pool = await getPool();
    const usuario = resolveAuditUserName(session);
    for (const entry of entries) {
      if (!entry || entry.idControlPresenciaFichaje == null) continue;
      const idValue = Number(entry.idControlPresenciaFichaje);
      if (!Number.isFinite(idValue)) continue;
      await pool.request()
        .input('IdControlPresenciaFichaje', sql.Int, idValue)
        .input('FechaHoraModificacion', sql.DateTime, entry.fechaHoraModificacion || new Date())
        .input('UsuarioModificacion', sql.NVarChar(100), truncateValue(usuario, 100) || 'Sistema')
        .input('Accion', sql.NVarChar(10), truncateValue(entry.accion || '', 10))
        .input('CampoModificado', sql.NVarChar(100), truncateValue(entry.campoModificado || '', 100))
        .input('ValorAnterior', sql.NVarChar(255), truncateValue(entry.valorAnterior, 255))
        .input('ValorNuevo', sql.NVarChar(255), truncateValue(entry.valorNuevo, 255))
        .input('Motivo', sql.NVarChar(500), truncateValue(entry.motivo, 500))
        .query(`
          INSERT INTO dbo.ControlPresencia_Fichajes_Logs
          (IdControlPresenciaFichaje, FechaHoraModificacion, UsuarioModificacion, Accion, CampoModificado, ValorAnterior, ValorNuevo, Motivo)
          VALUES
          (@IdControlPresenciaFichaje, @FechaHoraModificacion, @UsuarioModificacion, @Accion, @CampoModificado, @ValorAnterior, @ValorNuevo, @Motivo)
        `);
    }
  } catch (err) {
    console.warn('[WARN] No se pudo guardar el log de auditoria en BD:', err.message);
  }
}

function parseDateOnly(value) {
  if (!value) return null;
  const txt = String(value).trim();
  if (!/^\d{4}-\d{2}-\d{2}$/.test(txt)) return null;
  const d = new Date(`${txt}T00:00:00`);
  if (Number.isNaN(d.getTime())) return null;
  return d;
}

async function fetchFichajesLogs({ desde, hasta }) {
  const pool = await getPool();
  const desdeDate = parseDateOnly(desde);
  const hastaDate = parseDateOnly(hasta);
  const request = pool.request()
    .input('Desde', sql.DateTime, desdeDate)
    .input('Hasta', sql.DateTime, hastaDate);

  const query = `
    SELECT
      l.IdControlPresenciaFichajeLog,
      l.IdControlPresenciaFichaje,
      l.FechaHoraModificacion,
      l.UsuarioModificacion,
      l.Accion,
      l.CampoModificado,
      l.ValorAnterior,
      l.ValorNuevo,
      l.Motivo
    FROM dbo.ControlPresencia_Fichajes_Logs l
    WHERE (@Desde IS NULL OR l.FechaHoraModificacion >= @Desde)
      AND (@Hasta IS NULL OR l.FechaHoraModificacion < DATEADD(DAY, 1, @Hasta))
    ORDER BY l.FechaHoraModificacion DESC, l.IdControlPresenciaFichajeLog DESC
  `;

  const result = await request.query(query);
  return result.recordset || [];
}

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\"/g, '&quot;')
    .replace(/'/g, '&#39;');
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

  // ── PRESENCIA ────────────────────────────────────────────────
  ipcMain.handle('presencia:getEstadoActual', async () => {
    if (!currentSession) return { ok: false, error: 'No autorizado' };
    const idPersonal = currentSession._idPersonal;
    if (idPersonal == null) return { ok: false, error: 'IdPersonal no disponible en la sesi\u00f3n' };
    try {
      const data = await PresenciaController.getEstadoActual(idPersonal);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('presencia:registrarFichaje', async (_e, { idControlPresenciaTipoEvento, comentarios }) => {
    if (!currentSession) return { ok: false, error: 'No autorizado' };
    const idPersonal = currentSession._idPersonal;
    if (idPersonal == null) return { ok: false, error: 'IdPersonal no disponible en la sesi\u00f3n' };
    try {
      const ipDispositivo = getLocalIpAddress();
      const resp = await PresenciaController.registrarFichaje(idPersonal, idControlPresenciaTipoEvento, ipDispositivo, comentarios);
      return resp;
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('presencia:updateComentario', async (_e, { idControlPresenciaFichaje, comentarios }) => {
    if (!currentSession) return { ok: false, error: 'No autorizado' };
    try {
      return await PresenciaController.updateComentario(idControlPresenciaFichaje, comentarios || '');
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('presencia:updateFichaje', async (_e, payload) => {
    if (!currentSession) return { ok: false, error: 'No autorizado' };
    try {
      const data = payload || {};
      const before = normalizeFichajeForAudit(data.before);
      const motivo = String(data.motivo ?? data.reason ?? '').trim();
      const result = await PresenciaController.updateFichaje(data);

      if (result && result.ok) {
        const after = normalizeAfterFromPayload(data, before);
        const idFichaje = data.idControlPresenciaFichaje ?? before?.id ?? after?.id ?? null;
        const fechaHoraAntes = formatLogDateTime(before?.fechaHoraIso);
        const fechaHoraDespues = formatLogDateTime(after?.fechaHoraIso);
        const cambios = [];

        if (before && after) {
          if (before.fechaHoraIso !== after.fechaHoraIso) {
            cambios.push({
              idControlPresenciaFichaje: idFichaje,
              fechaHoraModificacion: new Date(),
              accion: 'UPDATE',
              campoModificado: 'FechaHora',
              valorAnterior: fechaHoraAntes,
              valorNuevo: fechaHoraDespues,
              motivo: motivo || null
            });
          }
          if (before.tipoEvento !== after.tipoEvento) {
            cambios.push({
              idControlPresenciaFichaje: idFichaje,
              fechaHoraModificacion: new Date(),
              accion: 'UPDATE',
              campoModificado: 'IdControlPresenciaTipoEvento',
              valorAnterior: before.tipoEvento != null ? String(before.tipoEvento) : null,
              valorNuevo: after.tipoEvento != null ? String(after.tipoEvento) : null,
              motivo: motivo || null
            });
          }
        }

        if (!cambios.length) {
          cambios.push({
            idControlPresenciaFichaje: idFichaje,
            fechaHoraModificacion: new Date(),
            accion: 'UPDATE',
            campoModificado: 'Registro',
            valorAnterior: buildLogResumen(before),
            valorNuevo: buildLogResumen(after),
            motivo: motivo || null
          });
        }

        await insertHorarioAuditLogs(cambios, currentSession);
      }

      return result;
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('presencia:deleteFichaje', async (_e, payload) => {
    if (!currentSession) return { ok: false, error: 'No autorizado' };
    try {
      const data = payload || {};
      const before = normalizeFichajeForAudit(data.before);
      const motivo = String(data.motivo ?? data.reason ?? '').trim();
      const result = await PresenciaController.deleteFichaje(data.idControlPresenciaFichaje);

      if (result && result.ok) {
        const idFichaje = data.idControlPresenciaFichaje ?? before?.id ?? null;
        const cambios = [{
          idControlPresenciaFichaje: idFichaje,
          fechaHoraModificacion: new Date(),
          accion: 'DELETE',
          campoModificado: 'Registro',
          valorAnterior: buildLogResumen(before),
          valorNuevo: null,
          motivo: motivo || null
        }];
        await insertHorarioAuditLogs(cambios, currentSession);
      }

      return result;
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('presencia:exportInformePdf', async (_event, { fecha, fechaDesde, fechaHasta, tramos, userName } = {}) => {
    if (!currentSession) return { ok: false, error: 'No autorizado' };
    try {
      const today = new Date();
      const fallbackDate = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
      const safeSingle = /^\d{4}-\d{2}-\d{2}$/.test(String(fecha || '')) ? fecha : null;
      const safeDesde = /^\d{4}-\d{2}-\d{2}$/.test(String(fechaDesde || '')) ? fechaDesde : null;
      const safeHasta = /^\d{4}-\d{2}-\d{2}$/.test(String(fechaHasta || '')) ? fechaHasta : null;
      const safeDate = safeSingle || (safeDesde && safeHasta && safeDesde === safeHasta ? safeDesde : null) || fallbackDate;
      const rangeSuffix = (safeDesde && safeHasta && safeDesde !== safeHasta)
        ? `${safeDesde}_a_${safeHasta}`
        : safeDate;

      // ── Helpers de formato ───────────────────────────────
      const fmt2 = n => String(n).padStart(2, '0');
      const fmtFecha = iso => {
        if (!iso) return '-';
        const d = new Date(iso);
        if (isNaN(d)) return iso;
        return `${fmt2(d.getDate())}/${fmt2(d.getMonth() + 1)}/${d.getFullYear()}`;
      };
      const fmtHora = iso => {
        if (!iso) return '';
        const d = new Date(iso);
        if (isNaN(d)) return '';
        return `${fmt2(d.getHours())}:${fmt2(d.getMinutes())}`;
      };
      const fmtFechaHora = iso => {
        const f = fmtFecha(iso);
        const h = fmtHora(iso);
        return h ? `${f} ${h}` : f;
      };
      const fmtTiempo = totalMin => {
        const mins = Math.max(0, Math.round(totalMin || 0));
        const h = Math.floor(mins / 60);
        const m = mins % 60;
        return `${h} h ${fmt2(m)} min`;
      };

      // ── Colores de eventos ────────────────────────────────
      const dotColor = label => {
        const l = String(label || '').toLowerCase();
        if (l.includes('entrada')) return '#22c55e';
        if (l.includes('fin')) return '#3b82f6';
        if (l.includes('pausa')) return '#f59e0b';
        if (l.includes('salida')) return '#ef4444';
        return '#94a3b8';
      };

      // ── Agrupar tramos por día ────────────────────────────
      const tramosArr = Array.isArray(tramos) ? tramos : [];
      const dayMap = new Map();
      tramosArr.forEach(t => {
        const dk = t.dayKey || '';
        if (!dayMap.has(dk)) dayMap.set(dk, []);
        dayMap.get(dk).push(t);
      });

      // ── Generar filas HTML ────────────────────────────────
      let rowsHtml = '';
      let totalRegistros = tramosArr.length;

      dayMap.forEach((dayTramos, dayKey) => {
        let dayTotal = 0;
        dayTramos.forEach(t => {
          const entradaIso = t.entrada ? (typeof t.entrada === 'string' ? t.entrada : new Date(t.entrada).toISOString()) : null;
          const salidaIso = t.salida ? (typeof t.salida === 'string' ? t.salida : new Date(t.salida).toISOString()) : null;
          const dotE = dotColor(t.entradaLabel);
          const dotS = dotColor(t.salidaLabel);
          const entradaTxt = entradaIso
            ? `<span class="mono">${fmtFechaHora(entradaIso)}</span> <span class="dot" style="background:${dotE}"></span> <span class="evt">${t.entradaLabel || ''}</span>`
            : '-';
          const salidaTxt = salidaIso
            ? `<span class="mono">${fmtFechaHora(salidaIso)}</span> <span class="dot" style="background:${dotS}"></span> <span class="evt">${t.salidaLabel || ''}</span>`
            : '<span class="mono">-</span>';
          const tiempoMins = t.totalMin || 0;
          dayTotal += tiempoMins;
          rowsHtml += `
            <tr>
              <td>${entradaTxt}</td>
              <td>${salidaTxt}</td>
              <td class="mono time-col">${fmtTiempo(tiempoMins)}</td>
            </tr>`;
        });

        // Fila resumen del día
        rowsHtml += `
          <tr class="resumen-row">
            <td colspan="2" class="resumen-label">Resumen ${dayKey}</td>
            <td class="mono resumen-time">${fmtTiempo(dayTotal)}</td>
          </tr>`;
      });

      if (!rowsHtml) {
        rowsHtml = '<tr><td colspan="3" style="text-align:center;padding:20px;color:#94a3b8">Sin registros.</td></tr>';
      }

      const rangoLabel = (safeDesde && safeHasta && safeDesde !== safeHasta)
        ? `${fmtFecha(safeDesde + 'T00:00:00')} – ${fmtFecha(safeHasta + 'T00:00:00')}`
        : fmtFecha(safeDate + 'T00:00:00');

      // ── Documento HTML completo ───────────────────────────
      const htmlContent = `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Informe Presencia</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; font-size: 13px; color: #1e293b; background: #fff; padding: 32px; }
  .header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid #e2e8f0; padding-bottom: 14px; margin-bottom: 20px; }
  .header-left .titulo { font-size: 11px; font-weight: 700; letter-spacing: 0.08em; color: #64748b; text-transform: uppercase; }
  .header-left .trabajador { font-size: 13px; color: #334155; margin-top: 4px; }
  .header-right { font-size: 12px; color: #94a3b8; text-align: right; }
  .header-right .rango { font-size: 12px; color: #64748b; margin-top: 4px; }
  table { width: 100%; border-collapse: collapse; }
  thead tr { background: #f8fafc; }
  thead th { text-align: left; padding: 8px 12px; font-size: 10px; font-weight: 700; letter-spacing: 0.07em; color: #64748b; text-transform: uppercase; border-bottom: 1px solid #e2e8f0; }
  tbody tr { border-bottom: 1px solid #f1f5f9; }
  tbody tr:last-child { border-bottom: none; }
  tbody td { padding: 9px 12px; vertical-align: middle; color: #334155; }
  .mono { font-family: 'Courier New', Courier, monospace; font-size: 12px; }
  .dot { display: inline-block; width: 8px; height: 8px; border-radius: 50%; vertical-align: middle; margin: 0 4px; }
  .evt { font-size: 12px; color: #334155; }
  .time-col { color: #334155; }
  .resumen-row { background: #f8fafc; }
  .resumen-row .resumen-label { color: #1e293b; font-weight: 600; font-size: 12px; padding: 10px 12px; }
  .resumen-row .resumen-time { color: #1e293b; font-weight: 700; font-size: 13px; }
</style>
</head>
<body>
  <div class="header">
    <div class="header-left">
      <div class="titulo">Resumen</div>
      <div class="trabajador">Trabajador: <strong>${userName || '-'}</strong></div>
    </div>
    <div class="header-right">
      <div>${totalRegistros} registros</div>
      <div class="rango">${rangoLabel}</div>
    </div>
  </div>
  <table>
    <thead>
      <tr>
        <th>Entradas</th>
        <th>Salidas</th>
        <th>Tiempo</th>
      </tr>
    </thead>
    <tbody>
      ${rowsHtml}
    </tbody>
  </table>
</body>
</html>`;

      // ── Renderizar en ventana oculta y exportar PDF ───────
      const win = new BrowserWindow({
        show: false,
        width: 900,
        height: 1200,
        webPreferences: { nodeIntegration: false, contextIsolation: true }
      });

      await win.loadURL('data:text/html;charset=utf-8,' + encodeURIComponent(htmlContent));

      const pdfBuffer = await win.webContents.printToPDF({
        pageSize: 'A4',
        printBackground: true,
        marginsType: 0,
        margins: { top: 0, bottom: 0, left: 0, right: 0 }
      });

      win.destroy();

      const downloads = app.getPath('downloads');
      const fileName = `InformePresencia_${rangeSuffix}.pdf`;
      const filePath = path.join(downloads, fileName);
      await fs.writeFile(filePath, pdfBuffer);

      return { ok: true, filePath, fileName };
    } catch (err) {
      console.error('Error exportInformePdf:', err);
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('presencia:getFichajesPersonales', async (_e, { fechaFiltro } = {}) => {
    if (!currentSession) return { ok: false, error: 'No autorizado' };
    const idPersonal = currentSession._idPersonal;
    if (idPersonal == null) return { ok: false, error: 'IdPersonal no disponible en la sesi\u00f3n' };
    try {
      const data = await PresenciaController.getFichajesPersonales(idPersonal, fechaFiltro || null);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('presencia:getFichajesLogs', async (_e, { desde, hasta } = {}) => {
    if (!currentSession) return { ok: false, error: 'No autorizado' };
    try {
      const data = await fetchFichajesLogs({ desde, hasta });
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  });

  ipcMain.handle('presencia:exportFichajesLogsPdf', async (_event, { desde, hasta, userName } = {}) => {
    if (!currentSession) return { ok: false, error: 'No autorizado' };
    try {
      const rows = await fetchFichajesLogs({ desde, hasta });

      const today = new Date();
      const fallbackDate = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
      const safeDesde = /^\d{4}-\d{2}-\d{2}$/.test(String(desde || '')) ? desde : null;
      const safeHasta = /^\d{4}-\d{2}-\d{2}$/.test(String(hasta || '')) ? hasta : null;
      const rangeSuffix = (safeDesde && safeHasta && safeDesde !== safeHasta)
        ? `${safeDesde}_a_${safeHasta}`
        : (safeDesde || safeHasta || fallbackDate);

      const fmt2 = n => String(n).padStart(2, '0');
      const fmtFecha = isoDate => {
        if (!isoDate) return '-';
        const d = new Date(isoDate);
        if (Number.isNaN(d.getTime())) return isoDate;
        return `${fmt2(d.getDate())}/${fmt2(d.getMonth() + 1)}/${d.getFullYear()}`;
      };
      const fmtFechaHora = iso => {
        if (!iso) return '-';
        const d = new Date(iso);
        if (Number.isNaN(d.getTime())) return String(iso);
        return `${fmtFecha(d)} ${fmt2(d.getHours())}:${fmt2(d.getMinutes())}:${fmt2(d.getSeconds())}`;
      };

      const rangoLabel = (safeDesde && safeHasta && safeDesde !== safeHasta)
        ? `${fmtFecha(safeDesde + 'T00:00:00')} - ${fmtFecha(safeHasta + 'T00:00:00')}`
        : fmtFecha((safeDesde || safeHasta || fallbackDate) + 'T00:00:00');

      const rowsHtml = rows.length
        ? rows.map(r => `
            <tr>
              <td class="mono">${escapeHtml(fmtFechaHora(r.FechaHoraModificacion))}</td>
              <td>${escapeHtml(r.UsuarioModificacion || '')}</td>
              <td>${escapeHtml(r.Accion || '')}</td>
              <td>${escapeHtml(r.CampoModificado || '')}</td>
              <td class="wrap">${escapeHtml(r.ValorAnterior || '')}</td>
              <td class="wrap">${escapeHtml(r.ValorNuevo || '')}</td>
              <td class="wrap">${escapeHtml(r.Motivo || '')}</td>
              <td class="mono">${escapeHtml(r.IdControlPresenciaFichaje ?? '')}</td>
              <td class="mono">${escapeHtml(r.IdControlPresenciaFichajeLog ?? '')}</td>
            </tr>
          `).join('')
        : '<tr><td colspan="9" class="empty">Sin registros.</td></tr>';

      const htmlContent = `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Logs de horarios</title>
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; font-size: 12px; color: #1e293b; background: #fff; padding: 28px; }
  .header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 2px solid #e2e8f0; padding-bottom: 12px; margin-bottom: 18px; }
  .header-left .titulo { font-size: 11px; font-weight: 700; letter-spacing: 0.08em; color: #64748b; text-transform: uppercase; }
  .header-left .trabajador { font-size: 13px; color: #334155; margin-top: 4px; }
  .header-right { font-size: 12px; color: #94a3b8; text-align: right; }
  .header-right .rango { font-size: 12px; color: #64748b; margin-top: 4px; }
  table { width: 100%; border-collapse: collapse; }
  thead tr { background: #f8fafc; }
  thead th { text-align: left; padding: 8px 10px; font-size: 10px; font-weight: 700; letter-spacing: 0.07em; color: #64748b; text-transform: uppercase; border-bottom: 1px solid #e2e8f0; }
  tbody tr { border-bottom: 1px solid #f1f5f9; }
  tbody tr:last-child { border-bottom: none; }
  tbody td { padding: 8px 10px; vertical-align: top; color: #334155; }
  .mono { font-family: 'Courier New', Courier, monospace; font-size: 11px; white-space: nowrap; }
  .wrap { white-space: normal; }
  .empty { text-align: center; padding: 20px; color: #94a3b8; }
</style>
</head>
<body>
  <div class="header">
    <div class="header-left">
      <div class="titulo">Logs de horarios</div>
      <div class="trabajador">Trabajador: <strong>${escapeHtml(userName || '-')}</strong></div>
    </div>
    <div class="header-right">
      <div>${rows.length} registros</div>
      <div class="rango">${rangoLabel}</div>
    </div>
  </div>
  <table>
    <thead>
      <tr>
        <th>Fecha/Hora</th>
        <th>Usuario</th>
        <th>Acci\u00f3n</th>
        <th>Campo</th>
        <th>Valor Anterior</th>
        <th>Valor Nuevo</th>
        <th>Motivo</th>
        <th>ID Fichaje</th>
        <th>ID Log</th>
      </tr>
    </thead>
    <tbody>
      ${rowsHtml}
    </tbody>
  </table>
</body>
</html>`;

      const win = new BrowserWindow({
        show: false,
        width: 1200,
        height: 1200,
        webPreferences: { nodeIntegration: false, contextIsolation: true }
      });

      await win.loadURL('data:text/html;charset=utf-8,' + encodeURIComponent(htmlContent));
      const pdfBuffer = await win.webContents.printToPDF({
        pageSize: 'A4',
        printBackground: true,
        marginsType: 0,
        margins: { top: 0, bottom: 0, left: 0, right: 0 }
      });
      win.destroy();

      const downloads = app.getPath('downloads');
      const fileName = `LogsHorarios_${rangeSuffix}.pdf`;
      const filePath = path.join(downloads, fileName);
      await fs.writeFile(filePath, pdfBuffer);

      return { ok: true, filePath, fileName };
    } catch (err) {
      console.error('Error exportFichajesLogsPdf:', err);
      return { ok: false, error: err.message };
    }
  });

  // ── SHELL ─────────────────────────────────────────────────────
  ipcMain.handle('shell:openPath', async (_e, rutaPath) => {
    const err = await shell.openPath(rutaPath);
    if (err) return { ok: false, error: err };
    return { ok: true };
  });

  // ── UPDATE ────────────────────────────────────────────────
  ipcMain.handle('update:check', async () => {
    try {
      return await checkForUpdates();
    } catch (err) {
      return { ok: false, error: err && err.message ? err.message : String(err) };
    }
  });

  ipcMain.handle('update:launchUpdater', async () => {
    try {
      return await launchUpdaterAndQuit();
    } catch (err) {
      return { ok: false, error: err && err.message ? err.message : String(err) };
    }
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
