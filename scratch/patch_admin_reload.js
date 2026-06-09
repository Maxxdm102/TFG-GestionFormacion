const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

const targetFunctionRegex = /\/\/ ── ADMIN MODE ──[\s\S]+?\}\);[\r\n]?\}/;

const replacementFunction = `// ── ADMIN MODE ──
function requireAdminUserSelection() {
  return new Promise(async (resolve) => {
    const backdrop = document.getElementById('admin-user-backdrop');
    if (backdrop) backdrop.classList.add('open');

    const select = document.getElementById('admin-select-personal');
    const btn = document.getElementById('btn-admin-user-confirm');
    const searchInput = document.getElementById('admin-search-personal');
    
    let empleadosList = [];

    if (select) {
      const res = await invokeApi('personal:getAll', {});
      if (res.ok && res.data) {
        empleadosList = res.data.map(p => ({
          id: p.IdPersonal,
          name: p.NombreCompleto || p.Nombre || 'Sin nombre'
        }));
        
        const renderSelect = (filterText) => {
          const lowerFilter = (filterText || '').toLowerCase().trim();
          let html = '<option value="">-- Selecciona un Empleado --</option>';
          const filtered = empleadosList.filter(e => e.name.toLowerCase().includes(lowerFilter));
          html += filtered.map(e => \`<option value="\${e.id}">\${escapeHtml(e.name)}</option>\`).join('');
          select.innerHTML = html;
        };
        
        // Reset the value
        if (searchInput) searchInput.value = '';
        renderSelect('');
        
        if (searchInput) {
          searchInput.oninput = (e) => {
            renderSelect(e.target.value);
          };
        }
      } else {
        select.innerHTML = '<option value="">Error cargando empleados</option>';
      }
    }

    if (btn && select) {
      btn.onclick = async () => {
        const selectedId = select.value;
        if (!selectedId) {
          showToast('Selecciona un empleado para continuar.', 'warning');
          return;
        }
        
        const setRes = await invokeApi('auth:setAdminTarget', parseInt(selectedId));
        if (!setRes.ok) {
          showToast('Error configurando usuario: ' + (setRes.error || 'Desconocido'), 'error');
          return;
        }
        
        const option = select.options[select.selectedIndex];
        const pwName = document.getElementById('pw-name');
        if (pwName) pwName.textContent = option.text + ' (Admin)';
        
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

if(targetFunctionRegex.test(content)) {
    content = content.replace(targetFunctionRegex, replacementFunction);
    fs.writeFileSync(filePath, content, 'utf8');
    console.log('App.js patched successfully for admin search and reload.');
} else {
    console.log('Target function not found in app.js!');
}
