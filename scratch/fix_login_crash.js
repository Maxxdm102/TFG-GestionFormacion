const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

// Revert the wrong replacement
content = content.replace(
`    currentUserPersonalId = selectedId;
        const pwName = document.getElementById('pw-name');`,
`    const pwName = document.getElementById('pw-name');`
);

// Apply correctly to requireAdminUserSelection
const targetStr = `        const setRes = await invokeApi('auth:setAdminTarget', parseInt(selectedId));
        if (!setRes.ok) {
          showToast('Error configurando usuario: ' + (setRes.error || 'Desconocido'), 'error');
          return;
        }`;

const replacementStr = targetStr + `\n        currentUserPersonalId = selectedId;`;

content = content.replace(targetStr, replacementStr);

fs.writeFileSync(filePath, content, 'utf8');
console.log('Fixed reference error in app.js');
