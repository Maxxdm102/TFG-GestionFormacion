const fs = require('fs');
let c = fs.readFileSync('main.js', 'utf8');

c = c.replace(`ipcMain.on('login-close', () => app.quit());`, `ipcMain.on('login-close', () => {
  if (loginWindow) {
    loginWindow.close();
  } else {
    app.quit();
  }
});`);

fs.writeFileSync('main.js', c);
console.log('done login close');
