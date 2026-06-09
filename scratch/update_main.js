const fs = require('fs');
let c = fs.readFileSync('main.js', 'utf8');

const targetLogin = `function createLoginWindow() {
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
      // Si hay datos de actualización, los enviamos al login
      if (global.updateData) {
        mainWindow.webContents.send('updater:available', global.updateData);
      }
    }, 150);
  });
}`;

const replaceLogin = `function createLoginWindow(asModal = false) {
  if (loginWindow) {
    loginWindow.focus();
    return;
  }
  let options = {
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
  };

  if (asModal && mainWindow) {
    options.parent = mainWindow;
    options.modal = true;
  }

  loginWindow = new BrowserWindow(options);

  loginWindow.loadFile(path.join(__dirname, 'src/views/inteco-login.html'));
  loginWindow.once('ready-to-show', () => {
    setTimeout(() => {
      loginWindow.show();
      // Si hay datos de actualización, los enviamos al login
      if (global.updateData) {
        loginWindow.webContents.send('updater:available', global.updateData);
      }
    }, 150);
  });

  loginWindow.on('closed', () => {
    loginWindow = null;
  });
}`;

const targetMain = `function createMainAppWindow() {
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
    title: 'TareasGForma',
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
}`;

const replaceMain = `function createMainAppWindow() {
  if (mainWindow) {
    mainWindow.reload();
    return;
  }

  mainWindow = new BrowserWindow({
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
    title: 'TareasGForma',
    show: false
  });

  mainWindow.loadFile(path.join(__dirname, 'src/views/index.html'));

  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
  });
}`;

c = c.replace(targetLogin.replace(/\r\n/g, '\n'), replaceLogin);
c = c.replace(targetMain.replace(/\r\n/g, '\n'), replaceMain);
fs.writeFileSync('main.js', c);
console.log('done');
