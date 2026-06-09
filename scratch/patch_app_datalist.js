const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

const regex = /\/\/ ── ADMIN MODE ──[\s\S]*\}\);[\s]*\}/;

const replacement = `// ── ADMIN MODE ──
function requireAdminUserSelection() {
  return new Promise(async (resolve) => {
    const backdrop = document.getElementById('admin-user-backdrop');
    if (backdrop) backdrop.classList.add('open');

    const searchInput = document.getElementById('admin-search-personal');
    const datalist = document.getElementById('admin-empleados-datalist');
    const btn = document.getElementById('btn-admin-user-confirm');
    
    let empleadosList = [];

    if (datalist && searchInput) {
      const res = await invokeApi('personal:getAll', {});
      if (res.ok && res.data) {
        empleadosList = res.data.map(p => ({
          id: p.IdPersonal,
          name: p.NombreCompleto || p.Nombre || 'Sin nombre'
        }));
        
        datalist.innerHTML = empleadosList.map(e => \`<option data-id="\${e.id}" value="\${escapeHtml(e.name)}"></option>\`).join('');
        searchInput.value = '';
      } else {
        searchInput.placeholder = 'Error cargando empleados';
      }
    }

    if (btn && searchInput) {
      btn.onclick = async () => {
        const selectedValue = searchInput.value;
        const matchedUser = empleadosList.find(e => e.name === selectedValue);
        
        if (!matchedUser) {
          showToast('Selecciona un empleado válido de la lista.', 'warning');
          return;
        }
        
        const setRes = await invokeApi('auth:setAdminTarget', parseInt(matchedUser.id));
        if (!setRes.ok) {
          showToast('Error configurando usuario: ' + (setRes.error || 'Desconocido'), 'error');
          return;
        }
        
        const pwName = document.getElementById('pw-name');
        if (pwName) pwName.textContent = matchedUser.name + ' (Admin)';
        
        if (backdrop) backdrop.classList.remove('open');
        
        // If this is triggered after initial load, refresh data
        if (document.readyState === 'complete' && typeof cargarTareas === 'function') {
           await cargarDatosBuscadores();
           setAsignadaFiltroSesion();
           setContactosPersonalSesion();
           applyContactosContextToUi();
           await ensureContactosClienteNombre();
           if (!standalonePage || standalonePage === 'tareas') {
             await cargarTareas();
           }
        }
        resolve();
      };
    } else {
      resolve();
    }
  });
}`;

content = content.replace(regex, replacement);
fs.writeFileSync(filePath, content, 'utf8');
console.log('app.js patched for datalist');
