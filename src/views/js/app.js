/* ==================================================
   APP.JS - Renderer (Vista)
   UI con persistencia en SQL Server via window.api.invoke
   ================================================== */

const UI_ICONS = Object.freeze({
  plus: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5v14M5 12h14"/></svg>',
  eye: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6-10-6-10-6Z"/><circle cx="12" cy="12" r="3"/></svg>',
  edit: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 20h9"/><path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/></svg>',
  trash: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 6h18"/><path d="M8 6V4h8v2"/><path d="M19 6l-1 14H6L5 6"/><path d="M10 11v6M14 11v6"/></svg>',
  copy: '<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="9" y="9" width="11" height="11" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>',
  refresh: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 11a8 8 0 1 0 2 5.5"/><path d="M20 4v7h-7"/></svg>',
  timer: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="14" r="8"/><path d="M12 10v4l2.5 2.5"/><path d="M9 2h6"/><path d="M15 5 16.5 3.5"/></svg>',
  calendar: '<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>',
  chart: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 20h16"/><path d="M8 16v-4"/><path d="M12 16V8"/><path d="M16 16v-7"/></svg>',
  filter: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 5h16l-6 7v5l-4 2v-7Z"/></svg>',
  search: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="6.5"/><path d="m16 16 5 5"/></svg>',
  bookmark: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M7 4h10a1 1 0 0 1 1 1v15l-6-3-6 3V5a1 1 0 0 1 1-1Z"/></svg>',
  folder: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 7h5l2 2h11v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2Z"/><path d="M3 7a2 2 0 0 1 2-2h4l2 2"/></svg>',
  'line-chart': '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19h16"/><path d="m5 15 4-4 4 3 6-7"/></svg>',
  calculator: '<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="6" y="3" width="12" height="18" rx="2"/><path d="M9 8h6"/><path d="M9 12h.01M12 12h.01M15 12h.01M9 15h.01M12 15h.01M15 15h.01M9 18h.01M12 18h.01M15 18h.01"/></svg>',
  save: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 4h11l3 3v13H5Z"/><path d="M8 4v6h8V4"/><path d="M9 17h6"/></svg>',
  message: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 6h14a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H9l-4 3v-3H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2Z"/></svg>',
  pending: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="8"/><path d="M12 8v4l2.5 2"/></svg>',
  'status-working': '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="8"/><path d="m8.5 12 2.5 2.5 4.5-5"/></svg>',
  'status-pause': '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="8"/><path d="M10 9v6M14 9v6"/></svg>',
  'status-offline': '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="8"/><path d="m9 9 6 6M15 9l-6 6"/></svg>',
});

function getIconSvg(name) {
  return UI_ICONS[name] || '';
}

function setIcon(el, name) {
  if (!el) return;
  el.dataset.icon = name;
  el.innerHTML = getIconSvg(name);
}

function iconMarkup(name, className = '') {
  const classes = className ? ` class="${className}"` : '';
  return `<span${classes} data-icon="${name}" aria-hidden="true">${getIconSvg(name)}</span>`;
}

function hydrateIcons(root = document) {
  root.querySelectorAll('[data-icon]').forEach((el) => {
    const name = el.dataset.icon;
    if (name) el.innerHTML = getIconSvg(name);
  });
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => hydrateIcons());
} else {
  hydrateIcons();
}

const pageTitles = {
  tareas: 'Tareas — TareasGForma',
  clientes: 'Clientes — TareasGForma',
  presupuestos: 'Presupuestos — TareasGForma',
  contactos: 'Contactos — TareasGForma',
};

const urlParams = new URLSearchParams(window.location.search);
const standalonePage = urlParams.get('standalone');
const standaloneMode = urlParams.get('mode');
const standaloneTareaId = urlParams.get('id');
const isStandaloneWindow = Boolean(standalonePage);
const isStandaloneTarea = standalonePage === 'tarea';

// En ventanas secundarias (standalone) no queremos el indicador inferior derecho.
if (isStandaloneWindow) {
  document.body.classList.add('hide-status-right');
}

async function switchPage(name) {
  if (!isStandaloneWindow) {
    if (name === 'clientes') {
      openClientesWindow();
      return;
    }
    if (name === 'contactos') {
      openContactosWindow();
      return;
    }
  }

  if (name !== currentPage) previousPage = currentPage;
  currentPage = name;
  document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));

  const page = document.getElementById('page-' + name);
  if (page) page.classList.add('active');

  const titleEl = document.getElementById('titlebar-text');
  if (titleEl) titleEl.textContent = pageTitles[name] || name;

  closeAllMenus();
  if (name === 'clientes') cargarClientes();
}

function salirApp() {
  closeAllMenus();
  window.close();
}

function openTiemposWindow() {
  if (selectedIdx < 0 || !taskData[selectedIdx]) {
    showToast('Selecciona una tarea primero.', 'warning');
    return;
  }
  const tarea = taskData[selectedIdx];
  if (!tarea.id) {
    showToast('La tarea seleccionada no tiene ID.', 'warning');
    return;
  }
  closeAllMenus();
  window.api.send('tiempos:open', { idTarea: tarea.id });
}

function openHorariosWindow() {
  closeAllMenus();
  window.api.send('horarios:open');
}

function openPresenciaInformeWindow() {
  closeAllMenus();
  window.api.send('presenciaInforme:open');
}

function openClientesWindow() {
  closeAllMenus();
  window.api.send('clientes:open');
}

function openContactosWindow(context) {
  closeAllMenus();
  let ctx = context || null;
  let resolvedNombre = '';

  if (!ctx || ctx.idCliente == null) {
    const clienteEl = document.getElementById('cliente');
    const clienteNombre = clienteEl?.value.trim() || '';
    resolvedNombre = clienteNombre;
    let idCliente = null;
    if (clienteEl?.dataset?.idCliente) {
      const n = Number(clienteEl.dataset.idCliente);
      idCliente = Number.isFinite(n) ? n : null;
    }
    if (!idCliente && clienteNombre) {
      const target = normalizeNoDiacritics(clienteNombre);
      const match = clientesData.find(c => normalizeNoDiacritics(c.nombre) === target);
      if (match && match.id != null) idCliente = match.id;
    }
    if (idCliente != null || clienteNombre) {
      ctx = { cliente: clienteNombre, idCliente };
    }
  }

  if (!ctx || ctx.idCliente == null) {
    showToast('Selecciona un cliente antes de abrir Contactos.', 'warning');
    return;
  }

  if (!ctx.cliente && resolvedNombre) {
    ctx.cliente = resolvedNombre;
  }
  if (!ctx.cliente && ctx.idCliente != null) {
    const match = clientesFullData.find(c => String(c.IdCliente || c.Id) === String(ctx.idCliente))
      || clientesData.find(c => String(c.id) === String(ctx.idCliente));
    const nombre = match?.NombreComercial || match?.RazonSocial || match?.nombre || '';
    if (nombre) ctx.cliente = nombre;
  }

  window.api.send('contactos:open', ctx);
}

function openTareaWindow(mode) {
  if (isStandaloneTarea) {
    openModal(mode);
    return;
  }

  if (mode !== 'nuevo' && (selectedIdx < 0 || !taskData[selectedIdx])) {
    showToast('Selecciona una tarea primero.', 'warning');
    return;
  }

  const idTarea = (mode === 'nuevo') ? null : taskData[selectedIdx].id;
  closeAllMenus();
  window.api.send('tareas:open', { mode, idTarea });
}

const menus = [
  'general', 'ver', 'archivos', 'avisos',
  'cli-general', 'cli-archivos', 'cli-avisos', 'cli-campos', 'cli-informes', 'cli-datos',
  'pre-general', 'pre-archivos', 'pre-avisos', 'pre-criterios', 'pre-informes', 'pre-datos',
  'con-general', 'con-otros', 'con-datos'
];

function toggleMenu(id) {
  const dd = document.getElementById('dd-' + id);
  const btn = document.querySelector('#menu-' + id + ' .menu-btn');
  const isOpen = dd && dd.classList.contains('open');
  closeAllMenus();
  if (!isOpen && dd) {
    dd.classList.add('open');
    if (btn) btn.classList.add('active');
    document.getElementById('menu-overlay').classList.add('open');
  }
}

function closeAllMenus() {
  menus.forEach(id => {
    document.getElementById('dd-' + id)?.classList.remove('open');
    document.querySelector('#menu-' + id + ' .menu-btn')?.classList.remove('active');
  });
  document.getElementById('menu-overlay').classList.remove('open');
}

function toggleTareasFiltros(force) {
  const panel = document.getElementById('tareas-filter-panel');
  if (!panel) return;
  const next = (force === true) ? true : (force === false ? false : !panel.classList.contains('open'));
  panel.classList.toggle('open', next);
  const btn = document.getElementById('btn-tareas-filtros');
  if (btn) btn.classList.toggle('active', next);
}

document.getElementById('menu-overlay').addEventListener('click', closeAllMenus);
document.querySelectorAll('.dropdown').forEach(dd => {
  dd.addEventListener('click', e => {
    if (e.target.closest('.dropdown-item')) closeAllMenus();
  });
});

let taskData = [];
let selectedIdx = -1;
let currentFiltros = {};

let clientesData = [];
let clientesFullData = [];
let selectedClienteIdx = -1;
let presupuestosData = [];
let contactosData = [];
let contactosFullData = [];
let selectedContactoIdx = -1;
let personalData = [];  // cache de todo el personal
let currentUserId = null; // IdIdentidad del usuario autenticado
let currentUserPersonalId = null; // IdPersonal del usuario autenticado
let currentUserNombre = ''; // Nombre del usuario autenticado
let currentPage = 'tareas';
let previousPage = null;
let clienteReturn = null;
let presupuestoReturn = null;
let contactosReturn = null;
let contactosContextIdCliente = null;
let contactosContextCliente = '';

// Rellena los <select> de resp1 y resp2 filtrando por activo
function poblarSelectPersonal(selectId, soloActivos) {
  const sel = document.getElementById(selectId);
  if (!sel) return;
  const valorActual = sel.value;
  const lista = soloActivos ? personalData.filter(p => p.activo) : personalData;
  sel.innerHTML = '<option value="">— Seleccionar —</option>' +
    lista.map(p => `<option value="${p.id}">${p.nombre}</option>`).join('');
  // Restaurar valor si sigue disponible (el valor es el ID numérico)
  if (valorActual && lista.some(p => String(p.id) === String(valorActual))) sel.value = valorActual;
}

function poblarFiltroPersonal(selectId) {
  const sel = document.getElementById(selectId);
  if (!sel) return;
  const valorActual = sel.value;
  sel.innerHTML = '<option value="">— Todos —</option>' +
    personalData.map(p => `<option value="${p.id}">${p.nombre}</option>`).join('');
  if (valorActual && personalData.some(p => String(p.id) === String(valorActual))) sel.value = valorActual;
}

function setAsignadaFiltroSesion() {
  const sel = document.getElementById('tf-asignada-sel');
  if (!sel) return;

  if (currentUserPersonalId != null) {
    const p = personalData.find(x => String(x.id) === String(currentUserPersonalId));
    const nombre = p?.nombre || currentUserNombre || '—';
    sel.innerHTML = `<option value="${currentUserPersonalId}">${nombre}</option>`;
    sel.value = String(currentUserPersonalId);
    sel.disabled = true;

    const cb = document.getElementById('tf-asignada');
    if (cb) { cb.checked = true; cb.disabled = true; }
    return;
  }

  if (currentUserNombre) {
    sel.innerHTML = `<option value="">${currentUserNombre}</option>`;
    sel.disabled = true;
    const cb = document.getElementById('tf-asignada');
    if (cb) { cb.checked = true; cb.disabled = true; }
  }
}

function setContactosPersonalSesion() {
  const input = document.getElementById('cf-personal-txt');
  if (!input) return;
  let nombre = '';
  if (currentUserPersonalId != null) {
    const p = personalData.find(x => String(x.id) === String(currentUserPersonalId));
    nombre = p?.nombre || '';
  }
  if (!nombre) nombre = currentUserNombre || '';
  input.value = nombre;
}

function applyContactosContextToUi() {
  const input = document.getElementById('cf-cliente-txt');
  if (!input) return;

  if (contactosContextCliente) {
    input.value = contactosContextCliente;
    input.readOnly = true;
    return;
  }

  if (contactosContextIdCliente != null && clientesFullData.length) {
    const match = clientesFullData.find(c => String(c.IdCliente || c.Id) === String(contactosContextIdCliente));
    const nombre = match?.NombreComercial || match?.RazonSocial || '';
    if (nombre) {
      contactosContextCliente = nombre;
      input.value = nombre;
      input.readOnly = true;
    }
  }
}

async function ensureContactosClienteNombre() {
  const input = document.getElementById('cf-cliente-txt');
  if (!input) return;

  if (contactosContextCliente) {
    input.value = contactosContextCliente;
    input.readOnly = true;
    return;
  }

  if (contactosContextIdCliente != null && clientesFullData.length) {
    const match = clientesFullData.find(c => String(c.IdCliente || c.Id) === String(contactosContextIdCliente));
    const nombre = match?.NombreComercial || match?.RazonSocial || '';
    if (nombre) {
      contactosContextCliente = nombre;
      input.value = nombre;
      input.readOnly = true;
      return;
    }
  }

  if (contactosContextIdCliente != null) {
    const res = await invokeApi('clientes:getById', contactosContextIdCliente);
    if (res.ok && res.data) {
      const nombre = res.data.NombreComercial || res.data.RazonSocial || '';
      if (nombre) {
        contactosContextCliente = nombre;
        input.value = nombre;
        input.readOnly = true;
      }
    }
  }
}

function buildTareasFiltros() {
  const filtros = {};
  const today = todayISO();

  const toLike = (val) => {
    const raw = String(val || '').trim();
    if (!raw) return '';
    return raw.includes('%') ? raw : `%${raw}%`;
  };

  const getDate = (id) => {
    const v = document.getElementById(id)?.value;
    return v || null;
  };

  // Preservar el estado activo de las pestañas de estado
  const tabActiva = document.querySelector('.estado-tab.active');
  if (tabActiva) {
    const estado = estadoFromTab(tabActiva);
    if (estado) filtros.estado = estado;
  }

  // Asignada a
  const cbAsignada = document.getElementById('tf-asignada');
  if (cbAsignada?.checked) {
    const selAsignada = document.getElementById('tf-asignada-sel');
    const val = currentUserPersonalId != null
      ? currentUserPersonalId
      : (selAsignada && selAsignada.value ? Number(selAsignada.value) : null);
    if (val != null) filtros.idPersonalAsignado = val;
  }

  // Creada por
  const cbCrea = document.getElementById('tf-creada');
  if (cbCrea?.checked) {
    const selCrea = document.getElementById('tf-creada-sel');
    const val = selCrea && selCrea.value ? Number(selCrea.value) : null;
    if (val != null) filtros.idPersonalCreador = val;
  }

  // Activo
  const cbActivo = document.getElementById('tf-activo');
  if (cbActivo?.checked) filtros.activo = true;

  // Fecha de creación
  const cbFechaCrea = document.getElementById('tf-fecha-crea');
  if (cbFechaCrea?.checked) {
    filtros.fechaCreacionDesde = getDate('tf-fecha-crea-desde') || today;
    filtros.fechaCreacionHasta = getDate('tf-fecha-crea-hasta') || today;
  }

  // F. entrega
  const cbFechaEnt = document.getElementById('tf-fecha-ent');
  if (cbFechaEnt?.checked) {
    const si = document.getElementById('tf-fecha-ent-si')?.value;
    filtros.fechaEntregaSi = si;
    filtros.fechaEntregaDesde = getDate('tf-fecha-ent-desde') || today;
    filtros.fechaEntregaHasta = getDate('tf-fecha-ent-hasta') || today;
  }

  // Iniciada
  const cbIniciada = document.getElementById('tf-iniciada');
  if (cbIniciada?.checked) {
    const si = document.getElementById('tf-iniciada-si')?.value;
    filtros.iniciadaSi = si;
    filtros.iniciadaDesde = getDate('tf-iniciada-desde') || today;
    filtros.iniciadaHasta = getDate('tf-iniciada-hasta') || today;
  }

  // Finalizada
  const cbFinalizada = document.getElementById('tf-finalizada');
  if (cbFinalizada?.checked) {
    const si = document.getElementById('tf-finalizada-si')?.value;
    filtros.finalizadaSi = si;
  }

  // Comprobada
  const cbComprobada = document.getElementById('tf-comprobada');
  if (cbComprobada?.checked) {
    const si = document.getElementById('tf-comprobada-si')?.value;
    filtros.comprobadaSi = si;
    filtros.comprobadaDesde = getDate('tf-comprobada-desde') || today;
    filtros.comprobadaHasta = getDate('tf-comprobada-hasta') || today;
  }

  // Con tiempos
  const cbTiempos = document.getElementById('tf-contiempos');
  if (cbTiempos?.checked) {
    const si = document.getElementById('tf-contiempos-si')?.value;
    filtros.conTiemposSi = si;
    filtros.conTiemposDesde = getDate('tf-contiempos-desde') || today;
    filtros.conTiemposHasta = getDate('tf-contiempos-hasta') || today;
  }

  // Tipo
  const cbTipo = document.getElementById('tf-tipo');
  const tipoVal = document.getElementById('tf-tipo-sel')?.value;
  if (cbTipo?.checked && tipoVal) filtros.tipo = tipoVal;

  // Estado (panel, no tabs)
  const cbEstado = document.getElementById('tf-estado');
  const estadoVal = document.getElementById('tf-estado-sel')?.value;
  if (cbEstado?.checked && estadoVal && !filtros.estado) filtros.estado = estadoVal.toLowerCase().replace('en espera', 'espera');

  // Descripción
  const cbDesc = document.getElementById('tf-desc');
  const descVal = document.getElementById('tf-desc-txt')?.value.trim();
  if ((cbDesc?.checked || descVal) && descVal) filtros.descripcion = toLike(descVal);

  // Comentario
  const cbCom = document.getElementById('tf-comentario');
  const comVal = document.getElementById('tf-comentario-txt')?.value.trim();
  if ((cbCom?.checked || comVal) && comVal) filtros.comentario = toLike(comVal);

  // Observaciones
  const cbObs = document.getElementById('tf-obs');
  const obsVal = document.getElementById('tf-obs-txt')?.value.trim();
  if ((cbObs?.checked || obsVal) && obsVal) filtros.observaciones = toLike(obsVal);

  // Desc. presupuesto
  const cbDescPres = document.getElementById('tf-desc-pres');
  const descPresVal = document.getElementById('tf-desc-pres-txt')?.value.trim();
  if ((cbDescPres?.checked || descPresVal) && descPresVal) filtros.descripcionPresupuesto = toLike(descPresVal);

  // Cliente
  const cbCliente = document.getElementById('tf-cliente');
  const clienteVal = document.getElementById('tf-cliente-txt')?.value.trim();
  if ((cbCliente?.checked || clienteVal) && clienteVal) filtros.cliente = toLike(clienteVal);

  // Presupuesto
  const cbPresupuesto = document.getElementById('tf-presupuesto');
  const presupuestoVal = document.getElementById('tf-presupuesto-txt')?.value.trim();
  if ((cbPresupuesto?.checked || presupuestoVal) && presupuestoVal) filtros.presupuesto = toLike(presupuestoVal);

  // Albaraneada
  const cbAlbaran = document.getElementById('tf-albaran');
  if (cbAlbaran?.checked) filtros.albaraneada = true;

  return filtros;
}

async function buscarTareasConFiltros() {
  currentFiltros = buildTareasFiltros();
  await cargarTareas(currentFiltros);
  toggleTareasFiltros(false); // Cerramos el panel al buscar para ver resultados
  showToast('Búsqueda aplicada.', 'success');
}

function todayISO() {
  const d = new Date();
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

async function cargarClientes(filtros = {}) {
  const tbody = document.getElementById('clientes-tbody');
  if (!tbody) return;
  tbody.innerHTML = `<tr><td colspan="10" style="text-align:center;padding:24px;color:var(--text3)">Cargando...</td></tr>`;

  const res = await invokeApi('clientes:getAll', filtros);
  const lista = res.ok ? res.data : [];
  clientesFullData = lista;
  // also update clientesData used by search dropdowns
  clientesData = (lista || []).map(c => ({
    id: c.Id || c.IdCliente || null,
    num: c.Numero || '',
    nombre: c.NombreComercial || '',
    tipo: c.TipoDocumento || '',
    pais: c.Pais || '',
    provincia: c.Provincia || '',
    tel: c.Telefono || ''
  }));

  if (!lista || lista.length === 0) {
    selectedClienteIdx = -1;
    tbody.innerHTML = `<tr><td colspan="10" style="text-align:center;padding:40px;color:var(--text3);font-size:13px">Sin resultados. Use los filtros para buscar clientes.</td></tr>`;
    return;
  }

  const rows = lista.map(c => `
    <tr>
      <td>${formatClientCell(c.Numero)}</td>
      <td>${formatClientCell(c.NombreComercial)}</td>
      <td>${formatClientCell(c.RazonSocial)}</td>
      <td>${formatClientCell(c.TipoDocumento)}</td>
      <td>${formatClientCell(c.NumeroDocumento)}</td>
      <td>${formatClientCell(c.Pais)}</td>
      <td>${formatClientCell(c.Provincia)}</td>
      <td>${formatClientCell(c.Poblacion)}</td>
      <td>${formatClientCell(c.Direccion)}</td>
      <td>${formatClientCell(c.Telefono)}</td>
    </tr>
  `).join('');

  tbody.innerHTML = rows;
  selectedClienteIdx = -1;
  tbody.querySelectorAll('tr').forEach((row, idx) => {
    row.addEventListener('click', () => selectClienteRow(row, idx));
  });
}

function selectClienteRow(row, idx) {
  document.querySelectorAll('#clientes-tbody tr').forEach(r => r.classList.remove('selected'));
  row.classList.add('selected');
  selectedClienteIdx = idx;
}


function asignarClienteSeleccionado() {
  const sel = (selectedClienteIdx >= 0 && clientesFullData[selectedClienteIdx])
    ? clientesFullData[selectedClienteIdx]
    : null;
  if (!sel) {
    showToast('Selecciona un cliente primero.', 'warning');
    return;
  }

  const nombre = sel.NombreComercial || sel.RazonSocial || '';
  const idClienteSel = sel.Id || sel.IdCliente || null;

  if (isStandaloneWindow) {
    window.api.send('clientes:select', {
      id: idClienteSel,
      nombre
    });
    return;
  }

  const input = document.getElementById('cliente');
  if (input) {
    input.value = nombre;
    if (input.dataset) input.dataset.idCliente = idClienteSel || '';
  }

  const targetPage = (clienteReturn && clienteReturn.page) || previousPage || 'tareas';
  switchPage(targetPage);

  if (clienteReturn && clienteReturn.reopenModal) {
    document.getElementById('modal-backdrop').classList.add('open');
  }
  clienteReturn = null;
  showToast('Cliente asignado.', 'success');
}

function buildClientesFiltros() {
  const filtros = {};

  const toLike = (val) => {
    const raw = String(val || '').trim();
    if (!raw) return '';
    return raw.includes('%') ? raw : `%${raw}%`;
  };

  const getVal = (id) => document.getElementById(id)?.value.trim();

  const nombreVal = getVal('f-nombre-txt');
  if (nombreVal) filtros.nombre = toLike(nombreVal);

  const tipoDocVal = getVal('f-tipodoc-txt');
  if (tipoDocVal) filtros.tipoDocumento = toLike(tipoDocVal);

  const emailVal = getVal('f-email-txt');
  if (emailVal) filtros.email = toLike(emailVal);

  const paisVal = getVal('f-pais-txt');
  if (paisVal) filtros.pais = toLike(paisVal);

  const nDocVal = getVal('f-ndoc-txt');
  if (nDocVal) filtros.numeroDocumento = toLike(nDocVal);

  const numeroVal = getVal('f-numero-txt');
  if (numeroVal) filtros.numero = numeroVal;

  const telVal = getVal('f-telefono-txt');
  if (telVal) filtros.telefono = toLike(telVal);

  const provinciaVal = getVal('f-provincia-txt');
  if (provinciaVal) filtros.provincia = toLike(provinciaVal);

  return filtros;
}

async function buscarClientesConFiltros() {
  const filtros = buildClientesFiltros();
  await cargarClientes(filtros);
  showToast('Búsqueda aplicada.', 'success');
}

function buildContactosFiltros() {
  const filtros = {};

  if (contactosContextIdCliente != null) {
    filtros.idCliente = contactosContextIdCliente;
    if (contactosContextCliente) filtros.clienteTexto = contactosContextCliente;
  }

  const clienteTxt = document.getElementById('cf-cliente-txt')?.value.trim() || '';
  if (contactosContextIdCliente == null && clienteTxt) {
    // Intentar resolver IdCliente por nombre
    const target = normalizeNoDiacritics(clienteTxt);
    const match = clientesFullData.find(c =>
      normalizeNoDiacritics(c.NombreComercial || c.RazonSocial || '').includes(target)
    );
    if (match && (match.IdCliente || match.Id)) {
      filtros.idCliente = match.IdCliente || match.Id;
    } else {
      filtros.clienteTexto = clienteTxt;
    }
  }

  const clasTxt = document.getElementById('cf-clasificado-txt')?.value.trim() || '';
  if (clasTxt) filtros.clasificadoTexto = clasTxt;

  const tipoTxt = document.getElementById('cf-tipo-txt')?.value.trim() || '';
  if (tipoTxt) filtros.tipoTexto = tipoTxt;

  const estTxt = document.getElementById('cf-estado-txt')?.value.trim() || '';
  if (estTxt) filtros.estadoTexto = estTxt;

  const desde = document.getElementById('cf-fec-desde')?.value || '';
  const hasta = document.getElementById('cf-fec-hasta')?.value || '';
  if (desde) filtros.fechaDesde = desde;
  if (hasta) filtros.fechaHasta = hasta;

  const relCb = document.getElementById('cf-rellam');
  if (relCb?.checked) filtros.rellamada = true;

  filtros.nivelMostrar = 0;
  return filtros;
}

function readContactosUiFiltros() {
  return {
    clienteTexto: document.getElementById('cf-cliente-txt')?.value.trim() || '',
    clasificadoTexto: document.getElementById('cf-clasificado-txt')?.value.trim() || '',
    tipoTexto: document.getElementById('cf-tipo-txt')?.value.trim() || '',
    estadoTexto: document.getElementById('cf-estado-txt')?.value.trim() || ''
  };
}

function applyContactosLocalFilters(items, filtros) {
  if (!items || !items.length) return [];
  const f = filtros || {};
  const norm = (v) => normalizeNoDiacritics(v);

  return items.filter(c => {
    if (f.clienteTexto) {
      const cli = c._cliente || {};
      const nombre = norm(cli.NombreComercial || cli.RazonSocial || '');
      const numero = norm(cli.Numero || cli.NumeroDocumento || '');
      const q = norm(f.clienteTexto);
      if (!nombre.includes(q) && !numero.includes(q)) return false;
    }
    if (f.clasificadoTexto) {
      const val = norm(c.NombreClasificacion || '');
      if (!val.includes(norm(f.clasificadoTexto))) return false;
    }
    if (f.tipoTexto) {
      const val = norm(c.TipoContacto || '');
      if (!val.includes(norm(f.tipoTexto))) return false;
    }
    if (f.estadoTexto) {
      const val = norm(c.PlanificadoRealizadoTexto || c.EstadoContacto || '');
      if (!val.includes(norm(f.estadoTexto))) return false;
    }
    return true;
  });
}

function formatContactoCell(value) {
  if (value === null || value === undefined) return '—';
  if (typeof value === 'string' && value.trim() === '') return '—';
  return escapeHtml(value);
}

function updateContactosCounts(items) {
  const realizadosEl = document.getElementById('contactos-reg-realizados');
  const planificadosEl = document.getElementById('contactos-reg-planificados');
  const totalEl = document.getElementById('contactos-reg-total');

  const realizados = items.filter(r => {
    if (r.PlanificadoRealizado != null) return Number(r.PlanificadoRealizado) === 1;
    return String(r.PlanificadoRealizadoTexto || '').toLowerCase().includes('real');
  }).length;
  const planificados = items.filter(r => {
    if (r.PlanificadoRealizado != null) return Number(r.PlanificadoRealizado) === 0;
    return String(r.PlanificadoRealizadoTexto || '').toLowerCase().includes('plan');
  }).length;

  if (realizadosEl) realizadosEl.textContent = String(realizados);
  if (planificadosEl) planificadosEl.textContent = String(planificados);
  if (totalEl) totalEl.textContent = String(items.length);
}

async function cargarContactos(filtros = {}) {
  const tbody = document.getElementById('contactos-tbody');
  if (!tbody) return;
  tbody.innerHTML = `<tr><td colspan="15" style="text-align:center;padding:24px;color:var(--text3)">Cargando...</td></tr>`;

  const res = await invokeApi('contactos:getAll', filtros);
  if (!res.ok) {
    tbody.innerHTML = `<tr><td colspan="15" style="text-align:center;padding:24px;color:var(--danger)">Error: ${escapeHtml(res.error)}</td></tr>`;
    updateContactosCounts([]);
    showToast(res.error, 'warning');
    return;
  }

  const lista = res.data || [];
  const detalles = lista.filter(r => r.Nivel == null || Number(r.Nivel) === 0);

  const clienteMap = new Map();
  clientesFullData.forEach(c => {
    const id = c.IdCliente || c.Id;
    if (id != null) clienteMap.set(String(id), c);
  });
  const personalMap = new Map();
  personalData.forEach(p => {
    if (p.id != null) personalMap.set(String(p.id), p);
  });

  contactosFullData = detalles.map(r => {
    const idCli = r.IdPropietarioAsociado ?? r.IdCliente ?? null;
    const idPer = r.IdPropietarioRealizador ?? r.IdPersonal ?? null;
    return {
      ...r,
      _cliente: idCli != null ? clienteMap.get(String(idCli)) || null : null,
      _personal: idPer != null ? personalMap.get(String(idPer)) || null : null
    };
  });

  const uiFiltros = readContactosUiFiltros();
  const finalList = applyContactosLocalFilters(contactosFullData, uiFiltros);
  selectedContactoIdx = -1;

  if (!finalList.length) {
    tbody.innerHTML = `<tr><td colspan="15" style="text-align:center;padding:40px;color:var(--text3);font-size:13px">Sin resultados. Use los filtros para buscar contactos.</td></tr>`;
    updateContactosCounts([]);
    return;
  }

  const rows = finalList.map(c => {
    const cli = c._cliente || {};
    const per = c._personal || {};
    const numCli = cli.Numero || cli.NumeroDocumento || '';
    const nombreCli = cli.NombreComercial || cli.RazonSocial || '';
    const dir = cli.Direccion || '';
    const prov = cli.Provincia || '';
    const pob = cli.Poblacion || '';
    const tel = cli.Telefono || cli.Telefono1 || '';
    const personal = per.nombre || c.NombrePropietarioRealizador || currentUserNombre || '';

    const planReal = c.PlanificadoRealizadoTexto || (c.PlanificadoRealizado != null
      ? (Number(c.PlanificadoRealizado) === 1 ? 'Realizado' : 'Planificado')
      : '');
    const rell = c.RellamadaTexto || (c.Rellamada != null
      ? (Number(c.Rellamada) === 1 ? 'Sí' : 'No')
      : '');

    return `
      <tr>
        <td>${formatContactoCell(personal)}</td>
        <td>${formatContactoCell(formatFecha(c.Fecha))}</td>
        <td>${formatContactoCell(c.Hora)}</td>
        <td>${formatContactoCell(numCli)}</td>
        <td>${formatContactoCell(nombreCli)}</td>
        <td>${formatContactoCell(dir)}</td>
        <td>${formatContactoCell(prov)}</td>
        <td>${formatContactoCell(pob)}</td>
        <td>${formatContactoCell(tel)}</td>
        <td>${formatContactoCell(c.PersonaContactada)}</td>
        <td>${formatContactoCell(c.TipoContacto)}</td>
        <td>${formatContactoCell(planReal)}</td>
        <td>${formatContactoCell(rell)}</td>
        <td>${formatContactoCell(c.Observaciones)}</td>
        <td>${formatContactoCell(c.NombreClasificacion)}</td>
      </tr>
    `;
  }).join('');

  tbody.innerHTML = rows;
  tbody.querySelectorAll('tr').forEach((row, idx) => {
    row.addEventListener('click', () => selectContactoRow(row, idx));
  });

  updateContactosCounts(finalList);
}

function selectContactoRow(row, idx) {
  document.querySelectorAll('#contactos-tbody tr').forEach(r => r.classList.remove('selected'));
  row.classList.add('selected');
  selectedContactoIdx = idx;
}

async function buscarContactosConFiltros() {
  const filtros = buildContactosFiltros();
  await cargarContactos(filtros);
  showToast('Búsqueda aplicada.', 'success');
}

function escapeHtml(s) {
  if (s === null || s === undefined) return '';
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function formatClientCell(value) {
  if (value === null || value === undefined) return 'NULL';
  if (typeof value === 'string' && value.trim() === '') return 'NULL';
  return escapeHtml(value);
}

function normalizeNoDiacritics(value) {
  return String(value || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase()
    .trim();
}

function formatFecha(val) {
  if (!val) return '—';

  const s = String(val).trim();
  if (/^\d{4}-\d{2}-\d{2}/.test(s)) {
    const [y, m, d] = s.substring(0, 10).split('-');
    return `${d}/${m}/${y}`;
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

function isWithinSmallDateRange(year, month, day) {
  if (!Number.isInteger(year) || !Number.isInteger(month) || !Number.isInteger(day)) return false;
  if (year < 1900 || year > 2079) return false;
  if (year === 2079) {
    if (month > 6) return false;
    if (month === 6 && day > 6) return false;
  }
  return month >= 1 && month <= 12 && day >= 1 && day <= 31;
}

function toIsoDate(value) {
  if (!value) return '';
  if (value instanceof Date) {
    if (Number.isNaN(value.getTime())) return '';
    const year = value.getFullYear();
    const month = value.getMonth() + 1;
    const day = value.getDate();
    if (!isWithinSmallDateRange(year, month, day)) return '';
    return `${String(year).padStart(4, '0')}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
  }
  const raw = String(value).trim();
  if (!raw) return '';

  const isoMatch = raw.match(/^(\d{4})-(\d{2})-(\d{2})/);
  if (isoMatch) {
    const year = Number(isoMatch[1]);
    const month = Number(isoMatch[2]);
    const day = Number(isoMatch[3]);
    if (!isWithinSmallDateRange(year, month, day)) return '';
    return `${isoMatch[1]}-${isoMatch[2]}-${isoMatch[3]}`;
  }

  const dmyMatch = raw.match(/^(\d{1,2})[\/\-.](\d{1,2})[\/\-.](\d{2,4})$/);
  if (dmyMatch) {
    let [, day, month, year] = dmyMatch;
    year = (year.length === 2) ? `20${year}` : year;
    const isoCandidate = `${year.padStart(4, '0')}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
    const parsed = new Date(isoCandidate);
    if (!Number.isNaN(parsed.getTime()) &&
        parsed.getFullYear() === Number(year) &&
        parsed.getMonth() + 1 === Number(month) &&
        parsed.getDate() === Number(day) &&
        isWithinSmallDateRange(Number(year), Number(month), Number(day))) {
      return isoCandidate;
    }
  }

  const parsed = new Date(raw);
  if (Number.isNaN(parsed.getTime())) return '';
  const year = parsed.getFullYear();
  const month = parsed.getMonth() + 1;
  const day = parsed.getDate();
  if (!isWithinSmallDateRange(year, month, day)) return '';
  return `${String(year).padStart(4, '0')}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}

function calcularEstado(fInicio, fFin, fComprobacion, fEspera) {
  const hoy = todayISO();
  if (fComprobacion && fComprobacion === hoy) return 'comprobada';
  if (fEspera && fEspera === hoy) return 'espera';
  if (fFin && fFin === hoy) return 'realizada';
  if (fInicio && fInicio === hoy) return 'iniciada';
  return 'asignada';
}

function estadoBadge(estado) {
  const map = {
    asignada: '<span class="badge badge-asig"><span class="badge-dot"></span>Asignada</span>',
    iniciada: '<span class="badge badge-inic"><span class="badge-dot"></span>Iniciada</span>',
    realizada: '<span class="badge badge-real"><span class="badge-dot"></span>Realizada</span>',
    comprobada: '<span class="badge badge-comp"><span class="badge-dot"></span>Comprobada</span>',
    espera: '<span class="badge badge-espe"><span class="badge-dot"></span>En espera</span>',
  };
  return map[estado] || map.asignada;
}

function mapDbTask(d) {
  const rawEstado = String(d.Estado || 'Asignada').trim().toLowerCase();
  const estadoNorm = rawEstado === 'en espera' ? 'espera' : rawEstado;
  const idCliente = d.IdCliente ?? d.idCliente ?? null;
  const idPresupuesto = d.IdPresupuesto ?? null;
  const clienteNombreBase = d.Cliente || d.cliente || '';
  const clienteNombreFallback = (!clienteNombreBase && idCliente != null)
    ? getClienteLabelById(idCliente)
    : '';
  const clienteLabel = clienteNombreBase || clienteNombreFallback || (idCliente != null ? `#${idCliente}` : '');
  const presupuestoBase = d.Presupuesto || '';
  const presupuestoFallback = (!presupuestoBase && idPresupuesto != null)
    ? getPresupuestoLabelById(idPresupuesto)
    : '';
  const presupuestoLabel = presupuestoBase || presupuestoFallback || (idPresupuesto != null ? `#${idPresupuesto}` : '');
  // Columnas reales del SP up_bp_Tareas_Select
  return {
    id: d.IdTarea,
    desc: d.Descripcion || '',
    resp1: d.PersonalCreador || '',
    resp2: d.PersonalAsignado || '',
    resp1Id: d.IdPersonalCreador || null,
    resp2Id: d.IdPersonalAsignado || null,
    cliente: clienteLabel,
    idCliente,
    presupuesto: presupuestoLabel,
    idPresupuesto,
    linea: d.PresupuestoLinea || '',
    idPresupuestoLinea: d.IdPresupuestoLinea || null,
    hEst: Number(d.HorasEstimadas || 0),
    hReal: Number(d.HorasReales || 0),
    tipo: d.TipoTarea || '—',
    idTareaTipo: d.IdTareaTipo || null,
    fCreacion: toIsoDate(d.FechaCreacion),
    fEntrega: toIsoDate(d.FechaPreviewEntrega),
    fInicio: toIsoDate(d.FechaInicio),
    fFin: toIsoDate(d.FechaFin),
    fComprobacion: toIsoDate(d.FechaComprobacion),
    fEspera: toIsoDate(d.FechaEnEspera),
    estado: estadoNorm,
    prioridad: d.Prioridad || 2,
    albaraneada: d.Albaraneado === 'Sí' || d.Albaraneado === 'Si' || d.Albaraneado === 1,
    comentario: d.Comentario || '',
    observaciones: d.Observaciones || '',
    carpetaTrabajo: d.CarpetaTrabajo || ''
  };
}

// Normaliza datetimes y devuelve null cuando no existe un valor válido
function normalizeDateForDb(v) {
  return toIsoDate(v) || null;
}

function toDbPayload(t) {
  return {
    idPersonalCrea: t.resp1Id || null,
    idPersonalAsigna: t.resp2Id || null,
    horasEstimadas: Number(t.hEst || 0),
    idTareaTipo: t.idTareaTipo || null,
    fechaCreacion: normalizeDateForDb(t.fCreacion) || todayISO(),
    fechaEntrega: normalizeDateForDb(t.fEntrega),
    fechaInicio: normalizeDateForDb(t.fInicio),
    fechaFin: normalizeDateForDb(t.fFin),
    fechaComprobacion: normalizeDateForDb(t.fComprobacion),
    fechaEspera: normalizeDateForDb(t.fEspera),
    prioridad: Number(t.prioridad || 2),
    comentario: t.comentario || '',
    observaciones: t.observaciones || '',
    carpetaTrabajo: t.carpetaTrabajo || '',
    descripcion: t.desc,
    idCliente: t.idCliente || null,
    idPresupuesto: t.idPresupuesto || null,
    idPresupuestoLinea: t.idPresupuestoLinea || null,
    idSociedad: t.idSociedad || null,
    publicada: true
  };
}

async function invokeApi(channel, data) {
  try {
    return await window.api.invoke(channel, data);
  } catch (err) {
    return { ok: false, error: err.message || 'Error de IPC' };
  }
}

function updateDetailPanel(idx) {
  if (idx < 0 || idx >= taskData.length) return;
  const d = taskData[idx];
  document.getElementById('detail-desc').textContent = d.desc || '';
  document.getElementById('detail-comentario').value = d.comentario || '';
  document.getElementById('detail-observaciones').value = d.observaciones || '';
}

function selectRow(row, idx) {
  document.querySelectorAll('#tasks-tbody tr').forEach(r => r.classList.remove('selected'));
  row.classList.add('selected');
  selectedIdx = idx;
  updateDetailPanel(idx);
}

function appendTaskRow(idx) {
  const d = taskData[idx];
  const tbody = document.getElementById('tasks-tbody');
  const tr = document.createElement('tr');
  tr.onclick = function () { selectRow(this, idx); };
  tr.ondblclick = function () { openTareaWindow('modificar'); };
  const presTxt = d.presupuesto || '';
  const presShort = presTxt.length > 22 ? presTxt.substring(0, 22) + '...' : presTxt;
  tr.innerHTML = `
    <td><span class="row-num">${d.id || (100000 + idx)}</span></td>
    <td>${estadoBadge(d.estado)}</td>
    <td><span class="prio prio-${d.prioridad || 2}">${d.prioridad || 2}</span></td>
    <td>${formatFecha(d.fCreacion)}</td>
    <td>${formatFecha(d.fEntrega)}</td>
    <td>${formatFecha(d.fInicio)}</td>
    <td>${formatFecha(d.fFin)}</td>
    <td>${formatFecha(d.fComprobacion)}</td>
    <td class="mono">${d.hEst} h</td>
    <td class="mono">${d.hReal} h</td>
    <td>${d.tipo || '—'}</td>
    <td>${d.cliente || '—'}</td>
    <td class="mono" style="font-size:11.5px">${presTxt ? presShort : '—'}</td>
    <td><span class="${d.albaraneada ? 'bool-yes' : 'bool-no'}">${d.albaraneada ? '✓' : '✗'}</span></td>
    <td class="desc-cell">${(d.desc || '').substring(0, 50)}${d.desc && d.desc.length > 50 ? '...' : ''}</td>
  `;
  tbody.appendChild(tr);
}

function getClienteLabelById(idCliente) {
  if (idCliente == null) return '';
  const match = clientesData.find(c => String(c.id) === String(idCliente));
  return match?.nombre || match?.num || '';
}

function isPlaceholderIdLabel(text, idVal) {
  const t = String(text || '').trim();
  if (!t) return true;
  const id = idVal != null ? String(idVal) : '';
  return t === '—' || (id && (t === id || t === `#${id}`));
}

function resolveClienteNombreForForm(d) {
  if (!d) return '';
  const raw = String(d.cliente || '').trim();
  if (d.idCliente != null) {
    const fromCache = getClienteLabelById(d.idCliente);
    if (fromCache) return fromCache;
    if (!isPlaceholderIdLabel(raw, d.idCliente)) return raw;
    return '';
  }
  return raw;
}

function clearPresupuestoFields() {
  const presEl = document.getElementById('presupuesto');
  if (presEl) {
    presEl.value = '';
    if (presEl.dataset) presEl.dataset.idPresupuesto = '';
  }
  const lineaEl = document.getElementById('linea-pres');
  if (lineaEl) lineaEl.value = '';
}

function getPresupuestoLabelById(idPresupuesto) {
  if (idPresupuesto == null) return '';
  const match = presupuestosData.find(p => String(p.id) === String(idPresupuesto));
  return match?.num || match?.desc || '';
}

function getPersonalNombreById(idPersonal) {
  const p = personalData.find(x => String(x.id) === String(idPersonal));
  return p ? p.nombre : '';
}

function stripLike(val) {
  const s = String(val || '');
  return s.replace(/%/g, '').trim();
}

function updateTareasStatus() {
  const left = document.getElementById('tareas-status-filter');
  const right = document.getElementById('tareas-status-right');

  const partes = [];
  const f = currentFiltros || {};

  if (f.estado) partes.push(`Estado = ${f.estado}`);

  if (f.idPersonalAsignado != null) {
    const nombre = getPersonalNombreById(f.idPersonalAsignado) || currentUserNombre || '—';
    partes.push(`Asignada a ${nombre}`);
  }

  if (f.idPersonalCreador != null) {
    const nombre = getPersonalNombreById(f.idPersonalCreador) || '—';
    partes.push(`Creada por ${nombre}`);
  }

  if (f.descripcion) partes.push(`Descripción contiene "${stripLike(f.descripcion)}"`);
  if (f.comentario) partes.push(`Comentario contiene "${stripLike(f.comentario)}"`);
  if (f.observaciones) partes.push(`Observaciones contiene "${stripLike(f.observaciones)}"`);
  if (f.descripcionPresupuesto) partes.push(`Desc. presup. contiene "${stripLike(f.descripcionPresupuesto)}"`);

  const texto = partes.length ? partes.join(' · ') : 'Sin filtros';
  if (left) left.innerHTML = `${iconMarkup('search', 'status-filter-icon')}Filtrando: ${texto}`;

  if (right) right.textContent = `Registros: ${taskData.length} · Tiempo: 0 s`;
  actualizarCountsTabs();
}

function actualizarCountsTabs() {
  const tabs = document.querySelectorAll('.estado-tab');
  if (!tabs.length) return;

  // Calculamos conteos del array taskData (que ya está filtrado localmente si corresponde)
  const counts = {
    all: taskData.length,
    asignada: 0,
    iniciada: 0,
    realizada: 0,
    comprobada: 0,
    espera: 0
  };

  taskData.forEach(t => {
    const st = String(t.Estado || t.estado || '').toLowerCase();
    if (counts.hasOwnProperty(st)) {
      counts[st]++;
    }
  });

  tabs.forEach(tab => {
    const span = tab.querySelector('.tab-count');
    if (!span) return;

    if (tab.classList.contains('all')) {
      span.textContent = counts.all;
    } else if (tab.classList.contains('asig')) {
      span.textContent = counts.asignada;
    } else if (tab.classList.contains('inic')) {
      span.textContent = counts.iniciada;
    } else if (tab.classList.contains('real')) {
      span.textContent = counts.realizada;
    } else if (tab.classList.contains('comp')) {
      span.textContent = counts.comprobada;
    } else if (tab.classList.contains('espe')) {
      span.textContent = counts.espera;
    }
  });
}

function applyLocalTaskFilters(items, filtros) {
  if (!filtros || !items || !items.length) return items;
  const f = filtros || {};
  const norm = (v) => String(v || '').toLowerCase();
  const likeVal = (v) => stripLike(v).toLowerCase();

  const inRange = (fecha, desde, hasta) => {
    if (!fecha) return false;
    if (desde && fecha < desde) return false;
    if (hasta && fecha > hasta) return false;
    return true;
  };

  return items.filter(t => {
    if (f.estado) {
      if (norm(t.estado) !== norm(f.estado)) return false;
    }
    if (f.idPersonalAsignado != null && Number(t.resp2Id) !== Number(f.idPersonalAsignado)) return false;
    if (f.idPersonalCreador != null && Number(t.resp1Id) !== Number(f.idPersonalCreador)) return false;

    // Fecha creación
    if (f.fechaCreacionDesde || f.fechaCreacionHasta) {
      if (!inRange(t.fCreacion, f.fechaCreacionDesde, f.fechaCreacionHasta)) return false;
    }

    // F. entrega
    if (f.fechaEntregaDesde || f.fechaEntregaHasta) {
      if (f.fechaEntregaSi === 'no') {
        if (t.fEntrega) return false;
      } else {
        if (!inRange(t.fEntrega, f.fechaEntregaDesde, f.fechaEntregaHasta)) return false;
      }
    }

    // Iniciada
    if (f.iniciadaDesde || f.iniciadaHasta) {
      if (f.iniciadaSi === 'no') {
        if (t.fInicio) return false;
      } else {
        if (!inRange(t.fInicio, f.iniciadaDesde, f.iniciadaHasta)) return false;
      }
    }

    // Finalizada
    if (f.finalizadaSi) {
      const tieneFin = !!t.fFin;
      if (f.finalizadaSi === 'si' && !tieneFin) return false;
      if (f.finalizadaSi === 'no' && tieneFin) return false;
    }

    // Comprobada
    if (f.comprobadaDesde || f.comprobadaHasta) {
      if (f.comprobadaSi === 'no') {
        if (t.fComprobacion) return false;
      } else {
        if (!inRange(t.fComprobacion, f.comprobadaDesde, f.comprobadaHasta)) return false;
      }
    }

    if (f.descripcion) {
      const q = likeVal(f.descripcion);
      if (!norm(t.desc).includes(q)) return false;
    }
    if (f.comentario) {
      const q = likeVal(f.comentario);
      if (!norm(t.comentario).includes(q)) return false;
    }
    if (f.observaciones) {
      const q = likeVal(f.observaciones);
      if (!norm(t.observaciones).includes(q)) return false;
    }
    if (f.descripcionPresupuesto) {
      const q = likeVal(f.descripcionPresupuesto);
      if (!norm(t.presupuesto).includes(q)) return false;
    }
    if (f.cliente) {
      const q = likeVal(f.cliente);
      if (!norm(t.cliente).includes(q)) return false;
    }
    if (f.presupuesto) {
      const q = likeVal(f.presupuesto);
      if (!norm(t.presupuesto).includes(q)) return false;
    }
    if (f.albaraneada === true && !t.albaraneada) return false;
    if (f.tipo && norm(t.tipo) !== norm(f.tipo)) return false;

    return true;
  });
}

async function cargarTareas(filtros = {}) {
  const tbody = document.getElementById('tasks-tbody');
  tbody.innerHTML = '<tr><td colspan="15" style="text-align:center;padding:20px;color:var(--text3)">Cargando...</td></tr>';

  const res = await invokeApi('tareas:getAll', filtros);
  if (!res.ok) {
    tbody.innerHTML = `<tr><td colspan="15" style="text-align:center;padding:20px;color:var(--danger)">Error: ${res.error}</td></tr>`;
    showToast('Error al cargar tareas: ' + res.error, 'warning');
    return;
  }

  taskData = applyLocalTaskFilters(
    (res.data || []).map(mapDbTask),
    filtros
  )
    .sort((a, b) => {
      const pa = Number.isFinite(a.prioridad) ? a.prioridad : 999999;
      const pb = Number.isFinite(b.prioridad) ? b.prioridad : 999999;
      if (pa !== pb) return pa - pb;
      return (b.id || 0) - (a.id || 0);
    });
  tbody.innerHTML = '';

  if (taskData.length === 0) {
    selectedIdx = -1;
    document.getElementById('detail-desc').textContent = '';
    document.getElementById('detail-comentario').value = '';
    document.getElementById('detail-observaciones').value = '';
    tbody.innerHTML = '<tr><td colspan="15" style="text-align:center;padding:20px;color:var(--text3)">Sin tareas.</td></tr>';
    updateTareasStatus();
    return;
  }

  taskData.forEach((_, idx) => appendTaskRow(idx));
  const firstRow = tbody.querySelector('tr');
  if (firstRow) {
    firstRow.classList.add('selected');
    selectedIdx = 0;
    updateDetailPanel(0);
  }
  updateTareasStatus();
}

async function refrescarTareas() {
  await cargarTareas(currentFiltros);
  closeAllMenus();
  showToast('Lista actualizada.', 'success');
}

function estadoFromTab(btn) {
  const byData = btn.dataset.estado;
  if (byData) return byData;
  const txt = (btn.textContent || '').toLowerCase();
  if (txt.includes('asignada')) return 'asignada';
  if (txt.includes('iniciada')) return 'iniciada';
  if (txt.includes('realizada')) return 'realizada';
  if (txt.includes('comprobada')) return 'comprobada';
  if (txt.includes('espera')) return 'espera';
  return '';
}

function filterEstado(btn) {
  btn.closest('.estado-tabs').querySelectorAll('.estado-tab').forEach(t => t.classList.remove('active'));
  btn.classList.add('active');
  const estado = estadoFromTab(btn);
  // Fusionar con los filtros del panel en lugar de reemplazarlos
  const filtrosSinEstado = Object.fromEntries(
    Object.entries(currentFiltros).filter(([k]) => k !== 'estado')
  );
  currentFiltros = estado ? { ...filtrosSinEstado, estado } : filtrosSinEstado;
  cargarTareas(currentFiltros);
}

async function eliminarTarea() {
  if (taskData.length === 0 || selectedIdx < 0) {
    showToast('Selecciona una tarea primero.', 'warning');
    return;
  }
  const t = taskData[selectedIdx];
  const nombre = (t.desc || '').substring(0, 60);
  if (!confirm('¿Eliminar la tarea seleccionada?\n\n' + nombre + '...')) return;

  const res = await invokeApi('tareas:delete', t.id);
  if (!res.ok) {
    showToast('Error al eliminar: ' + res.error, 'warning');
    return;
  }

  await cargarTareas();
  closeAllMenus();
  showToast('Tarea eliminada correctamente.', 'success');
}

async function duplicarTarea() {
  if (taskData.length === 0 || selectedIdx < 0) {
    showToast('Selecciona una tarea primero.', 'warning');
    return;
  }

  const o = taskData[selectedIdx];
  const copy = {
    ...o,
    // Nueva fila: el backend asigna el ID.
    id: undefined
  };

  const payload = toDbPayload(copy);
  // Duplicado debe respetar fechas tal cual (sin aplicar fallback a "hoy").
  payload.fechaCreacion = normalizeDateForDb(copy.fCreacion);
  const res = await invokeApi('tareas:create', payload);
  if (!res.ok) {
    showToast('Error al duplicar: ' + res.error, 'warning');
    return;
  }

  await cargarTareas();
  closeAllMenus();
  showToast('Tarea duplicada correctamente.', 'success');
}

async function moverPrioridad(delta) {
  if (taskData.length === 0 || selectedIdx < 0) {
    showToast('Selecciona una tarea primero.', 'warning');
    return;
  }
  const t = taskData[selectedIdx];
  const actual = Number(t.prioridad || 1);
  const nueva = Math.max(1, actual + delta);
  if (nueva === actual) return;

  const payload = toDbPayload({ ...t, prioridad: nueva });
  const res = await invokeApi('tareas:update', { id: t.id, datos: payload });
  if (!res.ok) {
    showToast('Error al actualizar prioridad: ' + res.error, 'warning');
    return;
  }

  const idActual = t.id;
  await cargarTareas(currentFiltros);
  const idx = taskData.findIndex(x => x.id === idActual);
  if (idx >= 0) {
    const row = document.querySelectorAll('#tasks-tbody tr')[idx];
    if (row) selectRow(row, idx);
  }
  showToast('Prioridad actualizada.', 'success');
}

function subirPrioridad() { moverPrioridad(-1); }
function bajarPrioridad() { moverPrioridad(1); }

const modeConfig = {
  nuevo: { title: 'Nueva tarea', icon: 'plus', iconBg: 'var(--accent-light)', iconColor: 'var(--accent)', readonly: false, showSave: true },
  modificar: { title: 'Modificar tarea', icon: 'edit', iconBg: 'var(--warning-light)', iconColor: 'var(--warning)', readonly: false, showSave: true },
  ver: { title: 'Ver tarea', icon: 'eye', iconBg: 'var(--surface2)', iconColor: 'var(--text2)', readonly: true, showSave: false }
};
let currentModalMode = null;

// DESPUÉS — async, recarga personal desde BD al abrirse
async function openModal(mode) {
  if (mode !== 'nuevo' && (selectedIdx < 0 || taskData.length === 0)) {
    showToast('Selecciona una tarea primero.', 'warning');
    return;
  }

  currentModalMode = mode;
  const cfg = modeConfig[mode];
  document.getElementById('modal-title-text').textContent = cfg.title;
  const iconEl = document.getElementById('modal-icon');
  setIcon(iconEl, cfg.icon);
  iconEl.style.background = cfg.iconBg;
  iconEl.style.color = cfg.iconColor;

  const d = mode === 'nuevo' ? null : taskData[selectedIdx];
  populateForm(d, cfg.readonly);
  if (d && d.idCliente != null) {
    const clienteEl = document.getElementById('cliente');
    if (clienteEl && isPlaceholderIdLabel(clienteEl.value, d.idCliente)) {
      const resCli = await invokeApi('clientes:getById', d.idCliente);
      if (resCli.ok && resCli.data) {
        const nombreCli = resCli.data.NombreComercial || resCli.data.RazonSocial || '';
        if (nombreCli) {
          clienteEl.value = nombreCli;
          if (clienteEl.dataset) clienteEl.dataset.idCliente = d.idCliente;
        }
      }
    }
  }
  if (d && d.idPresupuesto != null) {
    const presEl = document.getElementById('presupuesto');
    const hasText = presEl && presEl.value.trim();
    if (presEl) presEl.dataset.idPresupuesto = d.idPresupuesto;
    if (presEl && !hasText) {
      const match = presupuestosData.find(p => String(p.id) === String(d.idPresupuesto));
      const nombre = match?.num || match?.desc || '';
      if (nombre) {
        presEl.value = nombre;
      } else {
        const resPre = await invokeApi('presupuestos:getById', d.idPresupuesto);
        if (resPre.ok && resPre.data) {
          const nombrePre = resPre.data.NumeroPresupuesto || resPre.data.NumPresupuesto || resPre.data.Numero || resPre.data.Descripcion || '';
          if (nombrePre) presEl.value = nombrePre;
        }
      }
    }
  }
  document.getElementById('btn-guardar').style.display = cfg.showSave ? '' : 'none';
  document.getElementById('modal-backdrop').classList.add('open');

  // Recargar personal desde BD cada vez que se abre el modal
  const cb1 = document.getElementById('activo-resp1');
  const cb2 = document.getElementById('activo-resp2');
  await Promise.all([
    cargarResponsable('resp1', cb1?.checked ?? true),
    cargarResponsable('resp2', cb2?.checked ?? true),
  ]);

  // Si estamos modificando/viendo, restaurar el ID seleccionado
  if (d) {
    document.getElementById('resp1').value = d.resp1Id || '';
    document.getElementById('resp2').value = d.resp2Id || '';
  }

  // Sincronizar estado campos presupuesto según radio seleccionado
  syncPresupuestoFields();

  // Tiempos: solo visible en modificar y ver, no en nuevo
  document.getElementById('seccion-tiempos').style.display = mode === 'nuevo' ? 'none' : '';

  // Cargar registros de tiempo y recalcular HorasReales
  if (d) {
    await cargarTiemposModal(d.id);
  }
}

async function initStandaloneTarea(ctx) {
  document.body.classList.add('standalone-tarea');
  const mode = ctx?.mode || standaloneMode || 'nuevo';
  const rawId = ctx?.idTarea ?? standaloneTareaId;
  const idTarea = rawId !== null && rawId !== undefined && String(rawId).trim() !== ''
    ? Number(rawId)
    : null;

  if (mode !== 'nuevo') {
    if (!Number.isFinite(idTarea) || idTarea <= 0) {
      showToast('No se pudo resolver la tarea.', 'warning');
      return;
    }
    const res = await invokeApi('tareas:getById', idTarea);
    if (!res.ok || !res.data) {
      showToast('No se pudo cargar la tarea: ' + (res.error || 'sin datos'), 'warning');
      return;
    }
    taskData = [mapDbTask(res.data)];
    selectedIdx = 0;
  } else {
    taskData = [];
    selectedIdx = -1;
  }

  await openModal(mode);
}

function formToTask() {
  const fInicio = document.getElementById('f-inicio').value || '';
  const fFin = document.getElementById('f-fin').value || '';
  const fComprobacion = document.getElementById('f-comprobacion').value || '';
  const fEspera = document.getElementById('f-espera').value || '';
  const prioridad = currentModalMode === 'nuevo'
    ? null
    : (taskData[selectedIdx]?.prioridad ?? 1);

  const resp1Id = Number(document.getElementById('resp1').value) || null;
  const resp2Id = Number(document.getElementById('resp2').value) || null;
  // Nombre para visualización en la tabla (no se guarda en BD)
  const resp1Nombre = personalData.find(p => p.id === resp1Id)?.nombre || '';
  const resp2Nombre = personalData.find(p => p.id === resp2Id)?.nombre || '';
  const idSociedad = (personalData.find(p => p.id === resp1Id)?.idSociedad)
    ?? (personalData.find(p => p.id === resp2Id)?.idSociedad)
    ?? null;

  const clienteInput = document.getElementById('cliente');
  const clienteNombre = clienteInput?.value.trim() || '';
  let idCliente = null;
  if (clienteInput?.dataset?.idCliente) {
    const n = Number(clienteInput.dataset.idCliente);
    idCliente = Number.isFinite(n) ? n : null;
  }
  if (!idCliente && clienteNombre) {
    const target = normalizeNoDiacritics(clienteNombre);
    const match = clientesData.find(c => normalizeNoDiacritics(c.nombre) === target);
    if (match && match.id != null) idCliente = match.id;
  }

  const presInput = document.getElementById('presupuesto');
  const presText = presInput?.value.trim() || '';
  let idPresupuesto = null;
  if (presInput?.dataset?.idPresupuesto) {
    const n = Number(presInput.dataset.idPresupuesto);
    idPresupuesto = Number.isFinite(n) ? n : null;
  }
  if (!idPresupuesto && presText) {
    const target = normalizeNoDiacritics(presText);
    const match = presupuestosData.find(p =>
      normalizeNoDiacritics(p.num || '').includes(target) ||
      normalizeNoDiacritics(p.desc || '').includes(target)
    );
    if (match && match.id != null) idPresupuesto = match.id;
  }

  return {
    desc: document.getElementById('descripcion').value.trim(),
    resp1: resp1Nombre,
    resp2: resp2Nombre,
    resp1Id,
    resp2Id,
    cliente: clienteNombre,
    idCliente,           // se resuelve desde clientesData si se necesita
    presupuesto: presText,
    idPresupuesto,
    linea: document.getElementById('linea-pres').value.trim(),
    idPresupuestoLinea: null,
    hEst: Number(document.getElementById('h-estimadas').value || 0),
    hReal: Number(document.getElementById('h-reales').value || 0),
    idTareaTipo: Number(document.getElementById('tipo-tarea').value) || null,
    tipo: document.getElementById('tipo-tarea').options[document.getElementById('tipo-tarea').selectedIndex]?.text || '',
    fCreacion: document.getElementById('f-creacion').value || todayISO(),
    fEntrega: document.getElementById('f-entrega').value || '',
    fInicio,
    fFin,
    fComprobacion,
    fEspera,
    comentario: document.getElementById('comentario').value,
    observaciones: document.getElementById('observaciones').value,
    carpetaTrabajo: document.getElementById('carpeta').value.trim(),
    estado: calcularEstado(fInicio, fFin, fComprobacion, fEspera),
    prioridad,
    albaraneada: false,
    idSociedad
  };
}

async function saveModal() {
  const t = formToTask();

  let res;
  if (currentModalMode === 'nuevo') {
    const payload = toDbPayload(t);
    console.log('[DEBUG] tareas:create payload', payload);
    res = await invokeApi('tareas:create', payload);
  } else if (currentModalMode === 'modificar') {
    const original = taskData[selectedIdx];
    const payload = toDbPayload({ ...original, ...t });
    console.log('[DEBUG] tareas:update payload', { id: original?.id, datos: payload });
    res = await invokeApi('tareas:update', { id: original.id, datos: payload });
  } else {
    closeModal();
    return;
  }

  if (!res.ok) {
    showToast('Error: ' + res.error, 'warning');
    return;
  }

  const refreshId = currentModalMode === 'nuevo'
    ? (res.data?.IdTarea || res.data?.id || res.data?.Id || null)
    : (taskData[selectedIdx]?.id || null);

  if (isStandaloneTarea) {
    window.api.send('tareas:refresh', { idTarea: refreshId });
    closeModal();
    return;
  }

  await cargarTareas(currentFiltros);
  closeModal();
  showToast(currentModalMode === 'nuevo' ? 'Tarea creada correctamente.' : 'Tarea actualizada correctamente.', 'success');
}

function populateForm(d, ro) {
  const clienteNombreForm = resolveClienteNombreForForm(d);
  const fields = {
    'f-creacion': d ? (d.fCreacion || '') : todayISO(),
    'f-entrega': d ? (d.fEntrega || '') : '',
    'f-inicio': d ? (d.fInicio || '') : '',
    'f-fin': d ? (d.fFin || '') : '',
    'f-comprobacion': d ? (d.fComprobacion || '') : '',
    'f-espera': d ? (d.fEspera || '') : '',
    'resp1': d ? (d.resp1Id || '') : '',
    'resp2': d ? (d.resp2Id || '') : '',
    'tipo-tarea': d ? d.tipo : 'Diaria',
    'carpeta': d ? (d.carpetaTrabajo || '') : '',
    'descripcion': d ? d.desc : '',
    'comentario': d ? (d.comentario || '') : '',
    'observaciones': d ? (d.observaciones || '') : '',
    'cliente': d ? clienteNombreForm : '',
    'presupuesto': d ? d.presupuesto : '',
    'linea-pres': d ? d.linea : '',
    'contacto': '',
    'h-estimadas': d ? d.hEst : '0',
    // h-reales se calcula SIEMPRE desde TareasTiempos en cargarTiemposModal().
    // No usamos d.hReal (que puede ser igual a HorasEstimadas según el SP).
    'h-reales': '',   // cargarTiemposModal lo rellenará con SUM(TareasTiempos.Horas)
    'departamento': '',
    'tiempo-comentario': '',
    'tiempo-fecha': todayISO(),
    'tiempo-horas': ''
  };

  Object.entries(fields).forEach(([id, val]) => {
    const el = document.getElementById(id);
    if (!el) return;
    el.value = val;
    if (ro) {
      el.setAttribute('readonly', '');
      el.disabled = el.tagName === 'SELECT';
    } else {
      el.removeAttribute('readonly');
      el.disabled = false;
    }
  });

  const clienteEl = document.getElementById('cliente');
  if (clienteEl) {
    clienteEl.dataset.idCliente = d ? (d.idCliente ?? '') : '';
    const nombreActual = clienteEl.value.trim();
    if (d && isPlaceholderIdLabel(nombreActual, d.idCliente) && d.idCliente != null) {
      const match = clientesData.find(c => Number(c.id) === Number(d.idCliente));
      if (match?.nombre) clienteEl.value = match.nombre;
    }
  }

  const presEl = document.getElementById('presupuesto');
  if (presEl) {
    presEl.dataset.idPresupuesto = d ? (d.idPresupuesto ?? '') : '';
  }

  ['activo-resp1', 'activo-resp2'].forEach(id => {
    const cb = document.getElementById(id);
    if (cb) {
      cb.checked = true;
      cb.disabled = ro;
    }
  });

  // Resetear radio cobro: nuevo → selec-pres; existente → cobrar si tiene presupuesto vacío
  const radioSelec = document.getElementById('selec-pres');
  const radioCobrar = document.getElementById('cobrar');
  if (radioSelec && radioCobrar) {
    radioSelec.checked = true;
    radioCobrar.checked = false;
    radioSelec.disabled = ro;
    radioCobrar.disabled = ro;
  }

  document.querySelectorAll('.input-btn').forEach(b => b.disabled = ro);
  document.querySelectorAll('#modal input[type=radio]').forEach(b => b.disabled = ro);

  // Horas reales: siempre solo lectura (su valor se calcula, nunca se edita a mano)
  const hRealEl = document.getElementById('h-reales');
  if (hRealEl) {
    hRealEl.setAttribute('readonly', '');
    hRealEl.disabled = false;
  }
}

function hideModal() {
  document.getElementById('modal-backdrop').classList.remove('open');
}

function closeModal() {
  hideModal();
  if (isStandaloneTarea) {
    window.api.send('tareas:close');
  }
}

function handleBackdropClick(e) {
  if (e.target === document.getElementById('modal-backdrop')) closeModal();
}

// ── Control campos presupuesto según radio de cobro ──────────
function syncPresupuestoFields() {
  const bloqueado = document.getElementById('cobrar').checked;

  const inputPres = document.getElementById('presupuesto');
  const inputLinea = document.getElementById('linea-pres');
  const btnPres = document.getElementById('btn-presupuesto');

  // Si el usuario decide "Cobrar al cliente", el presupuesto ya no aplica:
  // limpiar el campo para evitar guardar/mostrar un presupuesto incompatible.
  if (bloqueado) {
    clearPresupuestoFields();
  }

  inputPres.disabled = bloqueado;
  inputPres.readOnly = bloqueado;
  inputLinea.disabled = bloqueado;
  inputLinea.readOnly = bloqueado;
  btnPres.disabled = bloqueado;
}

document.getElementById('cobrar').addEventListener('change', syncPresupuestoFields);
document.getElementById('selec-pres').addEventListener('change', syncPresupuestoFields);

document.getElementById('btn-carpeta1').addEventListener('click', async () => {
  const res = await invokeApi('dialog:openCarpeta');
  if (res?.filePath) {
    document.getElementById('carpeta').value = res.filePath;
    showToast('Carpeta seleccionada: ' + res.filePath, 'success');
  }
});

document.getElementById('btn-carpeta2').addEventListener('click', async () => {
  const ruta = document.getElementById('carpeta').value.trim();
  if (!ruta) {
    showToast('Introduce primero una ruta de carpeta.', 'warning');
    return;
  }
  const res = await invokeApi('shell:openPath', ruta);
  if (!res.ok) showToast('No se pudo abrir la carpeta: ' + res.error, 'warning');
});
async function cargarDatosBuscadores() {
  const [rCli, rPre, rCon, rPer] = await Promise.all([
    invokeApi('clientes:getAll', {}),
    invokeApi('presupuestos:getAll', {}),
    invokeApi('contactos:getAll', { nivelMostrar: 0 }),
    invokeApi('personal:getAll', {})   // todos, sin filtro activo
  ]);

  clientesData = (rCli.ok ? rCli.data : []).map(c => ({
    id: c.Id || c.IdCliente || null,
    num: c.Numero || '',
    nombre: c.NombreComercial || '',
    tipo: c.TipoDocumento || c.Tipo || '',
    pais: c.Pais || '',
    provincia: c.Provincia || '',
    tel: c.Telefono || ''
  }));
  clientesFullData = (rCli.ok ? rCli.data : []);

  presupuestosData = (rPre.ok ? rPre.data : []).map(p => ({
    id: p.Id || p.IdPresupuesto || null,
    num: p.Numero || '',
    ver: String(p.Version || 1),
    fecha: formatFecha(p.Fecha),
    cliente: p.Cliente || '',
    desc: p.Descripcion || '',
    importeNum: Number(p.ImporteTotal || 0),
    estado: p.Estado || ''
  }));

  const contactosRaw = (rCon.ok ? rCon.data : []);
  const contactosDetalle = contactosRaw.filter(c => c.Nivel == null || Number(c.Nivel) === 0);
  contactosData = contactosDetalle.map(c => ({
    idContacto: c.IdContacto || null,
    idCliente: c.IdPropietarioAsociado || null,
    idPersonal: c.IdPropietarioRealizador || null,
    fecha: formatFecha(c.Fecha),
    hora: c.Hora || '',
    tipo: c.TipoContacto || '',
    estado: c.PlanificadoRealizadoTexto || ''
  }));

  personalData = (rPer.ok ? rPer.data : []).map(p => ({
    id: p.IdPersonal,
    nombre: p.NombreCompleto || '',
    activo: p.Activo == 1 || p.Activo === true || p.Activo === 'Si' || p.Activo === 'Sí',
    idSociedad: p.IdSociedad ?? null
  }));

  // Poblar selects con solo activos (estado inicial del checkbox = checked)
  poblarSelectPersonal('resp1', true);
  poblarSelectPersonal('resp2', true);

  // Poblar filtros de tareas si existen
  poblarFiltroPersonal('tf-asignada-sel');
  poblarFiltroPersonal('tf-creada-sel');
}

function hl(text, q) {
  if (!q) return text;
  const re = new RegExp('(' + q.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
  return String(text || '').replace(re, '<mark>$1</mark>');
}

document.getElementById('btn-cliente').addEventListener('click', () => {
  clienteReturn = {
    page: currentPage,
    reopenModal: document.getElementById('modal-backdrop')?.classList.contains('open')
  };
  hideModal();
  openClientesWindow();
});
document.getElementById('btn-presupuesto').addEventListener('click', () => {
  presupuestoReturn = {
    reopenModal: document.getElementById('modal-backdrop')?.classList.contains('open')
  };
  const clienteEl = document.getElementById('cliente');
  const clienteNombre = clienteEl?.value.trim() || '';
  if (!clienteNombre) {
    showToast('Selecciona un cliente primero.', 'warning');
    return;
  }
  let idCliente = null;
  if (clienteEl?.dataset?.idCliente) {
    const n = Number(clienteEl.dataset.idCliente);
    idCliente = Number.isFinite(n) ? n : null;
  }
  if (!idCliente && clienteNombre) {
    const target = normalizeNoDiacritics(clienteNombre);
    const match = clientesData.find(c => normalizeNoDiacritics(c.nombre) === target);
    if (match && match.id != null) idCliente = match.id;
  }
  hideModal();
  window.api.send('presupuestos:open', { cliente: clienteNombre, idCliente });
});
document.getElementById('btn-contacto').addEventListener('click', () => {
  contactosReturn = {
    reopenModal: document.getElementById('modal-backdrop')?.classList.contains('open')
  };
  const clienteEl = document.getElementById('cliente');
  const clienteNombre = clienteEl?.value.trim() || '';
  let idCliente = null;
  if (clienteEl?.dataset?.idCliente) {
    const n = Number(clienteEl.dataset.idCliente);
    idCliente = Number.isFinite(n) ? n : null;
  }
  if (!idCliente && clienteNombre) {
    const target = normalizeNoDiacritics(clienteNombre);
    const match = clientesData.find(c => normalizeNoDiacritics(c.nombre) === target);
    if (match && match.id != null) idCliente = match.id;
  }

  if (idCliente == null) {
    showToast('Selecciona un cliente primero.', 'warning');
    contactosReturn = null;
    return;
  }

  hideModal();

  if (standalonePage === 'contactos') {
    contactosContextIdCliente = idCliente;
    contactosContextCliente = clienteNombre;
    applyContactosContextToUi();
    ensureContactosClienteNombre();
    switchPage('contactos');
    buscarContactosConFiltros();
    return;
  }

  openContactosWindow({ cliente: clienteNombre, idCliente });
});

window.api.on('presupuestos:selected', (payload) => {
  if (!payload) return;
  const input = document.getElementById('presupuesto');
  if (input) {
    const display = payload.numero ? String(payload.numero) : (payload.descripcion || '');
    input.value = display;
    if (input.dataset) input.dataset.idPresupuesto = payload.id || '';
  }

  const clienteEl = document.getElementById('cliente');
  if (clienteEl && !clienteEl.value.trim() && payload.cliente) {
    clienteEl.value = payload.cliente;
  }

  if (presupuestoReturn && presupuestoReturn.reopenModal) {
    document.getElementById('modal-backdrop').classList.add('open');
  }
  presupuestoReturn = null;
  showToast('Presupuesto asignado.', 'success');
});

window.api.on('clientes:selected', (payload) => {
  if (!payload) return;
  const input = document.getElementById('cliente');
  const prevId = input?.dataset?.idCliente || '';
  if (input) {
    input.value = payload.nombre || '';
    if (input.dataset) input.dataset.idCliente = payload.id || '';
  }
  if (String(prevId || '') !== String(payload.id || '')) {
    clearPresupuestoFields();
  }

  if (clienteReturn && clienteReturn.reopenModal) {
    document.getElementById('modal-backdrop').classList.add('open');
  }
  clienteReturn = null;
  showToast('Cliente asignado.', 'success');
});

window.api.on('clientes:closed', () => {
  if (clienteReturn && clienteReturn.reopenModal) {
    document.getElementById('modal-backdrop').classList.add('open');
  }
  clienteReturn = null;
});

window.api.on('presupuestos:closed', () => {
  if (presupuestoReturn && presupuestoReturn.reopenModal) {
    document.getElementById('modal-backdrop').classList.add('open');
  }
  presupuestoReturn = null;
});

window.api.on('contactos:closed', () => {
  if (contactosReturn && contactosReturn.reopenModal) {
    document.getElementById('modal-backdrop').classList.add('open');
  }
  contactosReturn = null;
});

window.api.on('contactos:setContext', async (ctx) => {
  if (!ctx) return;
  contactosContextIdCliente = (ctx.idCliente != null) ? ctx.idCliente : null;
  contactosContextCliente = ctx.cliente || '';

  applyContactosContextToUi();
  await ensureContactosClienteNombre();

  buscarContactosConFiltros();
});

window.api.on('tareas:setContext', async (ctx) => {
  if (!isStandaloneTarea) return;
  await initStandaloneTarea(ctx);
});

window.api.on('tareas:refresh', async (payload) => {
  if (isStandaloneWindow) return;
  await cargarTareas(currentFiltros);
  const id = payload?.idTarea;
  if (id != null) {
    const idx = taskData.findIndex(x => String(x.id) === String(id));
    if (idx >= 0) {
      const row = document.querySelectorAll('#tasks-tbody tr')[idx];
      if (row) selectRow(row, idx);
    }
  }
});

(function () {
  const input = document.getElementById('cliente');
  const dropdown = document.getElementById('cliente-dropdown');
  let activeIdx = -1;

  function showDropdown(q) {
    const matches = clientesData.filter(c =>
      c.nombre.toLowerCase().includes(q.toLowerCase()) ||
      c.num.includes(q)
    );
    if (!matches.length || !q) {
      hideDropdown();
      return;
    }

    dropdown.innerHTML = matches.map((c, i) =>
      `<li data-value="${c.nombre}" data-id="${c.id ?? ''}" data-idx="${i}">${hl(c.nombre, q)}</li>`
    ).join('');

    activeIdx = -1;
    dropdown.classList.add('open');
  }

  function hideDropdown() {
    dropdown.classList.remove('open');
    dropdown.innerHTML = '';
    activeIdx = -1;
  }

  input.addEventListener('input', () => {
    if (input.dataset) input.dataset.idCliente = '';
    const presEl = document.getElementById('presupuesto');
    const lineaEl = document.getElementById('linea-pres');
    const hasPres = (presEl && (presEl.value.trim() || presEl.dataset?.idPresupuesto)) || false;
    const hasLinea = (lineaEl && lineaEl.value.trim()) || false;
    if (hasPres || hasLinea) {
      clearPresupuestoFields();
    }
    showDropdown(input.value.trim());
  });

  input.addEventListener('keydown', e => {
    const items = dropdown.querySelectorAll('li');
    if (!items.length) return;

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      activeIdx = Math.min(activeIdx + 1, items.length - 1);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      activeIdx = Math.max(activeIdx - 1, 0);
    } else if (e.key === 'Enter' && activeIdx >= 0) {
      e.preventDefault();
      const prevId = input.dataset?.idCliente || '';
      input.value = items[activeIdx].dataset.value;
      if (input.dataset) input.dataset.idCliente = items[activeIdx].dataset.id || '';
      if (String(prevId || '') !== String(items[activeIdx].dataset.id || '')) {
        clearPresupuestoFields();
      }
      hideDropdown();
      return;
    } else if (e.key === 'Escape') {
      hideDropdown();
      return;
    }

    items.forEach((li, i) => li.classList.toggle('ac-active', i === activeIdx));
    if (activeIdx >= 0) items[activeIdx].scrollIntoView({ block: 'nearest' });
  });

  dropdown.addEventListener('mousedown', e => {
    const li = e.target.closest('li');
    if (li) {
      const prevId = input.dataset?.idCliente || '';
      input.value = li.dataset.value;
      if (input.dataset) input.dataset.idCliente = li.dataset.id || '';
      if (String(prevId || '') !== String(li.dataset.id || '')) {
        clearPresupuestoFields();
      }
      hideDropdown();
    }
  });

  document.addEventListener('click', e => {
    if (!input.contains(e.target) && !dropdown.contains(e.target)) hideDropdown();
  });
})();

document.getElementById('detail-comentario').addEventListener('input', function () {
  if (!taskData[selectedIdx]) return;

  taskData[selectedIdx].comentario = this.value;
  clearTimeout(this._saveTimer);
  this._saveTimer = setTimeout(async () => {
    const t = taskData[selectedIdx];
    if (!t || !t.id) return;
    await invokeApi('tareas:update', { id: t.id, datos: toDbPayload(t) });
  }, 800);
});

document.getElementById('detail-observaciones').addEventListener('input', function () {
  if (!taskData[selectedIdx]) return;

  taskData[selectedIdx].observaciones = this.value;
  clearTimeout(this._saveTimer);
  this._saveTimer = setTimeout(async () => {
    const t = taskData[selectedIdx];
    if (!t || !t.id) return;
    await invokeApi('tareas:update', { id: t.id, datos: toDbPayload(t) });
  }, 800);
});

function showToast(msg, type = 'info') {
  const toast = document.getElementById('toast');
  toast.textContent = msg;
  toast.className = 'toast toast-' + type + ' show';
  clearTimeout(toast._t);
  toast._t = setTimeout(() => toast.classList.remove('show'), 3000);
}

/* ═══════════════════════════════════════════════════════════
   GESTIÓN DE TIEMPOS
   ═══════════════════════════════════════════════════════════ */

/**
 * Carga los registros de tiempo de una tarea, los pinta en #tiempos-tbody
 * y recalcula h-reales = Σ horas registradas.
 */
async function cargarTiemposModal(idTarea) {
  const tbody = document.getElementById('tiempos-tbody');
  const hRealEl = document.getElementById('h-reales');
  const hEstEl = document.getElementById('h-estimadas');

  if (tbody) {
    tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;color:var(--text3);padding:8px">Cargando...</td></tr>';
  }

  const res = await invokeApi('tareas:getTiempos', idTarea);

  if (!res.ok) {
    if (tbody) tbody.innerHTML = `<tr><td colspan="4" style="color:var(--danger);padding:8px">${res.error}</td></tr>`;
    return [];
  }

  const tiempos = res.data || [];

  // Guardar la suma registrada como dato auxiliar y mostrarla como HorasReales.
  // HorasReales ahora refleja únicamente la suma de los registros (Σ horas).
  const sumHoras = tiempos.reduce((s, t) => s + Number(t.Horas || 0), 0);
  if (hRealEl) {
    hRealEl.dataset.sumRegistrada = sumHoras;
    hRealEl.value = sumHoras.toFixed(2);
  }

  // Pintar tabla
  if (tbody) {
    if (tiempos.length === 0) {
      tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;color:var(--text3);padding:8px">Sin registros.</td></tr>';
    } else {
      tbody.innerHTML = tiempos.map(t => `
        <tr>
          <td>${formatFecha(t.Fecha)}</td>
          <td class="mono" style="text-align:right">${Number(t.Horas || 0).toFixed(2)} h</td>
          <td>${t.Comentario || '—'}</td>
          <td style="color:var(--text3);font-size:11px;text-align:center">${t.IdIdentidad || ''}</td>
        </tr>
      `).join('');
    }
  }

  return tiempos;
}

/**
 * Guarda un registro de tiempo desde el formulario del modal.
 * Valida máximo 24 h/día (también validado en el controlador).
 */
async function asignarTiempo() {
  const fechaEl = document.getElementById('tiempo-fecha');
  const horasEl = document.getElementById('tiempo-horas');
  const comentEl = document.getElementById('tiempo-comentario');
  const btnEl = document.getElementById('btn-asignar-tiempo');

  const fecha = fechaEl ? fechaEl.value : '';
  const horas = parseFloat(horasEl ? horasEl.value : '');
  const comentario = comentEl ? comentEl.value.trim() : '';

  if (!fecha) {
    showToast('Selecciona una fecha para el registro.', 'warning');
    return;
  }
  if (isNaN(horas) || horas <= 0) {
    showToast('Introduce un número de horas válido (> 0).', 'warning');
    if (horasEl) horasEl.focus();
    return;
  }
  if (horas > 24) {
    showToast('No se pueden registrar más de 24 horas en un día.', 'warning');
    if (horasEl) horasEl.focus();
    return;
  }

  const tareaActual = taskData[selectedIdx];
  if (!tareaActual || !tareaActual.id) {
    showToast('No hay tarea seleccionada.', 'warning');
    return;
  }

  if (btnEl) { btnEl.disabled = true; btnEl.textContent = 'Guardando…'; }

  const res = await invokeApi('tareas:registrarTiempo', {
    idTarea: tareaActual.id,
    fecha,
    horas,
    comentario,
    idIdentidad: currentUserId
  });

  if (btnEl) { btnEl.disabled = false; btnEl.textContent = 'Registrar'; }

  if (!res.ok) {
    showToast(res.error, 'warning');
    return;
  }

  // Limpiar campos
  if (horasEl) horasEl.value = '';
  if (comentEl) comentEl.value = '';
  if (fechaEl) fechaEl.value = todayISO();

  // Recargar tiempos y recalcular h-reales en el modal (SUM desde TareasTiempos)
  await cargarTiemposModal(tareaActual.id);

  // El backend devuelve { resultado, tarea } donde tarea.HorasReales es el recálculo en BD.
  // Fallback: leer el campo del modal (rellenado por cargarTiemposModal justo antes).
  // El controller devuelve { horasReales } = SUM(TareasTiempos.horas)
  const nuevoHReal = (res.data && res.data.horasReales != null)
    ? Number(res.data.horasReales)
    : Number(document.getElementById('h-reales')?.value || 0);

  taskData[selectedIdx].hReal = nuevoHReal;

  // Refrescar celda HorasReales en la fila de la tabla sin recargar toda la lista
  const filas = document.querySelectorAll('#tasks-tbody tr');
  if (filas[selectedIdx]) {
    const celdas = filas[selectedIdx].querySelectorAll('td');
    if (celdas[9]) celdas[9].textContent = nuevoHReal.toFixed(2) + ' h';
  }

  showToast('Tiempo registrado correctamente.', 'success');
}

document.addEventListener('DOMContentLoaded', async () => {


  // Obtener ID del usuario autenticado para usarlo al registrar tiempos
  const session = await invokeApi('auth:getSession');
  if (session.ok && session.data) {
    currentUserId = session.data.id;
    currentUserPersonalId = session.data.idPersonal || null;
    currentUserNombre = session.data.nombre || '';
    if (currentUserPersonalId == null && currentUserNombre) {
      showToast('No se pudo resolver el usuario de la sesión.', 'warning');
    }
  }



  // Horas reales se calculan a partir de los registros; no deben mezclarse
  // automáticamente con HorasEstimadas en el campo de edición.

  // Listeners checkboxes activo en selects de responsable
  ['resp1', 'resp2'].forEach(id => {
    const cb = document.getElementById('activo-' + id);
    if (cb) cb.addEventListener('change', () => cargarResponsable(id, cb.checked));
  });

  await cargarDatosBuscadores();
  setAsignadaFiltroSesion();
  setContactosPersonalSesion();
  applyContactosContextToUi();
  await ensureContactosClienteNombre();

  // Inicializar fechas del panel de filtros con hoy
  const hoy = todayISO();
  const dateFields = [
    'tf-fecha-crea-desde', 'tf-fecha-crea-hasta',
    'tf-fecha-ent-desde', 'tf-fecha-ent-hasta',
    'tf-iniciada-desde', 'tf-iniciada-hasta',
    'tf-comprobada-desde', 'tf-comprobada-hasta',
    'tf-contiempos-desde', 'tf-contiempos-hasta',
  ];
  dateFields.forEach(id => {
    const el = document.getElementById(id);
    if (el && !el.value) el.value = hoy;
  });

  const cfDesde = document.getElementById('cf-fec-desde');
  const cfHasta = document.getElementById('cf-fec-hasta');
  if (cfDesde && !cfDesde.value) cfDesde.value = hoy;
  if (cfHasta && !cfHasta.value) cfHasta.value = hoy;

  if (!standalonePage || standalonePage === 'tareas') {
    await cargarTareas();
  }

  const btnBuscar = document.getElementById('btn-tareas-buscar');
  if (btnBuscar) btnBuscar.addEventListener('click', buscarTareasConFiltros);

  const btnContactos = document.getElementById('btn-contactos-buscar');
  if (btnContactos) btnContactos.addEventListener('click', buscarContactosConFiltros);

  if (standalonePage === 'tarea') {
    await initStandaloneTarea();

    return;
  }

  if (standalonePage && standalonePage !== 'tareas' && standalonePage !== 'tarea') {
    switchPage(standalonePage);
  }

  if (standalonePage === 'contactos') {
    await cargarContactos(buildContactosFiltros());
  }

  // Modal comentario de fichaje
  const comentarioBackdrop = document.getElementById('fichaje-comentario-backdrop');
  const comentarioClose = document.getElementById('fichaje-comentario-close');
  const comentarioCancel = document.getElementById('fichaje-comentario-cancel');
  const comentarioSave = document.getElementById('fichaje-comentario-save');
  const comentarioText = document.getElementById('fichaje-comentario-text');

  if (comentarioBackdrop) {
    comentarioBackdrop.addEventListener('click', (e) => {
      if (e.target === comentarioBackdrop) fichaje_cerrarComentarioModal(null);
    });
  }
  comentarioClose?.addEventListener('click', () => fichaje_cerrarComentarioModal(null));
  comentarioCancel?.addEventListener('click', () => fichaje_cerrarComentarioModal(null));
  comentarioSave?.addEventListener('click', () => {
    const val = String(comentarioText?.value || '').trim();
    if (!val) {
      showToast('El comentario está vacío.', 'warning');
      return;
    }
    fichaje_cerrarComentarioModal(val);
  });
  comentarioText?.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) {
      comentarioSave?.click();
    }
  });

  // ── Fichaje: cargar estado inicial ──────────────────────────
  if (!standalonePage || standalonePage === 'tareas') {
    await fichaje_cargarEstado();
  }



  if (window.api && window.api.on) {
    window.api.on('fichaje:refresh', () => {
      fichaje_cargarEstado();
    });
  }
});

/* ══════════════════════════════════════════════════════════════
   CONTROL DE PRESENCIA (FICHAJE)
   ══════════════════════════════════════════════════════════════ */

// Estado en memoria (1=Entrada, 2=Salida, 3=InicioPausa, 4=FinPausa)
let _fichajeEstadoActual = null;
let _fichajeUltimoRegistro = null;
let _fichajeComentarioResolver = null;

/**
 * Aplica el estado visual al botón de fichaje.
 * estado: objeto { estado (int), estadoStr (string) }
 */
function fichaje_aplicarEstado(estadoObj) {
  const btn = document.getElementById('btn-fichaje');
  const iconEl = document.getElementById('fichaje-icon');
  const labelEl = document.getElementById('fichaje-label');
  if (!btn || !iconEl || !labelEl) return;

  _fichajeEstadoActual = estadoObj?.estado ?? null;
  _fichajeUltimoRegistro = estadoObj?.ultimoRegistro ?? null;

  btn.classList.remove('estado-trabajando', 'estado-pausa', 'estado-desconectado');

  // El último evento registrado define el estado visual
  const ult = estadoObj?.estado;
  if (ult === 1 || ult === 4) {
    // Última acción = Entrada o FinPausa → está TRABAJANDO
    btn.classList.add('estado-trabajando');
    setIcon(iconEl, 'status-working');
    labelEl.textContent = 'Trabajando — Fichar salida';
  } else if (ult === 3) {
    // Última acción = InicioPausa → está en PAUSA
    btn.classList.add('estado-pausa');
    setIcon(iconEl, 'status-pause');
    labelEl.textContent = 'En pausa — Reanudar';
  } else {
    // Última acción = Salida o sin registro → DESCONECTADO
    btn.classList.add('estado-desconectado');
    setIcon(iconEl, 'status-offline');
    labelEl.textContent = 'Fichar entrada';
  }
}

/**
 * Pide el estado actual al backend y actualiza el botón.
 */
async function fichaje_cargarEstado() {
  try {
    const res = await invokeApi('presencia:getEstadoActual');
    if (res.ok) {
      fichaje_aplicarEstado(res.data);
    } else {
      fichaje_aplicarEstado(null);
    }
  } catch (e) {
    console.warn('[Fichaje] Error cargando estado:', e);
    fichaje_aplicarEstado(null);
  }
}

/**
 * Determina cuál es el siguiente evento lógico según el estado actual
 * y lo registra en la base de datos.
 */
async function onFichajeClick() {
  const ult = _fichajeEstadoActual;
  let siguienteEvento;
  let ops = [];

  if (ult === 1 || ult === 4) {
    // Está trabajando → puede hacer Pausa (3) o Salida (2)
    ops = [
      { label: 'Iniciar pausa', action: 'evento', val: 3 },
      { label: 'Fichar salida', action: 'evento', val: 2 },
      { label: 'Añadir comentario', action: 'comentario' },
    ];
  } else if (ult === 3) {
    // Está en pausa → siguiente lógico es Fin Pausa (4)
    ops = [
      { label: 'Reanudar', action: 'evento', val: 4 },
      { label: 'Añadir comentario', action: 'comentario' },
    ];
  } else {
    // Desconectado / sin registro → siguiente es Entrada (1)
    ops = [
      { label: 'Fichar entrada', action: 'evento', val: 1 },
      { label: 'Añadir comentario', action: 'comentario' },
    ];
  }

  const opcion = await fichaje_mostrarMenuAccion(ops);
  if (!opcion) return; // cancelado
  if (opcion.action === 'comentario') {
    await fichaje_anadirComentarioActual();
    return;
  }
  siguienteEvento = opcion.val;

  try {
    const res = await invokeApi('presencia:registrarFichaje', {
      idControlPresenciaTipoEvento: siguienteEvento,
      comentarios: ''
    });
    if (res.ok) {
      // Forzar recarga del estado para que el botón se actualice
      await fichaje_cargarEstado();
      const etiquetas = { 1: 'Entrada registrada', 2: 'Salida registrada', 3: 'Pausa iniciada', 4: 'Pausa finalizada' };
      showToast(etiquetas[siguienteEvento] || 'Fichaje registrado.', 'success');
    } else {
      showToast('Error al registrar fichaje: ' + (res.error || 'Error desconocido'), 'warning');
    }
  } catch (e) {
    showToast('Error al comunicar con el servidor.', 'warning');
  }
}

/**
 * Añade comentario al fichaje actual (último registro).
 */
function fichaje_abrirComentarioModal(textoInicial = '') {
  return new Promise((resolve) => {
    if (_fichajeComentarioResolver) {
      _fichajeComentarioResolver(null);
    }
    _fichajeComentarioResolver = resolve;

    const backdrop = document.getElementById('fichaje-comentario-backdrop');
    const textarea = document.getElementById('fichaje-comentario-text');
    if (textarea) textarea.value = textoInicial;
    if (backdrop) backdrop.classList.add('open');

    setTimeout(() => {
      textarea?.focus();
      textarea?.select();
    }, 0);
  });
}

function fichaje_cerrarComentarioModal(result = null) {
  const backdrop = document.getElementById('fichaje-comentario-backdrop');
  if (backdrop) backdrop.classList.remove('open');

  const resolver = _fichajeComentarioResolver;
  _fichajeComentarioResolver = null;
  if (resolver) resolver(result);
}

async function fichaje_anadirComentarioActual() {
  const idFichaje = _fichajeUltimoRegistro?.IdControlPresenciaFichaje
    ?? _fichajeUltimoRegistro?.Id
    ?? _fichajeUltimoRegistro?.id
    ?? null;

  if (!idFichaje) {
    showToast('No hay un fichaje activo para comentar.', 'warning');
    return;
  }

  const comentarioActual = _fichajeUltimoRegistro?.Comentarios
    ?? _fichajeUltimoRegistro?.Comentario
    ?? '';

  const comentario = await fichaje_abrirComentarioModal(comentarioActual || '');
  if (comentario == null) return;

  const res = await invokeApi('presencia:updateComentario', {
    idControlPresenciaFichaje: idFichaje,
    comentarios: comentario
  });

  if (res.ok) {
    if (_fichajeUltimoRegistro) _fichajeUltimoRegistro.Comentarios = comentario;
    showToast('Comentario guardado.', 'success');
  } else {
    showToast('Error al guardar comentario: ' + (res.error || 'Error desconocido'), 'warning');
  }
}

/**
 * Muestra un pequeño menú flotante junto al botón.
 * Devuelve una Promise con la opción elegida o null si cancela.
 */
function fichaje_mostrarMenuAccion(ops = []) {
  return new Promise((resolve) => {
    // Si ya existe un menú previo, quitarlo
    document.getElementById('fichaje-ctx-menu')?.remove();

    const btn = document.getElementById('btn-fichaje');
    const rect = btn.getBoundingClientRect();

    const menu = document.createElement('div');
    menu.id = 'fichaje-ctx-menu';
    menu.style.cssText = `
      position:fixed;
      top:${rect.bottom + 4}px;
      left:${rect.left}px;
      background:var(--surface,#fff);
      border:1.5px solid var(--border,#e2e8f0);
      border-radius:8px;
      box-shadow:0 4px 20px rgba(0,0,0,.12);
      z-index:9999;
      min-width:160px;
      overflow:hidden;
      font-size:13px;
    `;

    const finalOps = Array.isArray(ops) ? ops : [];
    if (!finalOps.length) {
      menu.remove();
      resolve(null);
      return;
    }

    function getDotStyle(op) {
      // Usa tonos "light" (como en el informe de horarios) con un borde más marcado.
      if (op?.action === 'evento') {
        if (op.val === 1 || op.val === 4) return { bg: 'var(--success-light)', border: 'var(--success)' };
        if (op.val === 3) return { bg: 'var(--warning-light)', border: 'var(--warning)' }; // pausa = amarillo
        if (op.val === 2) return { bg: 'var(--danger-light)', border: 'var(--danger)' };  // salida = rojo claro
        return { bg: 'var(--surface2)', border: 'var(--border2)' };
      }
      // Acción secundaria (comentario)
      return { bg: 'var(--surface2)', border: 'var(--border2)' };
    }

    finalOps.forEach(op => {
      const item = document.createElement('button');
      item.style.cssText = `display:flex;align-items:center;gap:10px;width:100%;padding:9px 16px;border:none;background:none;cursor:pointer;text-align:left;font-size:13px;color:var(--text,#111);`;

      const dot = document.createElement('span');
      const dotStyle = getDotStyle(op);
      dot.style.cssText = `width:10px;height:10px;border-radius:999px;flex-shrink:0;background:${dotStyle.bg};border:1px solid ${dotStyle.border};box-sizing:border-box;`;

      const label = document.createElement('span');
      label.textContent = op.label;

      item.appendChild(dot);
      item.appendChild(label);
      item.onmouseover = () => item.style.background = 'var(--accent-light,#eff6ff)';
      item.onmouseout = () => item.style.background = 'none';
      item.onclick = () => { menu.remove(); resolve(op); };
      menu.appendChild(item);
    });

    document.body.appendChild(menu);

    // Cerrar si se hace clic fuera
    setTimeout(() => {
      document.addEventListener('click', function handler(e) {
        if (!menu.contains(e.target)) {
          menu.remove();
          document.removeEventListener('click', handler);
          resolve(null);
        }
      });
    }, 50);
  });
}


