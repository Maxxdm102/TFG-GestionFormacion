/* ═══════════════════════════════════════════════════════════════
   RESPONSABLES — Bloque a integrar en app.js
   
   Pega estas funciones en tu app.js y llama a
   initResponsables() desde tu DOMContentLoaded (o donde
   inicialices el resto de la app).
   ═══════════════════════════════════════════════════════════════ */

/**
 * Rellena un <select> de responsable consultando la BD.
 * @param {string}  selectId    - id del <select> a rellenar
 * @param {boolean} soloActivos - true → pasa @Activo=1 al SP; false → todos
 */
async function cargarResponsable(selectId, soloActivos) {
  const sel = document.getElementById(selectId);
  if (!sel) return;

  const valorActual = sel.value; // Preservar selección previa si sigue disponible

  // Indicador visual mientras carga
  sel.disabled = true;
  sel.innerHTML = '<option value="">Cargando...</option>';

  try {
    const filtros = soloActivos ? { activo: true } : {};
    const res = await window.api.invoke('personal:getAll', filtros);

    if (!res.ok) throw new Error(res.error);

    sel.innerHTML = '<option value="">— Seleccionar responsable —</option>';

    res.data.forEach(p => {
      const nombre = (p.NombreCompleto || '').trim();
      if (!nombre) return;
      const opt = document.createElement('option');
      opt.value = p.IdPersonal;   // ID numérico como valor
      opt.textContent = nombre;
      sel.appendChild(opt);
    });

    // Restaurar selección anterior (comparar por ID)
    if (valorActual && [...sel.options].some(o => o.value === String(valorActual))) {
      sel.value = valorActual;
    }
  } catch (err) {
    console.warn(`[Responsables] Error cargando ${selectId}:`, err.message);
    sel.innerHTML = '<option value="">Error al cargar personal</option>';
  } finally {
    sel.disabled = false;
  }
}

/**
 * Inicializa los desplegables de responsables y sus checkboxes "Activo".
 * Llamar una vez al arrancar (DOMContentLoaded).
 */
function initResponsables() {
  const cb1 = document.getElementById('activo-resp1');
  const cb2 = document.getElementById('activo-resp2');

  // Carga inicial al abrir el modal — se hace en openModal()
  // Aquí solo vinculamos los cambios de checkbox
  cb1?.addEventListener('change', () => cargarResponsable('resp1', cb1.checked));
  cb2?.addEventListener('change', () => cargarResponsable('resp2', cb2.checked));
}

/* ─── Modifica tu función openModal para que llame a cargar ─── */
// Dentro de openModal(), antes de mostrar el modal, añade:
//
//   await cargarResponsable('resp1', document.getElementById('activo-resp1').checked);
//   await cargarResponsable('resp2', document.getElementById('activo-resp2').checked);
//
// Ejemplo de openModal() completo con la integración:

async function openModal(mode) {
  currentModalMode = mode;

  const backdrop = document.getElementById('modal-backdrop');
  const title = document.getElementById('modal-title-text');
  const icon = document.getElementById('modal-icon');
  const guardar = document.getElementById('btn-guardar');

  const config = {
    nuevo: { title: 'Nueva tarea', icon: '✨', readonly: false },
    modificar: { title: 'Modificar tarea', icon: '✏️', readonly: false },
    ver: { title: 'Ver tarea', icon: '👁', readonly: true },
  };

  const cfg = config[mode] || config.nuevo;
  title.textContent = cfg.title;
  icon.textContent = cfg.icon;
  guardar.style.display = cfg.readonly ? 'none' : '';

  if (mode === 'nuevo') resetModalForm();

  // Mostrar modal
  backdrop.style.display = 'flex';
  backdrop.classList.add('open');

  // Cargar personal según estado actual de los checkboxes
  const cb1 = document.getElementById('activo-resp1');
  const cb2 = document.getElementById('activo-resp2');
  await Promise.all([
    cargarResponsable('resp1', cb1.checked),
    cargarResponsable('resp2', cb2.checked),
  ]);

  closeAllMenus();
}