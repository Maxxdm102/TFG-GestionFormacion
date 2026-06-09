const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

const regex = /currentUserPersonalId = session\.data\.idPersonal \|\| null;/g;
const replacement = `currentUserPersonalId = session.data.isAdmin ? (session.data._adminTargetIdPersonal || session.data.idPersonal || null) : (session.data.idPersonal || null);`;

if (regex.test(content)) {
    content = content.replace(regex, replacement);
    fs.writeFileSync(filePath, content, 'utf8');
    console.log('Patched initial load of currentUserPersonalId');
} else {
    console.log('Regex did not match for initial load patch');
}
