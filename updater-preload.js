const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('updaterApi', {
  start: () => ipcRenderer.invoke('updater:start'),
  cancel: () => ipcRenderer.invoke('updater:cancel'),
  onStatus: (cb) => {
    ipcRenderer.removeAllListeners('updater:status');
    ipcRenderer.on('updater:status', (_evt, payload) => cb(payload));
  }
});

