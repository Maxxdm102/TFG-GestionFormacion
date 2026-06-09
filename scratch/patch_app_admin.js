const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

const targetInit = `    if (currentUserPersonalId == null && currentUserNombre) {
      showToast('No se pudo resolver el usuario de la sesión.', 'warning');
    }
    const pwName = document.getElementById('pw-name');
    if (pwName) pwName.textContent = currentUserNombre || 'Desconocido';
  }`;

const replaceInit = `    if (currentUserPersonalId == null && currentUserNombre && !session.data.isAdmin) {
      showToast('No se pudo resolver el usuario de la sesión.', 'warning');
    }
    const pwName = document.getElementById('pw-name');
    if (pwName) pwName.textContent = currentUserNombre || 'Desconocido';
    
    if (session.data.isAdmin) {
      await requireAdminUserSelection();
    }
  }`;

content = content.replace(targetInit, replaceInit);

const adminCode = `
// ── ADMIN MODE ──
function requireAdminUserSelection() {
  return new Promise(async (resolve) => {
    const backdrop = document.getElementById('admin-user-backdrop');
    if (backdrop) backdrop.classList.add('open');

    const select = document.getElementById('admin-select-personal');
    const btn = document.getElementById('btn-admin-user-confirm');

    if (select) {
      const res = await invokeApi('personal:getAll', {});
      if (res.ok && res.data) {
        select.innerHTML = '<option value="">-- Selecciona un Empleado --</option>' + 
          res.data.map(p => \`<option value="\${p.IdPersonal}">\${escapeHtml(p.NombreCompleto || p.Nombre || 'Sin nombre')}</option>\`).join('');
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
          showToast('Error configurando usuario.', 'error');
          return;
        }
        
        const option = select.options[select.selectedIndex];
        const pwName = document.getElementById('pw-name');
        if (pwName) pwName.textContent = option.text + ' (Admin)';
        
        if (backdrop) backdrop.classList.remove('open');
        resolve();
      };
    } else {
      resolve();
    }
  });
}
`;

content += adminCode;
fs.writeFileSync(filePath, content, 'utf8');
console.log('Done appending admin logic to app.js');
