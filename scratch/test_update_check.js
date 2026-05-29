const { checkForUpdates } = require('../src/updater-check');

(async () => {
  console.log('Comprobando actualizaciones...');
  const res = await checkForUpdates();
  console.log('Resultado:', JSON.stringify(res, null, 2));
})().catch(console.error);
