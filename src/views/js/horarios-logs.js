const state = {
  logs: [],
  session: null,
};

function showToast(msg, type = 'info') {
  const toast = document.getElementById('toast');
  if (!toast) return;
  toast.textContent = msg;
  toast.className = 'toast toast-' + type + ' show';
  clearTimeout(toast._t);
  toast._t = setTimeout(() => toast.classList.remove('show'), 3000);
}

async function invokeApi(channel, data) {
  try {
    return await window.api.invoke(channel, data);
  } catch (err) {
    return { ok: false, error: err.message || 'Error de IPC' };
  }
}

function todayISO() {
  const d = new Date();
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function parseFechaHora(value) {
  if (!value) return null;
  const d = new Date(value);
  if (!Number.isNaN(d.getTime())) return d;
  return null;
}

function formatFecha(d) {
  if (!d) return '-';
  const day = String(d.getDate()).padStart(2, '0');
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const year = d.getFullYear();
  return `${day}/${month}/${year}`;
}

function formatHora(d) {
  if (!d) return '-';
  const h = String(d.getHours()).padStart(2, '0');
  const m = String(d.getMinutes()).padStart(2, '0');
  const s = String(d.getSeconds()).padStart(2, '0');
  return `${h}:${m}:${s}`;
}

function formatFechaHora(d) {
  if (!d) return '-';
  return `${formatFecha(d)} ${formatHora(d)}`;
}

function buildFiltros() {
  const desde = document.getElementById('fecha-desde')?.value || '';
  const hasta = document.getElementById('fecha-hasta')?.value || '';
  return {
    desde: desde || null,
    hasta: hasta || null,
  };
}

function renderTable(rows) {
  const tbody = document.getElementById('logs-tbody');
  if (!tbody) return;

  if (!rows.length) {
    tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;padding:20px;color:var(--text3)">Sin registros.</td></tr>';
    return;
  }

  tbody.innerHTML = rows.map(r => {
    const fecha = formatFechaHora(parseFechaHora(r.FechaHoraModificacion));
    const usuario = escapeHtml(r.UsuarioModificacion || '');
    const accionRaw = String(r.Accion || '').toUpperCase();
    const accionCls = accionRaw === 'DELETE' ? 'delete' : (accionRaw === 'UPDATE' ? 'update' : '');
    const campo = escapeHtml(r.CampoModificado || '');
    const valAnt = escapeHtml(r.ValorAnterior || '');
    const valNew = escapeHtml(r.ValorNuevo || '');
    const motivo = escapeHtml(r.Motivo || '');
    const idFichaje = escapeHtml(r.IdControlPresenciaFichaje ?? '');
    const idLog = escapeHtml(r.IdControlPresenciaFichajeLog ?? '');

    return `
      <tr>
        <td class="mono">${escapeHtml(fecha)}</td>
        <td>${usuario || '-'}</td>
        <td><span class="logs-action ${accionCls}">${escapeHtml(accionRaw || '-')}</span></td>
        <td>${campo || '-'}</td>
        <td class="wrap" title="${valAnt}">${valAnt || '-'}</td>
        <td class="wrap" title="${valNew}">${valNew || '-'}</td>
        <td class="wrap" title="${motivo}">${motivo || '-'}</td>
        <td class="mono">${idFichaje || '-'}</td>
        <td class="mono">${idLog || '-'}</td>
      </tr>
    `;
  }).join('');
}

function updateStatus(total, desde, hasta) {
  const totalEl = document.getElementById('logs-total');
  if (totalEl) totalEl.textContent = `${total} registros`;

  const status = document.getElementById('logs-status');
  if (!status) return;
  const left = status.querySelector('.status-filter');
  const rango = (desde || hasta)
    ? `${desde || '-'} a ${hasta || '-'}`
    : 'Todas';
  if (left) left.innerHTML = `<span class="status-filter-icon">F</span>Filtrando: ${rango}`;

  const right = status.querySelector('.statusbar-right');
  if (right) right.textContent = `Registros: ${total}`;
}

async function cargarLogs() {
  const tbody = document.getElementById('logs-tbody');
  if (tbody) {
    tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;padding:20px;color:var(--text3)">Cargando...</td></tr>';
  }

  const { desde, hasta } = buildFiltros();
  const payload = { desde, hasta };
  if (state.session) {
    if (state.session.isAdmin && state.session._adminTargetIdPersonal != null) {
      payload.idPersonal = state.session._adminTargetIdPersonal;
    } else if (!state.session.isAdmin && state.session.idPersonal != null) {
      payload.idPersonal = state.session.idPersonal;
    }
  }
  const res = await invokeApi('presencia:getFichajesLogs', payload);
  if (!res.ok) {
    if (tbody) tbody.innerHTML = `<tr><td colspan="9" style="text-align:center;padding:20px;color:var(--danger)">Error: ${escapeHtml(res.error || 'Error')}</td></tr>`;
    showToast('Error al cargar logs: ' + (res.error || 'Error desconocido'), 'warning');
    return;
  }

  const rows = res.data || [];
  state.logs = rows;
  renderTable(rows);
  updateStatus(rows.length, desde, hasta);
}

async function generarPdf() {
  const { desde, hasta } = buildFiltros();
  showToast('Generando PDF...', 'info');
  const userName = document.getElementById('logs-user')?.textContent || '-';
  const pdfPayload = { desde, hasta, userName };
  if (state.session) {
    if (state.session.isAdmin && state.session._adminTargetIdPersonal != null) {
      pdfPayload.idPersonal = state.session._adminTargetIdPersonal;
    } else if (!state.session.isAdmin && state.session.idPersonal != null) {
      pdfPayload.idPersonal = state.session.idPersonal;
    }
  }
  const res = await invokeApi('presencia:exportFichajesLogsPdf', pdfPayload);
  if (res.ok) {
    showToast(`PDF generado en Descargas: ${res.fileName}`, 'success');
  } else {
    showToast('Error al generar PDF: ' + (res.error || 'Error desconocido'), 'warning');
  }
}

async function init() {
  const session = await invokeApi('auth:getSession');
  if (session.ok && session.data) {
    state.session = session.data;
    const label = document.getElementById('logs-user');
    if (label) label.textContent = session.data.nombre || 'Usuario';
  }

  const desdeEl = document.getElementById('fecha-desde');
  const hastaEl = document.getElementById('fecha-hasta');
  const hoy = todayISO();
  if (desdeEl && !desdeEl.value) desdeEl.value = hoy;
  if (hastaEl && !hastaEl.value) hastaEl.value = hoy;

  await cargarLogs();
}

document.getElementById('btn-buscar').addEventListener('click', cargarLogs);
document.getElementById('btn-logs-refrescar').addEventListener('click', cargarLogs);
document.getElementById('btn-logs-pdf').addEventListener('click', generarPdf);

if (window.api && window.api.on) {
  window.api.on('fichaje:refresh', () => {
    cargarLogs();
  });
}

init();
