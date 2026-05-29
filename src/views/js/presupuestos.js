/* ==================================================
   PRESUPUESTOS.JS - Selector de presupuestos
   ================================================== */

let presupuestosFullData = [];
let selectedPresupuestoIdx = -1;
let currentFiltros = {};
let contextCliente = '';
let contextIdCliente = null;

async function invokeApi(channel, data) {
  try {
    return await window.api.invoke(channel, data);
  } catch (err) {
    return { ok: false, error: err.message || 'Error de IPC' };
  }
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

function formatLineaCell(val) {
  if (val === null || val === undefined) return '-';
  const s = String(val);
  const t = s.trim();
  if (t === '' || t === '—' || t === 'â€”') return '-';
  return escapeHtml(s);
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

function formatImporte(val) {
  const n = Number(val);
  if (!Number.isFinite(n)) return '—';
  return n.toLocaleString('es-ES', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

function showToast(msg, type = 'info') {
  const toast = document.getElementById('toast');
  if (!toast) return;
  toast.textContent = msg;
  toast.className = 'toast toast-' + type + ' show';
  clearTimeout(toast._t);
  toast._t = setTimeout(() => toast.classList.remove('show'), 3000);
}

function getVal(id) {
  return document.getElementById(id)?.value.trim() || '';
}

function getSelectedValues(id) {
  const sel = document.getElementById(id);
  if (!sel) return [];
  return Array.from(sel.selectedOptions)
    .map(o => (o.value !== undefined && o.value !== null && o.value !== '' ? o.value : (o.textContent || '')).trim())
    .filter(Boolean);
}

function buildPresupuestosFiltros() {
  const filtros = {};
  const cliente = contextCliente || getVal('pf-cliente-txt');
  if (cliente) filtros.cliente = cliente;
  if (contextIdCliente != null) filtros.idCliente = contextIdCliente;

  const numero = getVal('pf-numero-txt');
  if (numero) filtros.numero = numero;

  const estados = getSelectedValues('pf-estado-sel');
  const estadosFiltrados = estados.filter(e => e !== '__ALL__');
  if (estadosFiltrados.length === 1) {
    filtros.estado = estadosFiltrados[0];
  }

  const alb = (document.getElementById('pf-alb-sel')?.value || '').toLowerCase();
  if (alb === 'sí' || alb === 'si') filtros.albaraneado = true;
  if (alb === 'no') filtros.albaraneado = false;

  return filtros;
}

function readUiFiltros() {
  let alb = (document.getElementById('pf-alb-sel')?.value || '');
  if (alb && alb.toLowerCase() === 'parcial') alb = '';
  return {
    cliente: contextCliente || getVal('pf-cliente-txt'),
    numero: getVal('pf-numero-txt'),
    fecha: getVal('pf-fecha-txt'),
    descripcion: getVal('pf-desc-txt'),
    version: getVal('pf-vers-txt'),
    tipo: getVal('pf-tipo-txt'),
    estados: getSelectedValues('pf-estado-sel').filter(e => e !== '__ALL__'),
    albaraneado: alb
  };
}

function applyLocalFilters(items, filtros) {
  if (!filtros || !items) return items || [];
  const f = filtros;
  const norm = (v) => String(v || '').toLowerCase();

  return items.filter(p => {
    if (f.cliente && !norm(p.Cliente).includes(norm(f.cliente))) return false;
    if (f.numero && !norm(p.Numero).includes(norm(f.numero))) return false;
    if (f.descripcion && !norm(p.Descripcion).includes(norm(f.descripcion))) return false;
    if (f.version && !norm(p.Version).includes(norm(f.version))) return false;
    if (f.tipo && p.Tipo != null && p.Tipo !== '' && !norm(p.Tipo).includes(norm(f.tipo))) return false;
    if (f.fecha) {
      const fechaText = `${formatFecha(p.Fecha)} ${String(p.Fecha || '')}`;
      if (!norm(fechaText).includes(norm(f.fecha))) return false;
    }
    if (f.estados && f.estados.length) {
      const ok = f.estados.some(est => norm(p.Estado) === norm(est));
      if (!ok) return false;
    }
    if (f.albaraneado) {
      const al = norm(f.albaraneado);
      const val = p.Albaraneado ? 'sí' : 'no';
      if (!norm(val).includes(al)) return false;
    }
    return true;
  });
}

async function cargarPresupuestos(filtros = {}) {
  const tbody = document.getElementById('presupuestos-tbody');
  if (!tbody) return;
  tbody.innerHTML = `<tr><td colspan="15" style="text-align:center;padding:24px;color:var(--text3)">Cargando...</td></tr>`;

  const res = await invokeApi('presupuestos:getAll', filtros);
  if (!res.ok) {
    tbody.innerHTML = `<tr><td colspan="15" style="text-align:center;padding:24px;color:var(--danger)">Error: ${escapeHtml(res.error)}</td></tr>`;
    resetLineas();
    updateStatus(readUiFiltros(), 0);
    showToast(res.error, 'warning');
    return;
  }
  const lista = res.data || [];

  const uiFiltros = readUiFiltros();
  const finalList = applyLocalFilters(lista, uiFiltros);

  presupuestosFullData = finalList;
  selectedPresupuestoIdx = -1;

  if (!finalList || finalList.length === 0) {
    tbody.innerHTML = `<tr><td colspan="15" style="text-align:center;padding:40px;color:var(--text3);font-size:13px">Sin resultados. Use los filtros para buscar presupuestos.</td></tr>`;
    resetLineas();
    updateStatus(uiFiltros, 0);
    return;
  }

  const rows = finalList.map(p => {
    const numSinTareas = p.NumLineasSinTareas ?? p.LineasSinTareas ?? p.NumLinSinTareas ?? 0;
    const tarNoReal = p.NumTareasNoRealizadas ?? p.TareasNoRealizadas ?? p.NumTarNoRealizadas ?? 0;
    const tarReal = p.NumTareasRealizadas ?? p.TareasRealizadas ?? p.NumTarRealizadas ?? 0;
    return `
      <tr>
        <td style="color:var(--text3);text-align:center">•</td>
        <td>${escapeHtml(p.Numero)}</td>
        <td>${escapeHtml(p.Version)}</td>
        <td>${escapeHtml(formatFecha(p.Fecha))}</td>
        <td>${escapeHtml(p.Cliente)}</td>
        <td>${escapeHtml(p.Descripcion)}</td>
        <td>${escapeHtml(formatFecha(p.FechaEntrega))}</td>
        <td class="mono" style="text-align:right">${escapeHtml(formatImporte(p.ImporteTotal))}</td>
        <td>${escapeHtml(p.Estado)}</td>
        <td>${escapeHtml(formatFecha(p.FechaEstado))}</td>
        <td>${escapeHtml(p.EstadoProduccion)}</td>
        <td>${escapeHtml(formatFecha(p.FechaEstadoProduccion))}</td>
        <td class="mono" style="text-align:right">${escapeHtml(numSinTareas)}</td>
        <td class="mono" style="text-align:right">${escapeHtml(tarNoReal)}</td>
        <td class="mono" style="text-align:right">${escapeHtml(tarReal)}</td>
      </tr>
    `;
  }).join('');

  tbody.innerHTML = rows;
  tbody.querySelectorAll('tr').forEach((row, idx) => {
    row.addEventListener('click', () => selectPresupuestoRow(row, idx));
    row.addEventListener('dblclick', asignarPresupuestoSeleccionado);
  });

  updateStatus(uiFiltros, finalList.length);
}

function selectPresupuestoRow(row, idx) {
  document.querySelectorAll('#presupuestos-tbody tr').forEach(r => r.classList.remove('selected'));
  row.classList.add('selected');
  selectedPresupuestoIdx = idx;

  const sel = presupuestosFullData[idx];
  if (sel && (sel.Id || sel.id)) {
    cargarLineasPresupuesto(sel.Id || sel.id);
  } else {
    resetLineas();
  }
}

function resetLineas() {
  const tbody = document.getElementById('presupuestos-lineas-tbody');
  if (!tbody) return;
  tbody.innerHTML = `
    <tr>
      <td colspan="14" style="text-align:center;padding:20px;color:var(--text3);font-size:12.5px">
        Seleccione un presupuesto para ver sus líneas.
      </td>
    </tr>
  `;
}

async function cargarLineasPresupuesto(id) {
  const tbody = document.getElementById('presupuestos-lineas-tbody');
  if (!tbody) return;
  tbody.innerHTML = `<tr><td colspan="14" style="text-align:center;padding:20px;color:var(--text3)">Cargando...</td></tr>`;

  const res = await invokeApi('presupuestos:getLineas', id);
  if (!res.ok) {
    tbody.innerHTML = `<tr><td colspan="14" style="text-align:center;padding:20px;color:var(--danger)">Error: ${escapeHtml(res.error)}</td></tr>`;
    return;
  }

  const lineas = res.data || [];
  if (lineas.length === 0) {
    tbody.innerHTML = `<tr><td colspan="14" style="text-align:center;padding:20px;color:var(--text3);font-size:12.5px">Sin líneas para este presupuesto.</td></tr>`;
    return;
  }

  tbody.innerHTML = lineas.map(l => `
    <tr>
      <td class="mono" style="text-align:right">${formatLineaCell(l.NumeroOrden)}</td>
      <td>${formatLineaCell(l.CodigoArticulo)}</td>
      <td>${formatLineaCell(l.Descripcion)}</td>
      <td class="mono" style="text-align:right">${formatLineaCell(l.Cantidad)}</td>
      <td>${formatLineaCell(l.UnidadMedida)}</td>
      <td class="mono" style="text-align:right">${formatLineaCell(formatImporte(l.Precio))}</td>
      <td class="mono" style="text-align:right">${formatLineaCell(l.Descuento)}</td>
      <td class="mono" style="text-align:right">${formatLineaCell(formatImporte(l.Importe))}</td>
      <td style="text-align:center">${l.RequiereTarea ? 'Sí' : 'No'}</td>
      <td style="text-align:center">${l.RequierePedido ? 'Sí' : 'No'}</td>
      <td>${formatLineaCell(l.CarpetaTrabajo)}</td>
      <td>${formatLineaCell(l.Proveedor)}</td>
      <td>${formatLineaCell(l.Albaranes)}</td>
      <td class="mono" style="text-align:right">${formatLineaCell(l.NumTareas ?? l.NumeroTareas)}</td>
    </tr>
  `).join('');
}

function asignarPresupuestoSeleccionado() {
  const sel = (selectedPresupuestoIdx >= 0 && presupuestosFullData[selectedPresupuestoIdx])
    ? presupuestosFullData[selectedPresupuestoIdx]
    : null;
  if (!sel) {
    showToast('Selecciona un presupuesto primero.', 'warning');
    return;
  }

  window.api.send('presupuestos:select', {
    id: sel.Id || sel.id || null,
    numero: sel.Numero || '',
    version: sel.Version || '',
    cliente: sel.Cliente || '',
    descripcion: sel.Descripcion || ''
  });
}

function updateStatus(filtros, count) {
  const left = document.getElementById('presupuestos-status-filter');
  const right = document.getElementById('presupuestos-status-right');

  const partes = [];
  if (filtros.cliente) partes.push(`Cliente contiene "${filtros.cliente}"`);
  if (filtros.numero) partes.push(`Número contiene "${filtros.numero}"`);
  if (filtros.descripcion) partes.push(`Descripción contiene "${filtros.descripcion}"`);
  if (filtros.fecha) partes.push(`Fecha contiene "${filtros.fecha}"`);
  if (filtros.estados && filtros.estados.length) partes.push(`Estado = ${filtros.estados.join(', ')}`);
  if (filtros.albaraneado) partes.push(`Albaraneado = ${filtros.albaraneado}`);

  const texto = partes.length ? partes.join(' · ') : 'Sin filtros';
  if (left) left.innerHTML = `<span class="status-filter-icon">🔍</span>Filtrando: ${escapeHtml(texto)}`;
  if (right) right.textContent = `Registros: ${count} · Tiempo: 0 s`;
}

async function buscarPresupuestosConFiltros() {
  if (!contextCliente && contextIdCliente == null) {
    showToast('Selecciona un cliente antes de buscar presupuestos.', 'warning');
    return;
  }
  currentFiltros = buildPresupuestosFiltros();
  await cargarPresupuestos(currentFiltros);
  showToast('Búsqueda aplicada.', 'success');
}

function showNecesitaCliente() {
  const tbody = document.getElementById('presupuestos-tbody');
  if (tbody) {
    tbody.innerHTML = `<tr><td colspan="15" style="text-align:center;padding:40px;color:var(--text3);font-size:13px">Selecciona un cliente para ver presupuestos.</td></tr>`;
  }
  resetLineas();
  updateStatus({ cliente: '', numero: '', descripcion: '', fecha: '', estados: [], albaraneado: '' }, 0);
}

document.addEventListener('DOMContentLoaded', async () => {
  const btnBuscar = document.getElementById('btn-presupuestos-buscar');
  if (btnBuscar) btnBuscar.addEventListener('click', buscarPresupuestosConFiltros);

  const btnAsignar = document.getElementById('btn-presupuestos-asignar');
  if (btnAsignar) btnAsignar.addEventListener('click', asignarPresupuestoSeleccionado);

  if (!contextCliente && contextIdCliente == null) {
    showNecesitaCliente();
  } else {
    await cargarPresupuestos(buildPresupuestosFiltros());
  }
});


window.api.on('presupuestos:setContext', (ctx) => {
  if (!ctx) return;
  contextCliente = ctx.cliente || '';
  contextIdCliente = (ctx.idCliente != null) ? ctx.idCliente : null;
  if (contextCliente) {
    const input = document.getElementById('pf-cliente-txt');
    if (input) {
      input.value = contextCliente;
      input.readOnly = true;
    }
    const btn = document.getElementById('pf-cliente-btn');
    if (btn) btn.disabled = true;
  }
  buscarPresupuestosConFiltros();
});
