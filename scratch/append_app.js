const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

const widgetLogic = `
// ── CONNECTION WIDGET ──
async function initConnectionWidget() {
  const res = await window.api.invoke('db:getConfig').catch(() => null);
  const dbText = (res && res.ok && res.data) ? res.data.database || 'Desconocida' : 'Error';
  const serverText = (res && res.ok && res.data) ? res.data.server || 'Desconocido' : '---';

  document.querySelectorAll('.statusbar').forEach(sb => {
    const w = document.createElement('div');
    w.className = 'connection-widget';
    w.title = 'Cambiar conexión';
    w.onclick = () => window.api.send('open-conexion');
    w.innerHTML = '<div class="cw-dot"></div><div class="cw-text"><span class="cw-db">BD: ' + dbText + '</span><span class="cw-server">' + serverText + '</span></div>';
    
    const leftWrap = document.createElement('div');
    leftWrap.style.display = 'flex';
    leftWrap.style.alignItems = 'center';
    leftWrap.style.gap = '12px';
    
    const filter = sb.querySelector('.status-filter');
    if (filter) {
      sb.insertBefore(leftWrap, filter);
      leftWrap.appendChild(filter);
      leftWrap.appendChild(w);
    }
  });
}

if (document.readyState === 'loading') { document.addEventListener('DOMContentLoaded', () => initConnectionWidget()); } else { initConnectionWidget(); }
`;

if (!content.includes('initConnectionWidget')) {
  fs.writeFileSync(filePath, content + '\n' + widgetLogic, 'utf8');
  console.log('Appended connection widget');
} else {
  console.log('Already exists');
}
