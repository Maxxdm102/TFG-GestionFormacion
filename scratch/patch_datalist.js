const fs = require('fs');
const filePath = 'src/views/index.html';
let content = fs.readFileSync(filePath, 'utf8');

const regex = /<div style="display: flex; flex-direction: column; gap: 8px;">[\s\S]*?<\/div>\s*<\/div>/;

const replacement = `<div style="display: flex; flex-direction: column; gap: 8px;">
        <input list="admin-empleados-datalist" id="admin-search-personal" placeholder="Escribe el nombre del empleado..." style="width: 100%; padding: 14px 16px; font-size: 15px; color: #1e293b; background-color: #f8fafc; border: 2px solid #e2e8f0; border-radius: 12px; outline: none; transition: all 0.2s ease; box-sizing: border-box;" autocomplete="off">
        <datalist id="admin-empleados-datalist"></datalist>
      </div>
    </div>`;

content = content.replace(regex, replacement);
fs.writeFileSync(filePath, content, 'utf8');
console.log('index.html datalist patched');
