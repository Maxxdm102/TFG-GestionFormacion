const fs = require('fs');
const filePath = 'src/views/js/app.js';
let content = fs.readFileSync(filePath, 'utf8');

// Update populateForm to use currentUserPersonalId as default
const populateFormRegex = /'resp1': d \? \(d\.resp1Id \|\| ''\) : '',[\s\S]*?'resp2': d \? \(d\.resp2Id \|\| ''\) : '',/;
const populateFormReplacement = `'resp1': d ? (d.resp1Id || '') : (currentUserPersonalId || ''),
    'resp2': d ? (d.resp2Id || '') : (currentUserPersonalId || ''),`;

if (populateFormRegex.test(content)) {
    content = content.replace(populateFormRegex, populateFormReplacement);
}

// Update requireAdminUserSelection to set currentUserPersonalId
const adminSelectRegex = /const pwName = document\.getElementById\('pw-name'\);/;
const adminSelectReplacement = `currentUserPersonalId = selectedId;
        const pwName = document.getElementById('pw-name');`;

if (adminSelectRegex.test(content)) {
    content = content.replace(adminSelectRegex, adminSelectReplacement);
}

fs.writeFileSync(filePath, content, 'utf8');
console.log('app.js patched for default responsable and currentUserPersonalId update');
