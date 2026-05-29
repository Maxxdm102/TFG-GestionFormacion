/* ═══════════════════════════════════════════════
   PRELOAD.JS — Puente seguro Renderer ↔ Main
   ═══════════════════════════════════════════════ */

const { contextBridge, ipcRenderer } = require('electron');

const ALLOWED_INVOKE_CHANNELS = [
  // Auth y configuración
  'auth:login',
  'auth:checkWindows',
  'auth:getSession',
  'db:testConnection',
  'db:saveConfig',
  'db:getConfig',
  'dialog:openFondo',
  'config:setFondo',
  'config:getFondo',
  // Shell
  'shell:openPath',
  // Update
  'update:launchUpdater',
  // Tareas
  'tareas:getAll', 'tareas:getById', 'tareas:create', 'tareas:update', 'tareas:delete',
  'tareas:getTiempos', 'tareas:registrarTiempo',
  // Tiempos
  'tiempos:getAll', 'tiempos:create', 'tiempos:update', 'tiempos:delete',
  // Clientes
  'clientes:getAll', 'clientes:getById', 'clientes:create', 'clientes:update', 'clientes:delete',
  // Presupuestos
  'presupuestos:getAll', 'presupuestos:getById', 'presupuestos:getLineas',
  'presupuestos:create', 'presupuestos:update', 'presupuestos:delete',
  // Contactos
  'contactos:getAll', 'contactos:getById', 'contactos:create', 'contactos:update', 'contactos:delete',
  // Personal
  'personal:getAll',
  // Presencia (Control de presencia / fichaje)
  'presencia:getEstadoActual',
  'presencia:registrarFichaje',
  'presencia:getFichajesPersonales',
  'presencia:updateComentario',
  'presencia:updateFichaje',
  'presencia:deleteFichaje',
  'presencia:exportInformePdf',
  'presencia:getFichajesLogs',
  'presencia:exportFichajesLogsPdf',

  'dialog:openCarpeta',
];

const ALLOWED_SEND_CHANNELS = [
  'open-conexion',
  'close-conexion',
  'login-success',
  'tiempos:open',
  'tiempos:setContext',
  'horarios:open',
  'horariosLogs:open',
  'presenciaInforme:open',
  'presenciaInforme:refresh',
  'fichaje:refresh',
  'presupuestos:open',
  'presupuestos:select',
  'presupuestos:selected',
  'presupuestos:setContext',
  'clientes:open',
  'clientes:select',
  'clientes:selected',
  'contactos:open',
  'contactos:setContext',
  'clientes:closed',
  'presupuestos:closed',
  'contactos:closed',
  'tareas:open',
  'tareas:setContext',
  'tareas:refresh',
  'tareas:close',
  'window-move',
  'login-close',
  'updater:start-update',
  'updater:available',
];

contextBridge.exposeInMainWorld('api', {
  invoke: (channel, data) => {
    if (!ALLOWED_INVOKE_CHANNELS.includes(channel)) {
      return Promise.reject(new Error(`Canal IPC no permitido: ${channel}`));
    }
    return ipcRenderer.invoke(channel, data);
  },

  send: (channel, data) => {
    if (!ALLOWED_SEND_CHANNELS.includes(channel)) return;
    ipcRenderer.send(channel, data);
  },

  on: (channel, callback) => {
    const all = [...ALLOWED_INVOKE_CHANNELS, ...ALLOWED_SEND_CHANNELS];
    if (!all.includes(channel)) return;
    ipcRenderer.on(channel, (event, ...args) => callback(...args));
  },

  removeAllListeners: (channel) => {
    ipcRenderer.removeAllListeners(channel);
  }
});
