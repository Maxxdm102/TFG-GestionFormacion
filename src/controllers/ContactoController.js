/* ═══════════════════════════════════════════════
   CONTROLLERS/CONTACTOCONTROLLER.JS
   ═══════════════════════════════════════════════ */

const ContactoModel = require('../models/ContactoModel');

class ContactoController {

  _validar(contacto) {
    const errores = [];
    if (!contacto.personal || contacto.personal.trim() === '')
      errores.push('El personal es obligatorio');
    if (!contacto.fechaContacto)
      errores.push('La fecha de contacto es obligatoria');
    return errores;
  }

  async getAll(filtros = {}) {
    try {
      const data = await ContactoModel.getAll(filtros);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async getById(id) {
    try {
      const data = await ContactoModel.getById(id);
      if (!data) return { ok: false, error: 'Contacto no encontrado' };
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async create(datos) {
    try {
      const errores = this._validar(datos);
      if (errores.length > 0) return { ok: false, error: errores.join(', ') };
      const id = await ContactoModel.create(datos);
      const data = await ContactoModel.getById(id);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async update(id, datos) {
    try {
      const errores = this._validar(datos);
      if (errores.length > 0) return { ok: false, error: errores.join(', ') };
      await ContactoModel.update(id, datos);
      const data = await ContactoModel.getById(id);
      return { ok: true, data };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }

  async delete(id) {
    try {
      await ContactoModel.delete(id);
      return { ok: true };
    } catch (err) {
      return { ok: false, error: err.message };
    }
  }
}

module.exports = new ContactoController();
