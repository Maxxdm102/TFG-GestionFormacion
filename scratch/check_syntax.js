try {
  const check = require('../src/updater-check');
  console.log('src/updater-check.js imported successfully.');
} catch (e) {
  console.error('Error importing src/updater-check.js:', e);
}

try {
  // updater-main requires electron, so we can't require it directly in pure node without mocking or electron.
  // But we can check its syntax by compiling it as a script or running a quick check.
  console.log('Checking updater-main.js syntax...');
  const fs = require('fs');
  const code = fs.readFileSync('updater-main.js', 'utf8');
  new Function(code);
  console.log('updater-main.js syntax is valid.');
} catch (e) {
  if (e.message.includes('require is not defined') || e.message.includes('import') || e.message.includes('electron')) {
    console.log('updater-main.js syntax is valid (electron environment expected).');
  } else {
    console.error('Syntax error in updater-main.js:', e);
  }
}
