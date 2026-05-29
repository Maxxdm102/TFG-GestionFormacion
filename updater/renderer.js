const els = {
  message: document.getElementById('message'),
  bar: document.getElementById('bar'),
  hint: document.getElementById('hint'),
  btnStart: document.getElementById('btnStart'),
  btnCancel: document.getElementById('btnCancel')
};

function setProgress(p) {
  const pct = Math.max(0, Math.min(1, Number(p || 0))) * 100;
  els.bar.style.width = `${pct.toFixed(1)}%`;
}

function setPhase(phase) {
  const busy = phase === 'checking' || phase === 'downloading' || phase === 'applying';
  els.btnStart.disabled = busy;
  els.btnCancel.disabled = !busy;
  els.hint.style.opacity = phase === 'ready' ? '0.85' : '0.65';
}

els.btnStart.addEventListener('click', async () => {
  setProgress(0);
  setPhase('checking');
  await window.updaterApi.start();
});

els.btnCancel.addEventListener('click', async () => {
  await window.updaterApi.cancel();
});

window.updaterApi.onStatus((payload) => {
  if (!payload) return;
  if (payload.message) els.message.textContent = payload.message;
  if (typeof payload.progress === 'number') setProgress(payload.progress);
  if (payload.phase) setPhase(payload.phase);
  if (payload.phase === 'done') setPhase('done');
  if (payload.phase === 'error') setPhase('error');
  if (payload.phase === 'ready') setPhase('ready');
});
