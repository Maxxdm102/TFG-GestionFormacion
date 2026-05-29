/* ═══════════════════════════════════════════════
   CONTROLLERS/PRESUPUESTOCONTROLLER.JS
   ═══════════════════════════════════════════════ */

const PresupuestoModel = require('../models/PresupuestoModel');

function localISODate(date = new Date()) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

class PresupuestoController {

  _validar(presupuesto) {
    const errores = [];
    if (!presupuesto.numero || presupuesto.numero.trim() === '')
      errores.push('El número de presupuesto es obligatorio');
    if (!presupuesto.cliente || presupuesto.cliente.trim() === '')
      errores.push('El cliente es obligatorio');
    if (!presupuesto.descripcion || presupuesto.descripcion.trim() === '')
      errores.push('La descripción es obligatoria');
    return errores;
  }

  async getAll(filtros = {}) {
    try {
      const data = await PresupuestoModel.getAll(filtros);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async getById(id) {
    try {
      const data = await PresupuestoModel.getById(id);
      if (!data) return { ok: false, error: 'Presupuesto no encontrado' };
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async getLineas(presupuestoId) {
    try {
      const data = await PresupuestoModel.getLineas(presupuestoId);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async create(datos) {
    try {
      const errores = this._validar(datos);
      if (errores.length > 0) return { ok: false, error: errores.join(', ') };
      if (!datos.fecha) datos.fecha = localISODate();
      const id = await PresupuestoModel.create(datos);
      const data = await PresupuestoModel.getById(id);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async update(id, datos) {
    try {
      const errores = this._validar(datos);
      if (errores.length > 0) return { ok: false, error: errores.join(', ') };
      await PresupuestoModel.update(id, datos);
      const data = await PresupuestoModel.getById(id);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async delete(id) {
    try {
      await PresupuestoModel.delete(id);
      return { ok: true };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }
}

module.exports = new PresupuestoController();
