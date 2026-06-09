/* ═══════════════════════════════════════════════
   CONTROLLERS/TAREACONTROLLER.JS
   ═══════════════════════════════════════════════ */

const TareaModel = require('../models/TareaModel');

function localISODate(date = new Date()) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

class TareaController {

  async _validarHorasDia(idTarea, fecha, horas, excludeIdTareaTiempo = null) {
    const tiemposExistentes = await TareaModel.getTiempos(idTarea);
    const horasDia = tiemposExistentes
      .filter(t => {
        const f = t.Fecha ? String(t.Fecha).substring(0, 10) : '';
        if (excludeIdTareaTiempo != null && Number(t.IdTareaTiempo) === Number(excludeIdTareaTiempo)) return false;
        return f === fecha;
      })
      .reduce((sum, t) => sum + Number(t.Horas || t.horas || 0), 0);

    if (horasDia + Number(horas) > 24) {
      const restante = (24 - horasDia).toFixed(2);
      return { ok: false, error: 'Límite diario superado. Solo puedes registrar ' + restante + ' h más para el ' + fecha + '.' };
    }
    return { ok: true };
  }

  _calcularEstado(tarea) {
    const hoy = localISODate();
    const isoComp = tarea.fechaComprobacion ? String(tarea.fechaComprobacion).substring(0, 10) : '';
    const isoFin = tarea.fechaFin ? String(tarea.fechaFin).substring(0, 10) : '';
    const isoEspera = tarea.fechaEspera ? String(tarea.fechaEspera).substring(0, 10) : '';
    const isoInicio = tarea.fechaInicio ? String(tarea.fechaInicio).substring(0, 10) : '';

    if (isoComp && isoComp <= hoy) return 'comprobada';
    if (isoFin && isoFin <= hoy) return 'realizada';
    if (isoEspera && isoEspera <= hoy) return 'espera';
    if (isoInicio && isoInicio <= hoy) return 'iniciada';
    return 'asignada';
  }

  _validar(tarea) {
    const errores = [];
    if (!tarea.descripcion || tarea.descripcion.trim() === '')
      errores.push('La descripción es obligatoria');
    if (!tarea.idPersonalAsigna)
      errores.push('El responsable asignado es obligatorio');
    return errores;
  }

  async getAll(filtros = {}) {
    try {
      console.log('[DEBUG] tareas:getAll filtros', filtros);
      const tareas = await TareaModel.getAll(filtros);
      // Forzar HorasReales desde TareasTiempos (el SP puede devolver valores incorrectos)
      if (Array.isArray(tareas) && tareas.length > 0) {
        const ids = tareas.map(t => t.IdTarea || t.idTarea || t.id).filter(Boolean);
        const horasMap = await TareaModel.getHorasRealesByTareas(ids);
        tareas.forEach(t => {
          const id = t.IdTarea || t.idTarea || t.id;
          if (id != null) t.HorasReales = horasMap[id] != null ? horasMap[id] : 0;
        });
      }
      console.log('[DEBUG] tareas:getAll count', Array.isArray(tareas) ? tareas.length : 0);
      return { ok: true, data: tareas };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async getById(id) {
    try {
      const tarea = await TareaModel.getById(id);
      if (!tarea) return { ok: false, error: 'Tarea no encontrada' };
      return { ok: true, data: tarea };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async create(datos) {
    try {
      const errores = this._validar(datos);
      if (errores.length > 0) return { ok: false, error: errores.join(', ') };
      if (!datos.estado) datos.estado = this._calcularEstado(datos);
      if (!datos.fechaCreacion) datos.fechaCreacion = localISODate();
      // Prioridad automática: MAX(prioridad)+1 para evitar duplicados por empleado
      // Solo si la tarea NO está finalizada ni comprobada (y la fecha <= hoy)
      const hoy = localISODate();
      const isoComp = datos.fechaComprobacion ? String(datos.fechaComprobacion).substring(0, 10) : '';
      const isoFin = datos.fechaFin ? String(datos.fechaFin).substring(0, 10) : '';
      const estaTerminada = (isoComp && isoComp <= hoy) || (isoFin && isoFin <= hoy);
      
      if (datos.idPersonalAsigna && !estaTerminada) {
        const next = await TareaModel.getNextPrioridadForAsignado(
          datos.idPersonalAsigna,
          datos.idSociedad || null
        );
        console.log('[DEBUG] calcular prioridad siguiente para', datos.idPersonalAsigna, '=>', next);
        if (next != null) datos.prioridad = next;
      } else {
        // Si está finalizada o comprobada, NO debe tener prioridad bajo ninguna circunstancia
        datos.prioridad = null;
      }
      const id = await TareaModel.create(datos);

      // Asegurar unicidad de prioridades: reordenar o recalcular
      if (datos && datos.idPersonalAsigna) {
        if (datos.prioridad != null) {
          try {
            await TareaModel.reordenarPrioridades({
              idTarea: id,
              idPersonalAsigna: datos.idPersonalAsigna,
              prioridadNueva: datos.prioridad,
              idSociedad: datos.idSociedad || null
            });
          } catch (e) {
            console.warn('[WARN] reordenarPrioridades falló tras create:', e.message);
          }
        }
        // Forzar recálculo completo para evitar huecos o NULLs (especialmente si falló lo anterior)
        await TareaModel.recalcularPrioridadesParaAsignado(datos.idPersonalAsigna);
      }

      // El SP up_bp_Tareas_Select tiene INNER JOINs obligatorios con gf_Clientes y TareasTipos.
      // Si la tarea se creó sin IdCliente o IdTareaTipo, el SP devuelve null.
      // En ese caso obtenemos los datos mínimos directamente de la tabla.
      let tarea = await TareaModel.getById(id);
      if (!tarea) {
        const pool = require('../database/db').getPool ? await require('../database/db').getPool() : null;
        if (pool) {
          const r = await pool.request()
            .input('id', require('../database/db').sql.Int, id)
            .query(`
              SELECT IdTarea, Descripcion, Comentario, Observaciones,
                     idPersonal_Crea AS IdPersonalCreador,
                     idPersonal_Asigna AS IdPersonalAsignado,
                     Fecha AS FechaCreacion, FIniciada AS FechaInicio,
                     FRealizada AS FechaFin, FComprobada AS FechaComprobacion,
                     FechaEnESpera AS FechaEnEspera, FechaPrevistaEntrega,
                     HorasEstimadas, CAST(0 AS float) AS HorasReales,
                     idCliente AS IdCliente, idPresupuesto AS IdPresupuesto,
                     idPresupuestoLinea AS IdPresupuestoLinea,
                     idTareaTipo AS IdTareaTipo, Prioridad,
                     CarpetaTrabajo, IdSociedad,
                     CASE WHEN FComprobada IS NOT NULL THEN 'Comprobada'
                          WHEN FRealizada  IS NOT NULL THEN 'Realizada'
                          WHEN FIniciada   IS NOT NULL THEN 'Iniciada'
                          ELSE 'Asignada'
                     END AS Estado,
                     CAST('' AS varchar(200)) AS PersonalCreador,
                     CAST('' AS varchar(200)) AS PersonalAsignado,
                     CAST('' AS varchar(200)) AS Cliente,
                     CAST('' AS varchar(200)) AS TipoTarea,
                     'No' AS Albaraneado
              FROM dbo.Tareas WHERE IdTarea = @id
            `);
          tarea = r.recordset[0] || null;
        }
      }

      console.log('[DEBUG] tareas:create id', id, 'tarea', tarea ? { IdTarea: tarea.IdTarea, Estado: tarea.Estado } : null);
      try {
        const prioridadStored = tarea ? (tarea.Prioridad ?? tarea.Prioridad) : null;
        console.log('[DEBUG] prioridad en BD tras create:', prioridadStored);
      } catch (e) {
        console.warn('[WARN] no pude leer prioridad tras create:', e.message);
      }
      return { ok: true, data: tarea };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async update(id, datos) {
    try {
      const errores = this._validar(datos);
      if (errores.length > 0) return { ok: false, error: errores.join(', ') };

      // Obtener la tarea actual para ver si cambia el responsable
      const tareaPrevia = await TareaModel.getById(id);
      const idPersonalAsignaPrevio = tareaPrevia ? (tareaPrevia.IdPersonalAsignado ?? tareaPrevia.idPersonalAsigna) : null;

      datos.estado = this._calcularEstado(datos);

      // Si la tarea se marca como finalizada o comprobada (y la fecha <= hoy), quitamos la prioridad
      const hoy = localISODate();
      const isoComp = datos.fechaComprobacion ? String(datos.fechaComprobacion).substring(0, 10) : '';
      const isoFin = datos.fechaFin ? String(datos.fechaFin).substring(0, 10) : '';
      if ((isoFin && isoFin <= hoy) || (isoComp && isoComp <= hoy)) {
        datos.prioridad = null;
      }

      if (datos && datos.idPersonalAsigna && datos.prioridad != null) {
        await TareaModel.reordenarPrioridades({
          idTarea: id,
          idPersonalAsigna: datos.idPersonalAsigna,
          prioridadNueva: datos.prioridad,
          idSociedad: datos.idSociedad || null
        });
      }
      await TareaModel.update(id, datos);

      // Asegurar unicidad de prioridades: recalcular siempre para el responsable actual
      if (datos.idPersonalAsigna) {
        await TareaModel.recalcularPrioridadesParaAsignado(datos.idPersonalAsigna);
      }
      
      // Si el responsable cambió, recalcular también para el responsable anterior
      if (idPersonalAsignaPrevio != null && idPersonalAsignaPrevio !== datos.idPersonalAsigna) {
        await TareaModel.recalcularPrioridadesParaAsignado(idPersonalAsignaPrevio);
      }

      const tarea = await TareaModel.getById(id);
      return { ok: true, data: tarea };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async delete(id) {
    try {
      await TareaModel.delete(id);
      return { ok: true };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  /**
   * Devuelve los registros de tiempo de una tarea.
   */
  async getTiempos(idTarea) {
    try {
      const data = await TareaModel.getTiempos(idTarea);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  /**
   * Listado de tiempos (una fila por registro en TareasTiempos).
   */
  async getTiemposListado(filtros = {}) {
    try {
      const data = await TareaModel.getTiemposListado(filtros);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async createTiempo({ idTarea, fecha, horas, comentario, idIdentidad }) {
    try {
      if (!idTarea) return { ok: false, error: 'IdTarea obligatorio.' };
      if (!fecha) return { ok: false, error: 'Fecha obligatoria.' };
      if (horas == null || Number(horas) <= 0) return { ok: false, error: 'Horas inválidas.' };

      const valid = await this._validarHorasDia(idTarea, fecha, horas);
      if (!valid.ok) return valid;

      await TareaModel.registrarTiempo({ idTarea, fecha, horas, comentario, idIdentidad });
      const horasReales = await TareaModel.sumarHorasReales(idTarea);
      return { ok: true, data: { horasReales } };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async updateTiempo({ idTareaTiempo, idTarea, fecha, horas, comentario, idIdentidad }) {
    try {
      if (!idTareaTiempo) return { ok: false, error: 'IdTareaTiempo obligatorio.' };
      if (!fecha) return { ok: false, error: 'Fecha obligatoria.' };
      if (horas == null || Number(horas) <= 0) return { ok: false, error: 'Horas inválidas.' };

      const current = await TareaModel.getTiempoById(idTareaTiempo);
      if (!current) return { ok: false, error: 'Registro no encontrado.' };
      const tareaId = idTarea || current.IdTarea;

      const valid = await this._validarHorasDia(tareaId, fecha, horas, idTareaTiempo);
      if (!valid.ok) return valid;

      await TareaModel.updateTiempo({ idTareaTiempo, fecha, horas, comentario, idIdentidad });
      const horasReales = await TareaModel.sumarHorasReales(tareaId);
      return { ok: true, data: { horasReales } };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async deleteTiempo({ idTareaTiempo, idTarea }) {
    try {
      if (!idTareaTiempo) return { ok: false, error: 'IdTareaTiempo obligatorio.' };
      const current = await TareaModel.getTiempoById(idTareaTiempo);
      if (!current) return { ok: false, error: 'Registro no encontrado.' };
      const tareaId = idTarea || current.IdTarea;

      await TareaModel.deleteTiempo(idTareaTiempo);
      const horasReales = await TareaModel.sumarHorasReales(tareaId);
      return { ok: true, data: { horasReales } };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  /**
   * Registra horas trabajadas en una tarea.
   * Reglas:
   *   - Máximo 24 h por fecha (validado también en BD a través del SP).
   *   - Horas reales = suma de todos los registros de la tarea (Σ horas registradas).
   *     El SP `up_bp_TareasTiempos_Insert` se encarga de insertar el registro
   *     en `TareasTiempos` y de actualizar `Tareas.HorasReales` cuando corresponda.
   */
  async registrarTiempo({ idTarea, fecha, horas, comentario, idIdentidad }) {
    try {
      // Validar máximo 24 h/día
      const tiemposExistentes = await TareaModel.getTiempos(idTarea);
      const horasDia = tiemposExistentes
        .filter(t => {
          const f = t.Fecha ? String(t.Fecha).substring(0, 10) : '';
          return f === fecha;
        })
        .reduce((sum, t) => sum + Number(t.Horas || t.horas || 0), 0);

      if (horasDia + Number(horas) > 24) {
        const restante = (24 - horasDia).toFixed(2);
        return { ok: false, error: 'Límite diario superado. Solo puedes registrar ' + restante + ' h más para el ' + fecha + '.' };
      }

      // Insertar en TareasTiempos via SP
      await TareaModel.registrarTiempo({ idTarea, fecha, horas, comentario, idIdentidad });

      // Sumar todas las horas registradas para esta tarea
      const horasReales = await TareaModel.sumarHorasReales(idTarea);

      return { ok: true, data: { horasReales } };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }
}

module.exports = new TareaController();
