const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

const targetFunctionRegex = /\/\/ ── ADMIN MODE ──[\s\S]+?\}\);[\r\n]?\}/;

const replacementFunction = `// ── ADMIN MODE ──
function removeAccents(str) {
  return str.normalize("NFD").replace(/[\\u0300-\\u036f]/g, "");
}

function requireAdminUserSelection() {
  return new Promise(async (resolve) => {
    const backdrop = document.getElementById('admin-user-backdrop');
    if (backdrop) backdrop.classList.add('open');

    const searchInput = document.getElementById('admin-search-personal');
    const ulList = document.getElementById('admin-empleados-list');
    const hiddenId = document.getElementById('admin-selected-id');
    const btn = document.getElementById('btn-admin-user-confirm');
    
    let empleadosList = [];

    if (ulList && searchInput && hiddenId) {
      const res = await invokeApi('personal:getAll', {});
      if (res.ok && res.data) {
        empleadosList = res.data.map(p => ({
          id: p.IdPersonal,
          name: p.NombreCompleto || p.Nombre || 'Sin nombre',
          searchStr: removeAccents((p.NombreCompleto || p.Nombre || '').toLowerCase())
        }));
        
        const renderList = (filterText) => {
          const lowerFilter = removeAccents((filterText || '').toLowerCase().trim());
          const filtered = empleadosList.filter(e => e.searchStr.includes(lowerFilter));
          
          if (filtered.length === 0) {
            ulList.innerHTML = '<li style="color:#94a3b8;cursor:default;">No se encontraron resultados</li>';
          } else {
            ulList.innerHTML = filtered.map(e => \`<li data-id="\${e.id}">\${escapeHtml(e.name)}</li>\`).join('');
          }
          ulList.style.display = 'block';
          
          // attach clicks
          const lis = ulList.querySelectorAll('li[data-id]');
          lis.forEach(li => {
            li.onclick = () => {
              searchInput.value = li.textContent;
              hiddenId.value = li.getAttribute('data-id');
              ulList.style.display = 'none';
            };
          });
        };
        
        // Reset the value
        searchInput.value = '';
        hiddenId.value = '';
        renderList('');
        ulList.style.display = 'none'; // hide initially until focus
        
        searchInput.onfocus = () => {
          renderList(searchInput.value);
        };
        
        searchInput.oninput = (e) => {
          hiddenId.value = ''; // clear selected on type
          renderList(e.target.value);
        };
        
        // Close dropdown when clicking outside
        document.addEventListener('click', (e) => {
          if (e.target !== searchInput && e.target !== ulList && !ulList.contains(e.target)) {
            ulList.style.display = 'none';
          }
        });

      } else {
        searchInput.placeholder = 'Error cargando empleados';
      }
    }

    if (btn && searchInput) {
      btn.onclick = async () => {
        const selectedId = hiddenId ? hiddenId.value : '';
        if (!selectedId) {
          showToast('Por favor, selecciona un empleado de la lista.', 'warning');
          return;
        }
        
        const setRes = await invokeApi('auth:setAdminTarget', parseInt(selectedId));
        if (!setRes.ok) {
          showToast('Error configurando usuario: ' + (setRes.error || 'Desconocido'), 'error');
          return;
        }
        
        const pwName = document.getElementById('pw-name');
        if (pwName) {
           const selectedName = searchInput.value;
           pwName.textContent = selectedName + ' (Admin)';
        }
        
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
    console.log('App.js patched successfully for custom dropdown and accent fix.');
} else {
    console.log('Target function not found in app.js!');
}
