const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

const regexCargar = /async function cargarTareas\(filtros = \{\}\) \{[\s\S]*?taskData = applyLocalTaskFilters\(\s*\(res\.data \|\| \[\]\)\.map\(mapDbTask\),\s*filtros\s*\)\s*\.sort\(\(a, b\) => \{[\s\S]*?return \(b\.id \|\| 0\) - \(a\.id \|\| 0\);\s*\}\);/;

const replacementCargar = `async function cargarTareas(filtros = {}) {
  const tbody = document.getElementById('tasks-tbody');
  tbody.innerHTML = '<tr><td colspan="15" style="text-align:center;padding:20px;color:var(--text3)">Cargando...</td></tr>';

  // No enviar 'estado' al backend para poder obtener los counts de todas las pestañas
  const filtrosBackend = { ...filtros };
  delete filtrosBackend.estado;

  const res = await invokeApi('tareas:getAll', filtrosBackend);
  if (!res.ok) {
    tbody.innerHTML = \`<tr><td colspan="15" style="text-align:center;padding:20px;color:var(--danger)">Error: \${res.error}</td></tr>\`;
    showToast('Error al cargar tareas: ' + res.error, 'warning');
    return;
  }

  // Filtrar localmente usando filtrosBackend (sin 'estado')
  const allFilteredLocally = applyLocalTaskFilters(
    (res.data || []).map(mapDbTask),
    filtrosBackend
  ).sort((a, b) => {
    const pa = Number.isFinite(a.prioridad) ? a.prioridad : 999999;
    const pb = Number.isFinite(b.prioridad) ? b.prioridad : 999999;
    if (pa !== pb) return pa - pb;
    return (b.id || 0) - (a.id || 0);
  });

  // Calculamos los contadores basados en el total de tareas resultantes de los otros filtros
  actualizarCountsTabsAll(allFilteredLocally);

  // Ahora sí, aplicamos el filtro de estado si existe
  if (filtros.estado) {
    const norm = String(filtros.estado).toLowerCase();
    taskData = allFilteredLocally.filter(t => String(t.estado).toLowerCase() === norm);
  } else {
    taskData = allFilteredLocally;
  }`;

content = content.replace(regexCargar, replacementCargar);

// Modify actualizarCountsTabs to accept data array and NOT rely on taskData directly
const regexCounts = /function actualizarCountsTabs\(\) \{[\s\S]*?const tabs = document\.querySelectorAll\('\.estado-tab'\);[\s\S]*?const counts = \{[\s\S]*?all: taskData\.length,[\s\S]*?espera: 0\s*\};[\s\S]*?taskData\.forEach\(t => \{/;

const replacementCounts = `function actualizarCountsTabsAll(dataArray) {
  const tabs = document.querySelectorAll('.estado-tab');
  if (!tabs.length) return;

  const counts = {
    all: dataArray.length,
    asignada: 0,
    iniciada: 0,
    realizada: 0,
    comprobada: 0,
    espera: 0
  };

  dataArray.forEach(t => {`;

content = content.replace(regexCounts, replacementCounts);

// Remove the call to actualizarCountsTabs() from updateStatusBar, we don't need it there anymore because we call it directly in cargarTareas
content = content.replace(/actualizarCountsTabs\(\);/g, '// actualizarCountsTabs() called in cargarTareas');


fs.writeFileSync(filePath, content, 'utf8');
console.log('Patched cargarTareas for correct tab counting');
