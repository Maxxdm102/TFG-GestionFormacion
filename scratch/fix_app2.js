const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

const target = `  if (session.ok && session.data) {
    currentUserId = session.data.id;
    currentUserPersonalId = session.data.idPersonal || null;
    currentUserNombre = session.data.nombre || '';
    if (currentUserPersonalId == null && currentUserNombre) {
      showToast('No se pudo resolver el usuario de la sesión.', 'warning');
    }
  }`;

const replacement = `  if (session.ok && session.data) {
    currentUserId = session.data.id;
    currentUserPersonalId = session.data.idPersonal || null;
    currentUserNombre = session.data.nombre || '';
    if (currentUserPersonalId == null && currentUserNombre) {
      showToast('No se pudo resolver el usuario de la sesión.', 'warning');
    }
    const pwName = document.getElementById('pw-name');
    if (pwName) pwName.textContent = currentUserNombre || 'Desconocido';
  }`;

// normalize newlines for replace
content = content.replace(/\r\n/g, '\n');
const targetNorm = target.replace(/\r\n/g, '\n');
const replacementNorm = replacement.replace(/\r\n/g, '\n');

if (content.includes(targetNorm)) {
  content = content.replace(targetNorm, replacementNorm);
  fs.writeFileSync(filePath, content, 'utf8');
  console.log('Success');
} else {
  console.log('Target not found');
}
