const fs = require('fs');
let c = fs.readFileSync('main.js', 'utf8');

c = c.replace(`ipcMain.on('open-login', () => {
  if (mainWindow) mainWindow.close();
  createLoginWindow();
});`, `ipcMain.on('open-login', () => {
  createLoginWindow(true); // modal over mainWindow
});`);

c = c.replace(`ipcMain.on('login-success', () => createMainAppWindow());`, `ipcMain.on('login-success', () => {
  if (loginWindow) loginWindow.close();
  createMainAppWindow();
});`);

fs.writeFileSync('main.js', c);
console.log('done ipc main');
