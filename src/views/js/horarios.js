const state = {
  registros: [],
  selectedId: null,
  selectedRow: null,
  session: null,
};

const EVENTOS = [
  { id: 1, label: 'Entrada' },
  { id: 2, label: 'Salida' },
  { id: 3, label: 'Pausa' },
  { id: 4, label: 'Fin pausa' },
];

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

function getMotivoFromInput(inputId) {
  const input = document.getElementById(inputId);
  const motivo = String(input?.value || '').trim();
  if (!motivo) {
    showToast('El motivo es obligatorio.', 'warning');
    if (input) input.focus();
    return null;
  }
  return motivo;
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

function toDateKey(d) {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

function parseFechaHora(row) {
  const raw = row?.FechaHora ?? row?.Fecha ?? row?.FechaRegistro ?? row?.FechaHoraLocal ?? row?.fechaHora ?? row?.fechahora;
  if (raw) {
    const d = new Date(raw);
    if (!Number.isNaN(d.getTime())) return d;
  }

  const fecha = row?.Fecha ?? row?.fecha;
  const hora = row?.Hora ?? row?.hora;
  if (fecha && hora) {
    const fechaTxt = String(fecha).substring(0, 10);
    const horaTxt = String(hora).substring(0, 8);
    const d = new Date(`${fechaTxt}T${horaTxt}`);
    if (!Number.isNaN(d.getTime())) return d;
  }

  if (fecha) {
    const d = new Date(fecha);
    if (!Number.isNaN(d.getTime())) return d;
  }

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
  return `${h}:${m}`;
}

function toInputDate(d) {
  if (!d) return '';
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

function toInputTime(d) {
  if (!d) return '';
  const h = String(d.getHours()).padStart(2, '0');
  const m = String(d.getMinutes()).padStart(2, '0');
  return `${h}:${m}`;
}

function resolveEventoInfo(row) {
  const labelRaw =
    row?.TipoEvento ??
    row?.Evento ??
    row?.NombreEvento ??
    row?.DescripcionTipoEvento ??
    row?.ControlPresenciaTipoEvento ??
    row?.Tipo ??
    null;

  const idRaw =
    row?.IdControlPresenciaTipoEvento ??
    row?.IdTipoEvento ??
    row?.TipoEventoId ??
    row?.IdTipo ??
    row?.IdControlPresenciaTipo;

  const id = Number(idRaw);
  const map = {
    1: 'Entrada',
    2: 'Salida',
    3: 'Pausa',
    4: 'Fin pausa',
  };

  const label = labelRaw ? String(labelRaw) : (map[id] || '-');
  let cls = 'evt-otro';
  const labelNorm = label.toLowerCase();
  if (id === 1 || labelNorm.includes('entrada') || labelNorm.includes('trabaj')) cls = 'evt-entrada';
  if (id === 2 || labelNorm.includes('salida') || labelNorm.includes('desconect')) cls = 'evt-salida';
  if (id === 3 || labelNorm.includes('pausa')) cls = 'evt-pausa';
  if (id === 4 || labelNorm.includes('fin')) cls = 'evt-fin';
  return { label, cls };
}

function getRegistroId(row) {
  return String(row?.IdControlPresenciaFichaje ?? row?.Id ?? row?.id ?? '');
}

function getTipoEvento(row) {
  const raw =
    row?.IdControlPresenciaTipoEvento ??
    row?.IdTipoEvento ??
    row?.TipoEventoId ??
    row?.IdTipo ??
    row?.IdControlPresenciaTipo;
  const tipo = Number(raw);
  return Number.isFinite(tipo) ? tipo : null;
}

function isEntradaTipo(tipo) {
  return tipo === 1 || tipo === 4;
}

function buildDeletePlan(selectedId, rows) {
  const ordered = rows
    .map(r => ({ row: r, dt: parseFechaHora(r) }))
    .filter(x => x.dt)
    .sort((a, b) => a.dt.getTime() - b.dt.getTime());

  const idx = ordered.findIndex(x => getRegistroId(x.row) === String(selectedId));
  if (idx < 0) return { ok: false, error: 'No se pudo localizar el registro seleccionado.' };

  const target = ordered[idx];
  const tipo = getTipoEvento(target.row);
  const targetDate = toDateKey(target.dt);
  const targetId = getRegistroId(target.row);

  if (!tipo) return { ok: false, error: 'Tipo de fichaje no reconocido.' };

  if (tipo === 1) {
    return { ok: true, ids: [targetId] };
  }

  if (tipo === 4) {
    return { ok: true, ids: [targetId] };
  }

  if (tipo === 2) {
    const prev = ordered[idx - 1];
    if (!prev || toDateKey(prev.dt) !== targetDate || !isEntradaTipo(getTipoEvento(prev.row))) {
      return { ok: false, error: 'No se encontr\u00f3 la entrada inmediatamente anterior para borrar con la salida.' };
    }
    return { ok: true, ids: [getRegistroId(prev.row), targetId] };
  }

  if (tipo === 3) {
    const next = ordered[idx + 1];
    if (!next || toDateKey(next.dt) !== targetDate || getTipoEvento(next.row) !== 4) {
      return { ok: false, error: 'No se encontr\u00f3 el fin de pausa inmediatamente posterior para borrar con la pausa.' };
    }
    return { ok: true, ids: [targetId, getRegistroId(next.row)] };
  }

  return { ok: false, error: 'Tipo de fichaje no soportado.' };
}

function fillEventoOptions() {
  const select = document.getElementById('horario-evento');
  if (!select) return;
  select.innerHTML = EVENTOS
    .map(e => `<option value="${e.id}">${e.label}</option>`)
    .join('');
}

function openHorarioModal(row) {
  const backdrop = document.getElementById('horario-modal-backdrop');
  if (!backdrop) return;
  const fechaEl = document.getElementById('horario-fecha');
  const horaEl = document.getElementById('horario-hora');
  const eventoEl = document.getElementById('horario-evento');
  const motivoEl = document.getElementById('horario-motivo-edit');

  const d = parseFechaHora(row) || new Date();
  if (fechaEl) fechaEl.value = toInputDate(d);
  if (horaEl) horaEl.value = toInputTime(d);
  if (eventoEl) {
    const tipo = getTipoEvento(row);
    eventoEl.value = tipo != null ? String(tipo) : String(EVENTOS[0].id);
  }
  if (motivoEl) motivoEl.value = '';

  backdrop.classList.add('open');
}

function closeHorarioModal() {
  const backdrop = document.getElementById('horario-modal-backdrop');
  if (backdrop) backdrop.classList.remove('open');
}

function openDeleteModal() {
  const backdrop = document.getElementById('horario-delete-backdrop');
  const motivoEl = document.getElementById('horario-motivo-delete');
  if (motivoEl) motivoEl.value = '';
  if (backdrop) backdrop.classList.add('open');
}

function closeDeleteModal() {
  const backdrop = document.getElementById('horario-delete-backdrop');
  if (backdrop) backdrop.classList.remove('open');
}

function notifyInformePresenciaRefresh() {
  if (window.api && window.api.send) {
    window.api.send('presenciaInforme:refresh');
    window.api.send('fichaje:refresh');
  }
}

function buildFiltros() {
  const desde = document.getElementById('fecha-desde')?.value || '';
  const hasta = document.getElementById('fecha-hasta')?.value || '';
  return {
    desde: desde || null,
    hasta: hasta || null,
  };
}

function filterRows(rows, desde, hasta) {
  if (!desde && !hasta) return rows;
  return rows.filter(r => {
    const d = parseFechaHora(r);
    if (!d) return false;
    const key = toDateKey(d);
    if (desde && key < desde) return false;
    if (hasta && key > hasta) return false;
    return true;
  });
}

function renderTable(rows) {
  const tbody = document.getElementById('horarios-tbody');
  if (!tbody) return;

  if (!rows.length) {
    tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;padding:20px;color:var(--text3)">Sin registros.</td></tr>';
    return;
  }

  tbody.innerHTML = rows.map(r => {
    const d = parseFechaHora(r);
    const fecha = d ? formatFecha(d) : (r.Fecha ? escapeHtml(r.Fecha) : '-');
    const hora = d ? formatHora(d) : (r.Hora ? escapeHtml(r.Hora) : '-');
    const eventoInfo = resolveEventoInfo(r);
    const comentario = escapeHtml(r.Comentarios ?? r.Comentario ?? r.Observaciones ?? '');
    const dispositivo = escapeHtml(r.IpDispositivo ?? r.Dispositivo ?? r.Equipo ?? '');
    const rowId = escapeHtml(r.IdControlPresenciaFichaje ?? r.Id ?? '');

    return `
      <tr data-id="${rowId}">
        <td class="mono">${fecha}</td>
        <td class="mono">${hora}</td>
        <td><span class="evento-badge ${eventoInfo.cls}">${escapeHtml(eventoInfo.label)}</span></td>
        <td class="desc-cell">${comentario || '-'}</td>
        <td class="mono">${dispositivo || '-'}</td>
      </tr>
    `;
  }).join('');

  tbody.querySelectorAll('tr[data-id]').forEach(tr => {
    tr.addEventListener('click', () => {
      tbody.querySelectorAll('tr').forEach(r => r.classList.remove('selected'));
      tr.classList.add('selected');
      state.selectedId = tr.dataset.id || null;
      state.selectedRow = state.registros.find(r => getRegistroId(r) === String(state.selectedId)) || null;
    });
  });
}

function updateStatus(rows, desde, hasta) {
  const totalEl = document.getElementById('horarios-total');
  if (totalEl) totalEl.textContent = `${rows.length} registros`;

  const status = document.getElementById('horarios-status');
  if (!status) return;

  const left = status.querySelector('.status-filter');
  const rango = (desde || hasta)
    ? `${desde || '-'} a ${hasta || '-'}`
    : 'Todas';
  if (left) left.innerHTML = `<span class="status-filter-icon">F</span>Filtrando: ${rango}`;

  const right = status.querySelector('.statusbar-right');
  if (right) right.textContent = `Registros: ${rows.length} - Tiempo: 0 s`;
}

async function cargarRegistros() {
  const tbody = document.getElementById('horarios-tbody');
  if (tbody) {
    tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;padding:20px;color:var(--text3)">Cargando...</td></tr>';
  }

  const { desde, hasta } = buildFiltros();
  let fechaFiltro = null;
  if (desde && !hasta) fechaFiltro = desde;
  if (!desde && hasta) fechaFiltro = hasta;
  if (desde && hasta && desde === hasta) fechaFiltro = desde;

  const res = await invokeApi('presencia:getFichajesPersonales', fechaFiltro ? { fechaFiltro } : {});
  if (!res.ok) {
    if (tbody) tbody.innerHTML = `<tr><td colspan="5" style="text-align:center;padding:20px;color:var(--danger)">Error: ${escapeHtml(res.error || 'Error')}</td></tr>`;
    showToast('Error al cargar horarios: ' + (res.error || 'Error desconocido'), 'warning');
    return;
  }

  let rows = res.data || [];
  rows = filterRows(rows, desde, hasta);

  rows.sort((a, b) => {
    const da = parseFechaHora(a);
    const db = parseFechaHora(b);
    const ta = da ? da.getTime() : 0;
    const tb = db ? db.getTime() : 0;
    return tb - ta;
  });

  state.registros = rows;
  state.selectedId = null;
  state.selectedRow = null;
  renderTable(rows);
  updateStatus(rows, desde, hasta);
}

async function eliminarRegistroHorario() {
  if (!state.selectedId) {
    showToast('Selecciona un registro primero.', 'warning');
    return;
  }

  openDeleteModal();
}

async function confirmarEliminarHorario() {
  if (!state.selectedId) {
    showToast('Selecciona un registro primero.', 'warning');
    return;
  }

  const motivoTxt = getMotivoFromInput('horario-motivo-delete');
  if (!motivoTxt) return;

  const before = state.selectedRow || state.registros.find(r => getRegistroId(r) === String(state.selectedId)) || null;
  const res = await invokeApi('presencia:deleteFichaje', {
    idControlPresenciaFichaje: state.selectedId,
    motivo: motivoTxt,
    before,
    source: 'horarios'
  });
  if (!res.ok) {
    showToast('Error al eliminar: ' + (res.error || 'Error desconocido'), 'warning');
    return;
  }

  showToast('Registro eliminado correctamente.', 'success');
  closeDeleteModal();
  state.selectedId = null;
  state.selectedRow = null;
  await cargarRegistros();
  notifyInformePresenciaRefresh();
}

async function guardarEdicionHorario() {
  if (!state.selectedId) {
    showToast('Selecciona un registro primero.', 'warning');
    return;
  }

  const fecha = document.getElementById('horario-fecha')?.value || '';
  const hora = document.getElementById('horario-hora')?.value || '';
  const tipo = Number(document.getElementById('horario-evento')?.value);

  if (!fecha || !hora || !Number.isFinite(tipo)) {
    showToast('Completa fecha, hora y evento.', 'warning');
    return;
  }

  const motivoTxt = getMotivoFromInput('horario-motivo-edit');
  if (!motivoTxt) return;

  const before = state.selectedRow || state.registros.find(r => getRegistroId(r) === String(state.selectedId)) || null;
  const res = await invokeApi('presencia:updateFichaje', {
    idControlPresenciaFichaje: state.selectedId,
    idControlPresenciaTipoEvento: tipo,
    fecha,
    hora,
    motivo: motivoTxt,
    before,
    source: 'horarios'
  });

  if (!res.ok) {
    showToast('Error al modificar: ' + (res.error || 'Error desconocido'), 'warning');
    return;
  }

  showToast('Registro actualizado correctamente.', 'success');
  closeHorarioModal();
  state.selectedId = null;
  state.selectedRow = null;
  await cargarRegistros();
  notifyInformePresenciaRefresh();
}

function abrirEdicionHorario() {
  if (!state.selectedId) {
    showToast('Selecciona un registro primero.', 'warning');
    return;
  }
  const row = state.selectedRow || state.registros.find(r => getRegistroId(r) === String(state.selectedId));
  if (!row) {
    showToast('No se pudo localizar el registro seleccionado.', 'warning');
    return;
  }
  openHorarioModal(row);
}

function abrirLogsHorarios() {
  if (window.api && window.api.send) {
    window.api.send('horariosLogs:open');
  }
}

async function init() {
  const session = await invokeApi('auth:getSession');
  if (session.ok && session.data) {
    state.session = session.data;
    const nombre = session.data.nombre || 'Usuario';
    const label = document.getElementById('horarios-user');
    if (label) label.textContent = nombre;
    if (session.data.idPersonal == null) {
      showToast('No se pudo resolver el usuario de la sesion.', 'warning');
    }
  }

  const desdeEl = document.getElementById('fecha-desde');
  const hastaEl = document.getElementById('fecha-hasta');
  const hoy = todayISO();
  if (desdeEl && !desdeEl.value) desdeEl.value = hoy;
  if (hastaEl && !hastaEl.value) hastaEl.value = hoy;

  fillEventoOptions();
  await cargarRegistros();
}

document.getElementById('btn-buscar').addEventListener('click', cargarRegistros);
document.getElementById('btn-refrescar').addEventListener('click', cargarRegistros);
document.getElementById('btn-horario-editar').addEventListener('click', abrirEdicionHorario);
document.getElementById('btn-horario-eliminar').addEventListener('click', eliminarRegistroHorario);
document.getElementById('btn-horario-logs').addEventListener('click', abrirLogsHorarios);
document.getElementById('horario-modal-close').addEventListener('click', closeHorarioModal);
document.getElementById('horario-modal-cancelar').addEventListener('click', closeHorarioModal);
document.getElementById('horario-modal-guardar').addEventListener('click', guardarEdicionHorario);
document.getElementById('horario-delete-close').addEventListener('click', closeDeleteModal);
document.getElementById('horario-delete-cancelar').addEventListener('click', closeDeleteModal);
document.getElementById('horario-delete-confirm').addEventListener('click', confirmarEliminarHorario);
init();

