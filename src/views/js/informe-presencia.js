const state = {
  registros: [],
  session: null,
};

let _timerId = null;
let _timerStart = null;

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

function formatHora(d) {
  if (!d) return '-';
  const h = String(d.getHours()).padStart(2, '0');
  const m = String(d.getMinutes()).padStart(2, '0');
  return `${h}:${m}`;
}

function formatFecha(d) {
  if (!d) return '-';
  const day = String(d.getDate()).padStart(2, '0');
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const year = d.getFullYear();
  return `${day}/${month}/${year}`;
}

function formatFechaHora(d) {
  if (!d) return '-';
  return `${formatFecha(d)} ${formatHora(d)}`;
}

function formatTiempo(totalMin) {
  const mins = Math.max(0, Math.round(totalMin || 0));
  const h = Math.floor(mins / 60);
  const m = mins % 60;
  return `${h} h ${String(m).padStart(2, '0')} min`;
}

function eventoClass(label) {
  const raw = String(label || '').toLowerCase();
  if (raw.includes('entrada')) return 'evt-entrada';
  if (raw.includes('fin')) return 'evt-fin';
  if (raw.includes('pausa')) return 'evt-pausa';
  if (raw.includes('salida')) return 'evt-salida';
  return 'evt-otro';
}

function eventoHtml(label) {
  const cls = eventoClass(label);
  return `<span class="evento-dot ${cls}"></span><span>${label || '-'}</span>`;
}

function clearTimer() {
  if (_timerId) {
    clearInterval(_timerId);
    _timerId = null;
  }
  _timerStart = null;
}

function startTimer(startDate) {
  clearTimer();
  _timerStart = startDate;
  const tick = () => {
    const el = document.getElementById('informe-timer');
    if (!el || !_timerStart) return;
    const mins = (Date.now() - _timerStart.getTime()) / 60000;
    el.textContent = formatTiempo(mins);
  };
  tick();
  _timerId = setInterval(tick, 1000);
}

function toDateKey(d) {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

function buildTramos(rows, desde, hasta) {
  const tramos = [];
  let workingStart = null;
  let workingLabel = null;

  const ordered = rows
    .map(r => ({ row: r, dt: parseFechaHora(r) }))
    .filter(x => x.dt)
    .sort((a, b) => a.dt.getTime() - b.dt.getTime());

  ordered.forEach(({ row, dt }) => {
    const tipo = Number(
      row?.IdControlPresenciaTipoEvento ??
      row?.IdTipoEvento ??
      row?.TipoEventoId ??
      row?.IdTipo ??
      row?.IdControlPresenciaTipo
    );

    if (tipo === 1 || tipo === 4) {
      workingStart = dt;
      workingLabel = tipo === 4 ? 'Fin pausa' : 'Entrada';
    } else if (tipo === 2 || tipo === 3) {
      if (workingStart) {
        const salidaLabel = tipo === 3 ? 'Pausa' : 'Salida';
        tramos.push({
          entrada: workingStart,
          entradaLabel: workingLabel || 'Entrada',
          salida: dt,
          salidaLabel,
          totalMin: (dt.getTime() - workingStart.getTime()) / 60000
        });
        workingStart = null;
        workingLabel = null;
      }
    }
  });

  const hoy = todayISO();
  if (workingStart) {
    const inProgress = toDateKey(workingStart) === hoy;
    tramos.push({
      entrada: workingStart,
      entradaLabel: workingLabel || 'Entrada',
      salida: null,
      salidaLabel: inProgress ? '-' : '-',
      totalMin: inProgress ? (Date.now() - workingStart.getTime()) / 60000 : 0,
      inProgress: inProgress
    });
  }

  const desdeKey = desde || null;
  const hastaKey = hasta || null;
  const filtered = tramos.filter(t => {
    if (!t.entrada) return false;
    const key = toDateKey(t.entrada);
    if (desdeKey && key < desdeKey) return false;
    if (hastaKey && key > hastaKey) return false;
    return true;
  }).map(t => ({
    ...t,
    dayKey: t.entrada ? toDateKey(t.entrada) : ''
  }));

  return filtered;
}

function renderTramos(tramos) {
  const tbody = document.getElementById('informe-tbody');
  if (!tbody) return;

  if (!tramos.length) {
    tbody.innerHTML = '<tr><td colspan="3" style="text-align:center;padding:20px;color:var(--text3)">Sin registros.</td></tr>';
    clearTimer();
    return;
  }

  let inProgressStart = null;
  let html = '';
  let currentDay = null;
  let dayTotal = 0;

  const flushResumen = () => {
    if (!currentDay) return;
    html += `
      <tr class="resumen-row">
        <td colspan="2" class="resumen-label">Resumen ${currentDay}</td>
        <td><span class="mono">${formatTiempo(dayTotal)}</span></td>
      </tr>
    `;
  };

  tramos.forEach((t) => {
    if (t.dayKey !== currentDay) {
      flushResumen();
      currentDay = t.dayKey;
      dayTotal = 0;
    }

    const entradaTxt = t.entrada
      ? `<div class="evento-line"><span class="mono">${formatFechaHora(t.entrada)}</span>${eventoHtml(t.entradaLabel)}</div>`
      : '-';
    const salidaTxt = t.salida
      ? `<div class="evento-line"><span class="mono">${formatFechaHora(t.salida)}</span>${eventoHtml(t.salidaLabel)}</div>`
      : `<span class="mono">-</span>`;

    const tiempoTxt = t.inProgress
      ? `<span class="mono" id="informe-timer">${formatTiempo(t.totalMin)}</span>`
      : `<span class="mono">${formatTiempo(t.totalMin)}</span>`;

    if (t.inProgress && t.entrada) inProgressStart = t.entrada;
    dayTotal += t.totalMin || 0;

    html += `
      <tr>
        <td class="informe-cell">${entradaTxt}</td>
        <td class="informe-cell">${salidaTxt}</td>
        <td>${tiempoTxt}</td>
      </tr>
    `;
  });

  flushResumen();
  tbody.innerHTML = html;

  if (inProgressStart) {
    startTimer(inProgressStart);
  } else {
    clearTimer();
  }
}

function updateStatus(totalRegistros, desde, hasta) {
  const totalEl = document.getElementById('informe-total');
  if (totalEl) totalEl.textContent = `${totalRegistros} registros`;

  const status = document.getElementById('informe-status');
  if (!status) return;
  const left = status.querySelector('.status-filter');
  const rango = (desde || hasta)
    ? `${desde || '-'} a ${hasta || '-'}`
    : 'Todas';
  if (left) left.innerHTML = `<span class="status-filter-icon">F</span>Filtrando: ${rango}`;

  const right = status.querySelector('.statusbar-right');
  if (right) right.textContent = `Registros: ${totalRegistros} - Tiempo: 0 s`;
}

async function cargarInforme() {
  const tbody = document.getElementById('informe-tbody');
  if (tbody) {
    tbody.innerHTML = '<tr><td colspan="3" style="text-align:center;padding:20px;color:var(--text3)">Cargando...</td></tr>';
  }

  const desde = document.getElementById('fecha-desde')?.value || '';
  const hasta = document.getElementById('fecha-hasta')?.value || '';
  const fechaDesde = desde || null;
  const fechaHasta = hasta || null;
  const singleDate = fechaDesde && fechaHasta && fechaDesde === fechaHasta;
  let registros = [];
  if (singleDate) {
    const fechaBase = new Date(`${fechaDesde}T00:00:00`);
    const next = new Date(fechaBase.getTime() + 24 * 60 * 60 * 1000);
    const nextKey = toDateKey(next);

    const res1 = await invokeApi('presencia:getFichajesPersonales', { fechaFiltro: fechaDesde });
    const res2 = await invokeApi('presencia:getFichajesPersonales', { fechaFiltro: nextKey });
    if (!res1.ok || !res2.ok) {
      const errMsg = res1.error || res2.error || 'Error desconocido';
      if (tbody) tbody.innerHTML = `<tr><td colspan="3" style="text-align:center;padding:20px;color:var(--danger)">Error: ${errMsg}</td></tr>`;
      showToast('Error al cargar informe: ' + errMsg, 'warning');
      return;
    }
    const map = new Map();
    const addRows = (rows) => {
      (rows || []).forEach(r => {
        const id = r.IdControlPresenciaFichaje ?? r.Id ?? r.id ?? null;
        const key = id != null ? String(id) : JSON.stringify(r);
        if (!map.has(key)) map.set(key, r);
      });
    };
    addRows(res1.data);
    addRows(res2.data);
    registros = Array.from(map.values());
  } else {
    const res = await invokeApi('presencia:getFichajesPersonales', {});
    if (!res.ok) {
      if (tbody) tbody.innerHTML = `<tr><td colspan="3" style="text-align:center;padding:20px;color:var(--danger)">Error: ${res.error || 'Error'}</td></tr>`;
      showToast('Error al cargar informe: ' + (res.error || 'Error desconocido'), 'warning');
      return;
    }
    registros = res.data || [];
  }

  state.registros = registros;
  const tramos = buildTramos(state.registros, fechaDesde, fechaHasta);
  renderTramos(tramos);
  updateStatus(tramos.length, fechaDesde, fechaHasta);
}

async function init() {
  const session = await invokeApi('auth:getSession');
  if (session.ok && session.data) {
    state.session = session.data;
    const label = document.getElementById('informe-user');
    if (label) label.textContent = session.data.nombre || 'Usuario';
  }

  const desdeEl = document.getElementById('fecha-desde');
  const hastaEl = document.getElementById('fecha-hasta');
  const hoy = todayISO();
  if (desdeEl && !desdeEl.value) desdeEl.value = hoy;
  if (hastaEl && !hastaEl.value) hastaEl.value = hoy;

  await cargarInforme();
}

document.getElementById('btn-buscar').addEventListener('click', cargarInforme);
document.getElementById('btn-refrescar').addEventListener('click', cargarInforme);
document.getElementById('btn-pdf').addEventListener('click', async () => {
  const fechaDesde = document.getElementById('fecha-desde')?.value || todayISO();
  const fechaHasta = document.getElementById('fecha-hasta')?.value || fechaDesde;
  await cargarInforme();
  showToast('Generando PDF...', 'info');

  // Serializar tramos (los Date no se transfieren por IPC directamente)
  const tramosSerializados = buildTramos(state.registros, fechaDesde, fechaHasta).map(t => ({
    dayKey: t.dayKey || '',
    entrada: t.entrada ? t.entrada.toISOString() : null,
    entradaLabel: t.entradaLabel || '',
    salida: t.salida ? t.salida.toISOString() : null,
    salidaLabel: t.salidaLabel || '',
    totalMin: t.totalMin || 0,
    inProgress: !!t.inProgress,
  }));

  const userName = document.getElementById('informe-user')?.textContent || '-';

  const res = await invokeApi('presencia:exportInformePdf', {
    fechaDesde,
    fechaHasta,
    tramos: tramosSerializados,
    userName,
  });
  if (res.ok) {
    showToast(`PDF generado en Descargas: ${res.fileName}`, 'success');
  } else {
    showToast('Error al generar PDF: ' + (res.error || 'Error desconocido'), 'warning');
  }
});

document.getElementById('btn-csv').addEventListener('click', () => {
  const fechaDesde = document.getElementById('fecha-desde')?.value || todayISO();
  const fechaHasta = document.getElementById('fecha-hasta')?.value || fechaDesde;
  const tramos = buildTramos(state.registros, fechaDesde, fechaHasta);
  
  if (!tramos.length) {
    showToast('No hay datos para exportar', 'warning');
    return;
  }

  let csvContent = 'Entrada,Entrada Tipo,Salida,Salida Tipo,Tiempo Minutos\n';
  tramos.forEach(t => {
    const ent = t.entrada ? formatFechaHora(t.entrada) : '';
    const entLbl = t.entradaLabel || '';
    const sal = t.salida ? formatFechaHora(t.salida) : '';
    const salLbl = t.salidaLabel || '';
    const mins = Math.round(t.totalMin || 0);
    csvContent += `"${ent}","${entLbl}","${sal}","${salLbl}",${mins}\n`;
  });

  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.setAttribute('href', url);
  link.setAttribute('download', `informe_presencia_${fechaDesde}_${fechaHasta}.csv`);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
});

if (window.api && window.api.on) {
  window.api.on('presenciaInforme:refresh', () => {
    cargarInforme();
  });
}

init();
