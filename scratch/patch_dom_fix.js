const fs = require('fs');
const filePath = 'src/views/index.html';
let content = fs.readFileSync(filePath, 'utf8');

const regex = /<div class="modal-backdrop" id="admin-user-backdrop"[\s\S]*?<\/style>/;

const replacement = `<div class="modal-backdrop" id="admin-user-backdrop" style="background: rgba(15, 23, 42, 0.85); backdrop-filter: blur(8px); z-index: 9999; display: flex; align-items: center; justify-content: center; opacity: 0; pointer-events: none; transition: opacity 0.3s ease;">
  <div class="modal" style="width:460px; max-width:90vw; background: #ffffff; border-radius: 16px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); overflow: visible; border: 1px solid rgba(226, 232, 240, 0.8); transform: translateY(20px); transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275); position: relative;">
    <div style="background: linear-gradient(135deg, #2563eb, #1e40af); padding: 24px; text-align: center; border-radius: 16px 16px 0 0;">
      <svg style="width: 48px; height: 48px; color: white; margin: 0 auto 12px; display: block;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
        <circle cx="9" cy="7" r="4"></circle>
        <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
      </svg>
      <h2 style="color: white; margin: 0; font-size: 20px; font-weight: 600; letter-spacing: -0.5px;">Panel de Administrador</h2>
    </div>
    <div style="padding: 32px 24px 24px; display:flex; flex-direction:column; gap:20px;">
      <p style="color: #475569; font-size: 14.5px; line-height: 1.6; margin: 0; text-align: center;">
        Por favor, <strong>selecciona un empleado</strong> para visualizar y gestionar sus tareas, horarios y tiempos.
      </p>
      
      <div style="position: relative;" id="admin-dropdown-container">
        <input type="text" id="admin-search-personal" placeholder="Escribe para buscar empleado..." style="width: 100%; padding: 14px 16px; font-size: 15px; color: #1e293b; background-color: #f8fafc; border: 2px solid #e2e8f0; border-radius: 12px; outline: none; transition: all 0.2s ease; box-sizing: border-box;" autocomplete="off">
        <div style="position: absolute; right: 16px; top: 50%; transform: translateY(-50%); pointer-events: none; color: #64748b;">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m6 9 6 6 6-6"/></svg>
        </div>
        <ul id="admin-empleados-list" style="display: none; position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #e2e8f0; border-radius: 8px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); max-height: 250px; overflow-y: auto; z-index: 10000; margin: 4px 0 0; padding: 0; list-style: none;">
        </ul>
      </div>
      <input type="hidden" id="admin-selected-id">
    </div>
    <div style="padding: 0 24px 24px;">
      <button id="btn-admin-user-confirm" style="width: 100%; padding: 14px; background: #2563eb; color: white; border: none; border-radius: 12px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.2s ease; box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2), 0 2px 4px -2px rgba(37, 99, 235, 0.2);">
        Continuar como empleado
      </button>
    </div>
  </div>
</div>
<style>
  #admin-search-personal:focus { border-color: #2563eb !important; background-color: #ffffff !important; box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1) !important; }
  #btn-admin-user-confirm:hover { background: #1d4ed8 !important; }
  #btn-admin-user-confirm:active { transform: scale(0.98); }
  #admin-user-backdrop.open { opacity: 1 !important; pointer-events: auto !important; }
  #admin-user-backdrop.open .modal { transform: translateY(0) !important; }
  #admin-empleados-list li { padding: 12px 16px; cursor: pointer; color: #334155; font-size: 14.5px; transition: background 0.1s; border-bottom: 1px solid #f1f5f9; }
  #admin-empleados-list li:last-child { border-bottom: none; }
  #admin-empleados-list li:hover { background-color: #f8fafc; color: #2563eb; }
  #admin-empleados-list li.selected { background-color: #eff6ff; color: #2563eb; font-weight: 500; }
</style>`;

content = content.replace(regex, replacement);
fs.writeFileSync(filePath, content, 'utf8');
console.log('Fixed DOM and replaced with custom dropdown');
