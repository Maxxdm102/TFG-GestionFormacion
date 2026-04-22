/* ═══════════════════════════════════════════════
   CONTROLLERS/CLIENTECONTROLLER.JS
   ═══════════════════════════════════════════════ */

const ClienteModel = require('../models/ClienteModel');

class ClienteController {

  _validar(cliente) {
    const errores = [];
    if (!cliente.nombreComercial || cliente.nombreComercial.trim() === '')
      errores.push('El nombre comercial es obligatorio');
    return errores;
  }

  async getAll(filtros = {}) {
    try {
      const data = await ClienteModel.getAll(filtros);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async getById(id) {
    try {
      const data = await ClienteModel.getById(id);
      if (!data) return { ok: false, error: 'Cliente no encontrado' };
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async create(datos) {
    try {
      const errores = this._validar(datos);
      if (errores.length > 0) return { ok: false, error: errores.join(', ') };
      const id = await ClienteModel.create(datos);
      const data = await ClienteModel.getById(id);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async update(id, datos) {
    try {
      const errores = this._validar(datos);
      if (errores.length > 0) return { ok: false, error: errores.join(', ') };
      await ClienteModel.update(id, datos);
      const data = await ClienteModel.getById(id);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async delete(id) {
    try {
      await ClienteModel.delete(id);
      return { ok: true };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }
}

module.exports = new ClienteController();
