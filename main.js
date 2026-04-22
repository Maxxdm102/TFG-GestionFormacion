/* ═══════════════════════════════════════════════════════════════
   MAIN.JS — Punto de entrada Electron
   ═══════════════════════════════════════════════════════════════ */

const { app, BrowserWindow, ipcMain, shell, dialog } = require('electron');
const path = require('path');
const { registerIpcHandlers } = require('./src/ipc/ipcHandlers');

let mainWindow;
let conexionWindow;
let tiemposWindow;
let presupuestosWindow;
let clientesWindow;
let contactosWindow;
let tareaWindow;

let presupuestosOwnerWindow;
let clientesOwnerWindow;
let contactosOwnerWindow;

function createLoginWindow() {
  mainWindow = new BrowserWindow({
    width: 460,
    height: 680,
    resizable: false,
    frame: false,
    transparent: true,
    backgroundColor: '#00000000',
    autoHideMenuBar: true,
    roundedCorners: true,
    center: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false
    },
    show: false
  });

  mainWindow.loadFile(path.join(__dirname, 'src/views/inteco-login.html'));
  mainWindow.once('ready-to-show', () => {
    setTimeout(() => {
      mainWindow.show();
    }, 150);
  });
}

function createConexionWindow() {
  if (conexionWindow) {
    conexionWindow.focus();
    return;
  }

  const [lx, ly] = mainWindow.getPosition();
  const [lw, lh] = mainWindow.getSize();
  const winW = 500;
  const winH = 680;
  const x = Math.round(lx + (lw - winW) / 2);
  const y = Math.round(ly + (lh - winH) / 2);

  conexionWindow = new BrowserWindow({
    width: winW,
    height: winH,
    x,
    y,
    resizable: false,
    frame: false,
    transparent: true,
    backgroundColor: '#00000000',
    roundedCorners: true,
    autoHideMenuBar: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false
    },
    show: false
  });

  conexionWindow.loadFile(path.join(__dirname, 'src/views/inteco-conexion.html'));

  conexionWindow.once('ready-to-show', () => {
    mainWindow.hide();
    conexionWindow.show();
  });

  conexionWindow.on('closed', () => {
    conexionWindow = null;
    if (mainWindow) mainWindow.show();
  });
}

function createMainAppWindow() {
  const appWindow = new BrowserWindow({
    width: 1400,
    height: 900,
    minWidth: 900,
    minHeight: 600,
    autoHideMenuBar: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false
    },
    title: 'Gestión Formación',
    show: false
  });

  appWindow.loadFile(path.join(__dirname, 'src/views/index.html'));

  appWindow.once('ready-to-show', () => {
    appWindow.show();
    if (mainWindow) {
      mainWindow.close();
      mainWindow = appWindow;
    }
  });
}

function createTiemposWindow(idTarea) {
  if (tiemposWindow) {
    tiemposWindow.focus();
    if (idTarea) tiemposWindow.webContents.send('tiempos:setContext', { idTarea });
    return;
  }

  const refWin = mainWindow;
  let x;
  let y;
  if (refWin) {
    const [lx, ly] = refWin.getPosition();
    const [lw, lh] = refWin.getSize();
    const winW = 1200;
    const winH = 780;
    x = Math.round(lx + (lw - winW) / 2);
    y = Math.round(ly + (lh - winH) / 2);
  }

  tiemposWindow = new BrowserWindow({
    width: 1200,
    height: 780,
    minWidth: 900,
    minHeight: 600,
    x,
    y,
    autoHideMenuBar: true,
    title: 'Ver tiempos',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false
    },
    show: false
  });

  tiemposWindow.loadFile(path.join(__dirname, 'src/views/tiempos.html'));

  tiemposWindow.once('ready-to-show', () => tiemposWindow.show());
  tiemposWindow.webContents.once('did-finish-load', () => {
    if (idTarea) tiemposWindow.webContents.send('tiempos:setContext', { idTarea });
  });
  tiemposWindow.on('closed', () => { tiemposWindow = null; });
}

function createPresupuestosWindow(context) {
  if (presupuestosWindow) {
    presupuestosWindow.focus();
    if (context) presupuestosWindow.webContents.send('presupuestos:setContext', context);
    return;
  }

  const refWin = mainWindow;
  let x;
  let y;
  if (refWin) {
    const [lx, ly] = refWin.getPosition();
    const [lw, lh] = refWin.getSize();
    const winW = 1300;
    const winH = 820;
    x = Math.round(lx + (lw - winW) / 2);
    y = Math.round(ly + (lh - winH) / 2);
  }

  presupuestosWindow = new BrowserWindow({
    width: 1300,
    height: 820,
    minWidth: 1000,
    minHeight: 600,
    x,
    y,
    autoHideMenuBar: true,
    title: 'Presupuestos',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false
    },
    show: false
  });

  presupuestosWindow.setMenuBarVisibility(false);
  presupuestosWindow.loadFile(path.join(__dirname, 'src/views/presupuestos.html'));

  presupuestosWindow.once('ready-to-show', () => presupuestosWindow.show());
  presupuestosWindow.webContents.once('did-finish-load', () => {
    if (context) presupuestosWindow.webContents.send('presupuestos:setContext', context);
  });
  presupuestosWindow.on('closed', () => {
    presupuestosWindow = null;
    const target = presupuestosOwnerWindow || mainWindow;
    if (target) target.webContents.send('presupuestos:closed');
    presupuestosOwnerWindow = null;
  });
}

function createClientesWindow() {
  if (clientesWindow) {
    clientesWindow.focus();
    return;
  }

  const refWin = mainWindow;
  let x;
  let y;
  if (refWin) {
    const [lx, ly] = refWin.getPosition();
    const [lw, lh] = refWin.getSize();
    const winW = 1300;
    const winH = 820;
    x = Math.round(lx + (lw - winW) / 2);
    y = Math.round(ly + (lh - winH) / 2);
  }

  clientesWindow = new BrowserWindow({
    width: 1300,
    height: 820,
    minWidth: 1000,
    minHeight: 600,
    x,
    y,
    autoHideMenuBar: true,
    title: 'Clientes',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false
    },
    show: false
  });

  clientesWindow.setMenuBarVisibility(false);
  clientesWindow.loadFile(path.join(__dirname, 'src/views/index.html'), { query: { standalone: 'clientes' } });

  clientesWindow.once('ready-to-show', () => clientesWindow.show());
  clientesWindow.on('closed', () => {
    clientesWindow = null;
    const target = clientesOwnerWindow || mainWindow;
    if (target) target.webContents.send('clientes:closed');
    clientesOwnerWindow = null;
  });
}

function createContactosWindow(context) {
  if (contactosWindow) {
    contactosWindow.focus();
    return;
  }

  const refWin = mainWindow;
  let x;
  let y;
  if (refWin) {
    const [lx, ly] = refWin.getPosition();
    const [lw, lh] = refWin.getSize();
    const winW = 1300;
    const winH = 820;
    x = Math.round(lx + (lw - winW) / 2);
    y = Math.round(ly + (lh - winH) / 2);
  }

  contactosWindow = new BrowserWindow({
    width: 1300,
    height: 820,
    minWidth: 1000,
    minHeight: 600,
    x,
    y,
    autoHideMenuBar: true,
    title: 'Contactos',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false
    },
    show: false
  });

  contactosWindow.setMenuBarVisibility(false);
  contactosWindow.loadFile(path.join(__dirname, 'src/views/index.html'), { query: { standalone: 'contactos' } });

  contactosWindow.once('ready-to-show', () => contactosWindow.show());
  contactosWindow.webContents.once('did-finish-load', () => {
    if (context) contactosWindow.webContents.send('contactos:setContext', context);
  });
  contactosWindow.on('closed', () => {
    contactosWindow = null;
    const target = contactosOwnerWindow || mainWindow;
    if (target) target.webContents.send('contactos:closed');
    contactosOwnerWindow = null;
  });
}

function createTareaWindow(context) {
  const mode = context?.mode || 'nuevo';
  const idTarea = context?.idTarea || '';
  const title = mode === 'modificar' ? 'Modificar tarea' : 'Nueva tarea';

  if (tareaWindow) {
    tareaWindow.focus();
    tareaWindow.setTitle(title);
    if (context) tareaWindow.webContents.send('tareas:setContext', context);
    return;
  }

  const refWin = mainWindow;
  let x;
  let y;
  if (refWin) {
    const [lx, ly] = refWin.getPosition();
    const [lw, lh] = refWin.getSize();
    const winW = 1200;
    const winH = 860;
    x = Math.round(lx + (lw - winW) / 2);
    y = Math.round(ly + (lh - winH) / 2);
  }

  tareaWindow = new BrowserWindow({
    width: 1200,
    height: 860,
    minWidth: 900,
    minHeight: 600,
    x,
    y,
    autoHideMenuBar: true,
    title,
    roundedCorners: false,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false
    },
    show: false
  });

  tareaWindow.setMenuBarVisibility(false);
  tareaWindow.loadFile(path.join(__dirname, 'src/views/index.html'), {
    query: { standalone: 'tarea', mode, id: String(idTarea || '') }
  });

  tareaWindow.once('ready-to-show', () => {
    tareaWindow.show();
  });
  tareaWindow.on('closed', () => {
    tareaWindow = null;
  });
}

/* ─── IPC Handlers ─── */

ipcMain.on('open-conexion', () => createConexionWindow());
ipcMain.on('close-conexion', () => { if (conexionWindow) conexionWindow.close(); });
ipcMain.on('login-success', () => createMainAppWindow());
ipcMain.on('login-close', () => app.quit());
ipcMain.on('tiempos:open', (_event, payload) => createTiemposWindow(payload && payload.idTarea));
ipcMain.on('presupuestos:open', (event, payload) => {
  presupuestosOwnerWindow = BrowserWindow.fromWebContents(event.sender) || mainWindow;
  createPresupuestosWindow(payload || null);
});
ipcMain.on('clientes:open', (event) => {
  clientesOwnerWindow = BrowserWindow.fromWebContents(event.sender) || mainWindow;
  createClientesWindow();
});
ipcMain.on('contactos:open', (event, payload) => {
  contactosOwnerWindow = BrowserWindow.fromWebContents(event.sender) || mainWindow;
  createContactosWindow(payload || null);
});
ipcMain.on('tareas:open', (_event, payload) => createTareaWindow(payload || null));
ipcMain.on('tareas:close', () => { if (tareaWindow) tareaWindow.close(); });
ipcMain.on('tareas:refresh', (_event, payload) => {
  if (mainWindow) mainWindow.webContents.send('tareas:refresh', payload || null);
});
ipcMain.on('presupuestos:select', (_event, payload) => {
  const target = presupuestosOwnerWindow || mainWindow;
  if (target) target.webContents.send('presupuestos:selected', payload);
  if (presupuestosWindow) presupuestosWindow.close();
});
ipcMain.on('clientes:select', (_event, payload) => {
  const target = clientesOwnerWindow || mainWindow;
  if (target) target.webContents.send('clientes:selected', payload);
  if (clientesWindow) clientesWindow.close();
});

// Abrir selector de imagen apuntando a carpeta Fondos
ipcMain.handle('dialog:openFondo', async () => {
  const fondosPath = path.join(__dirname, 'Fondos');
  const result = await dialog.showOpenDialog({
    title: 'Seleccionar fondo',
    defaultPath: fondosPath,
    filters: [{ name: 'Imágenes', extensions: ['jpg', 'jpeg', 'png', 'webp'] }],
    properties: ['openFile']
  });
  if (result.canceled || result.filePaths.length === 0) return { filePath: null };
  return { filePath: result.filePaths[0] };
});

ipcMain.on('window-move', (event, { deltaX, deltaY }) => {
  const win = BrowserWindow.fromWebContents(event.sender);
  if (!win) return;
  const [x, y] = win.getPosition();
  win.setPosition(x + deltaX, y + deltaY);
});

/* ─── App lifecycle ─── */

app.whenReady().then(() => {
  registerIpcHandlers();

  // Mostrar siempre el login al arrancar
  createLoginWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createLoginWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
