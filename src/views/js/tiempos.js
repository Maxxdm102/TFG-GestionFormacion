const state = {
  tiempos: [],
  personal: [],
  currentIdPersonal: null,
  idTarea: null,
  idIdentidad: null,
  selectedTiempoId: null,
  modalMode: null,
};

function showToast(msg, type = 'info') {
  const toast = document.getElementById('toast');
  toast.textContent = msg;
  toast.className = 'toast toast-' + type + ' show';
  clearTimeout(toast._t);
  toast._t = setTimeout(() => toast.classList.remove('show'), 3000);
}

function formatFecha(val) {
  if (!val) return '—';
  const s = String(val).trim();
  if (/^\d{4}-\d{2}-\d{2}/.test(s)) {
    const parts = s.substring(0, 10).split('-');
    return `${parts[2]}/${parts[1]}/${parts[0]}`;
  }
  const parsed = new Date(val);
  if (!Number.isNaN(parsed.getTime())) {
    const d = String(parsed.getDate()).padStart(2, '0');
    const m = String(parsed.getMonth() + 1).padStart(2, '0');
    const y = parsed.getFullYear();
    return `${d}/${m}/${y}`;
  }
  return s;
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

function getPersonalNombre(idPersonal) {
  const p = state.personal.find(x => String(x.id) === String(idPersonal));
  return p ? p.nombre : '';
}

function poblarPersonal() {
  const sel = document.getElementById('asignada');
  if (!sel) return;
  sel.innerHTML = state.personal
    .map(p => `<option value="${p.id}">${p.nombre}</option>`)
    .join('');

  if (state.currentIdPersonal != null) {
    const target = String(state.currentIdPersonal);
    const exists = state.personal.some(p => String(p.id) === target);
    if (exists) {
      sel.value = target;
      sel.disabled = true;
    } else {
      showToast('No se pudo resolver el usuario asignado.', 'warning');
    }
  }
}

function buildFiltros() {
  const sel = document.getElementById('asignada');
  const fechaDesde = document.getElementById('fecha-desde').value || null;
  const fechaHasta = document.getElementById('fecha-hasta').value || null;

  return {
    idTarea: state.idTarea,
    idPersonalAsignado: sel && sel.value ? Number(sel.value) : null,
    fechaDesde,
    fechaHasta,
  };
}

function renderTable(rows) {
  const tbody = document.getElementById('tiempos-tbody');
  if (!tbody) return;

  if (!rows.length) {
    tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;padding:20px;color:var(--text3)">Sin registros.</td></tr>';
    return;
  }

  const timeRowsHtml = rows.map(r => {
    const horas = Number(r.Horas || 0).toFixed(2);
    const asignada = r.PersonalAsignado || getPersonalNombre(r.IdPersonalAsignado) || '—';

    return `
      <tr data-id="${r.IdTareaTiempo}">
        <td>${asignada}</td>
        <td>${formatFecha(r.Fecha)}</td>
        <td class="mono" style="text-align:right">${horas} h</td>
        <td class="mono" style="text-align:right"></td>
        <td class="mono"></td>
        <td></td>
        <td></td>
        <td class="desc-cell"></td>
        <td class="desc-cell"></td>
      </tr>
    `;
  }).join('');

  const totalHoras = rows.reduce((s, r) => s + Number(r.Horas || 0), 0);
  const base = rows[0] || {};
  const asignadaTotal = base.PersonalAsignado || getPersonalNombre(base.IdPersonalAsignado) || '—';
  const hEstTotal = Number(base.HorasEstimadas || 0).toFixed(2);
  const presupuestoTotal = base.Presupuesto || '—';
  const clienteTotal = base.Cliente || '—';
  const descTotal = base.Descripcion || '';
  const comentarioTotal = base.Comentario || '';

  const totalRowHtml = `
    <tr class="tiempos-total-row">
      <td>${asignadaTotal}</td>
      <td></td>
      <td class="mono" style="text-align:right">${totalHoras.toFixed(2)} h</td>
      <td class="mono" style="text-align:right">${hEstTotal} h</td>
      <td class="mono">${base.IdTarea || ''}</td>
      <td>${presupuestoTotal}</td>
      <td>${clienteTotal}</td>
      <td class="desc-cell">${descTotal}</td>
      <td class="desc-cell">${comentarioTotal}</td>
    </tr>
  `;

  tbody.innerHTML = timeRowsHtml + totalRowHtml;

  tbody.querySelectorAll('tr[data-id]').forEach(tr => {
    tr.addEventListener('click', () => {
      tbody.querySelectorAll('tr').forEach(r => r.classList.remove('tiempos-row-selected'));
      tr.classList.add('tiempos-row-selected');
      state.selectedTiempoId = Number(tr.dataset.id);
    });
  });
}

function updateStatus(rows) {
  const totalEl = document.getElementById('tiempos-total');
  if (totalEl) totalEl.textContent = `${rows.length} registros`;

  const status = document.getElementById('tiempos-status');
  if (!status) return;

  const asignadaNombre = state.currentIdPersonal != null
    ? getPersonalNombre(state.currentIdPersonal)
    : getPersonalNombre(document.getElementById('asignada')?.value);

  const left = status.querySelector('.status-filter');
  const tareaTxt = state.idTarea != null ? `Tarea ${state.idTarea}` : 'Tarea —';
  if (left) {
    const icon = window.UiIcons ? window.UiIcons.iconMarkup('search', 'status-filter-icon') : '<span class="status-filter-icon">F</span>';
    left.innerHTML = `${icon}Filtrando: ${tareaTxt} · Asignada a ${asignadaNombre || '—'}`;
  }

  const right = status.querySelector('.statusbar-right');
  if (right) right.textContent = `Registros: ${rows.length} - Tiempo: 0 s`;
}

async function cargarTiempos() {
  const tbody = document.getElementById('tiempos-tbody');
  if (tbody) {
    tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;padding:20px;color:var(--text3)">Cargando...</td></tr>';
  }

  if (!state.idTarea) {
    if (tbody) {
      tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;padding:20px;color:var(--text3)">Selecciona una tarea para ver sus tiempos.</td></tr>';
    }
    return;
  }

  const filtros = buildFiltros();
  const res = await invokeApi('tiempos:getAll', filtros);
  if (!res.ok) {
    if (tbody) tbody.innerHTML = `<tr><td colspan="9" style="text-align:center;padding:20px;color:var(--danger)">Error: ${res.error}</td></tr>`;
    showToast('Error al cargar tiempos: ' + res.error, 'warning');
    return;
  }

  state.tiempos = res.data || [];
  state.selectedTiempoId = null;
  renderTable(state.tiempos);
  updateStatus(state.tiempos);
}

function openTiempoModal(mode) {
  if (!state.idTarea) {
    showToast('Selecciona una tarea primero.', 'warning');
    return;
  }

  if ((mode === 'editar' || mode === 'eliminar') && !state.selectedTiempoId) {
    showToast('Selecciona un registro de tiempo.', 'warning');
    return;
  }

  if (mode === 'eliminar') {
    eliminarTiempo();
    return;
  }

  state.modalMode = mode;
  const title = mode === 'nuevo' ? 'Crear registro de tiempo' : 'Modificar registro de tiempo';
  document.getElementById('tiempo-modal-title').textContent = title;

  const fechaEl = document.getElementById('tiempo-fecha');
  const horasEl = document.getElementById('tiempo-horas');
  const comentEl = document.getElementById('tiempo-comentario');

  if (mode === 'nuevo') {
    fechaEl.value = todayISO();
    horasEl.value = '';
    comentEl.value = '';
  } else {
    const row = state.tiempos.find(t => Number(t.IdTareaTiempo) === Number(state.selectedTiempoId));
    if (!row) {
      showToast('No se pudo cargar el registro.', 'warning');
      return;
    }
    fechaEl.value = row.Fecha ? String(row.Fecha).substring(0, 10) : todayISO();
    horasEl.value = row.Horas != null ? Number(row.Horas).toFixed(2) : '';
    comentEl.value = row.Comentario || '';
  }

  document.getElementById('tiempo-modal-backdrop').classList.add('open');
}

function closeTiempoModal() {
  document.getElementById('tiempo-modal-backdrop').classList.remove('open');
}

async function guardarTiempoModal() {
  const fecha = document.getElementById('tiempo-fecha').value || '';
  const horasRaw = document.getElementById('tiempo-horas').value || '';
  const horas = parseFloat(String(horasRaw).replace(',', '.'));
  const comentario = document.getElementById('tiempo-comentario').value.trim();

  if (!fecha) {
    showToast('Selecciona una fecha.', 'warning');
    return;
  }
  if (isNaN(horas) || horas <= 0) {
    showToast('Introduce horas válidas.', 'warning');
    return;
  }
  if (horas > 24) {
    showToast('No se pueden registrar más de 24 horas en un día.', 'warning');
    return;
  }

  let res;
  if (state.modalMode === 'nuevo') {
    res = await invokeApi('tiempos:create', {
      idTarea: state.idTarea,
      fecha,
      horas,
      comentario,
      idIdentidad: state.idIdentidad
    });
  } else {
    res = await invokeApi('tiempos:update', {
      idTareaTiempo: state.selectedTiempoId,
      idTarea: state.idTarea,
      fecha,
      horas,
      comentario,
      idIdentidad: state.idIdentidad
    });
  }

  if (!res.ok) {
    showToast(res.error, 'warning');
    return;
  }

  closeTiempoModal();
  state.selectedTiempoId = null;
  await cargarTiempos();
  showToast('Registro guardado correctamente.', 'success');
}

async function eliminarTiempo() {
  if (!state.selectedTiempoId) {
    showToast('Selecciona un registro de tiempo.', 'warning');
    return;
  }
  if (!confirm('¿Eliminar el registro de tiempo seleccionado?')) return;

  const res = await invokeApi('tiempos:delete', {
    idTareaTiempo: state.selectedTiempoId,
    idTarea: state.idTarea
  });
  if (!res.ok) {
    showToast(res.error, 'warning');
    return;
  }
  state.selectedTiempoId = null;
  await cargarTiempos();
  showToast('Registro eliminado correctamente.', 'success');
}

function setContext(payload) {
  const id = payload && payload.idTarea ? Number(payload.idTarea) : null;
  state.idTarea = Number.isFinite(id) ? id : null;
  const el = document.getElementById('tiempos-task-id');
  if (el) el.textContent = state.idTarea != null ? String(state.idTarea) : '—';
  cargarTiempos();
}

async function init() {
  window.api.on('tiempos:setContext', setContext);

  const session = await invokeApi('auth:getSession');
  if (session.ok && session.data) {
    state.currentIdPersonal = session.data.idPersonal || null;
    state.idIdentidad = session.data.id || null;
    if (state.currentIdPersonal == null) {
      showToast('No se pudo resolver el usuario de la sesion.', 'warning');
    }
  }

  const perRes = await invokeApi('personal:getAll', {});
  state.personal = (perRes.ok ? perRes.data : []).map(p => ({
    id: p.IdPersonal,
    nombre: p.NombreCompleto || '',
    activo: p.Activo == 1 || p.Activo === true || p.Activo === 'Si'
  }));

  poblarPersonal();
  await cargarTiempos();
}

document.getElementById('btn-buscar').addEventListener('click', cargarTiempos);
document.getElementById('btn-refrescar').addEventListener('click', cargarTiempos);
document.getElementById('btn-tiempo-nuevo').addEventListener('click', () => openTiempoModal('nuevo'));
document.getElementById('btn-tiempo-editar').addEventListener('click', () => openTiempoModal('editar'));
document.getElementById('btn-tiempo-eliminar').addEventListener('click', () => openTiempoModal('eliminar'));
document.getElementById('tiempo-modal-close').addEventListener('click', closeTiempoModal);
document.getElementById('tiempo-modal-cancelar').addEventListener('click', closeTiempoModal);
document.getElementById('tiempo-modal-guardar').addEventListener('click', guardarTiempoModal);
document.getElementById('tiempo-horas').addEventListener('input', (e) => {
  const v = String(e.target.value || '');
  if (v.includes(',')) e.target.value = v.replace(',', '.');
});

init();
