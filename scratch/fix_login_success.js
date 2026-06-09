const fs = require('fs');
let c = fs.readFileSync('main.js', 'utf8');

c = c.replace(`ipcMain.on('login-success', () => {
  if (loginWindow) loginWindow.close();
  createMainAppWindow();
});`, `ipcMain.on('login-success', () => {
  createMainAppWindow();
  if (loginWindow) loginWindow.close();
});`);

fs.writeFileSync('main.js', c);
console.log('done login-success reorder');
