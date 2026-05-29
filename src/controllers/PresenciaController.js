/* ═══════════════════════════════════════════════
   CONTROLLERS/PRESENCIACONTROLLER.JS
   ═══════════════════════════════════════════════ */

const PresenciaModel = require('../models/PresenciaModel');

function localISODate(date = new Date()) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

class PresenciaController {

  // Devuelve los fichajes de un empleado por IdPersonal
  async getFichajesPersonales(idPersonal, fechaFiltro = null) {
    try {
      if (idPersonal == null) throw new Error('Se requiere IdPersonal');
      return await PresenciaModel.getFichajes(idPersonal, fechaFiltro);
    } catch (error) {
      console.error('Error getFichajesPersonales:', error);
      throw error;
    }
  }

  // Registra un evento y devuelve el id generado
  async registrarFichaje(idPersonal, idControlPresenciaTipoEvento, ipDispositivo = '', comentarios = '') {
    try {
      if (idPersonal == null)                throw new Error('Se requiere IdPersonal');
      if (!idControlPresenciaTipoEvento)     throw new Error('Se requiere IdControlPresenciaTipoEvento');
      const id = await PresenciaModel.insertFichaje(idPersonal, idControlPresenciaTipoEvento, ipDispositivo, comentarios);
      return { ok: true, idFichaje: id };
    } catch (error) {
      console.error('Error registrarFichaje:', error);
      return { ok: false, error: error.message };
    }
  }

  // Devuelve el estado actual del empleado según su último evento de hoy
  async getEstadoActual(idPersonal) {
    try {
      if (idPersonal == null) throw new Error('Se requiere IdPersonal');

      const hoy = localISODate();
      const registros = await PresenciaModel.getFichajes(idPersonal, hoy);

      if (!registros || registros.length === 0) {
        return { estado: 2, estadoStr: 'Desconectado', ultimoRegistro: null };
      }

      const parseFechaHora = (row) => {
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
        return null;
      };

      const pickUltimo = (rows = []) => {
        if (!rows.length) return null;
        const withDate = rows
          .map(r => {
            const dt = parseFechaHora(r);
            const id = Number(r.IdControlPresenciaFichaje ?? r.Id ?? r.id);
            return { r, dt, id: Number.isFinite(id) ? id : null };
          })
          .filter(x => x.dt);
        if (withDate.length) {
          withDate.sort((a, b) => {
            const diff = b.dt.getTime() - a.dt.getTime();
            if (diff !== 0) return diff;
            if (a.id != null && b.id != null) return b.id - a.id;
            return 0;
          });
          return withDate[0].r;
        }

        const withId = rows
          .map(r => ({ r, id: Number(r.IdControlPresenciaFichaje ?? r.Id ?? r.id) }))
          .filter(x => Number.isFinite(x.id));
        if (withId.length) {
          withId.sort((a, b) => b.id - a.id);
          return withId[0].r;
        }
        return rows[0];
      };

      const ultimo = pickUltimo(registros);
      const tipoEvento = ultimo?.IdControlPresenciaTipoEvento;
      let estadoStr = 'Desconectado';
      if      (tipoEvento === 1) estadoStr = 'Trabajando';
      else if (tipoEvento === 2) estadoStr = 'Desconectado';
      else if (tipoEvento === 3) estadoStr = 'En pausa';
      else if (tipoEvento === 4) estadoStr = 'Trabajando'; // Fin pausa → vuelve a trabajar

      return { estado: tipoEvento, estadoStr, ultimoRegistro: ultimo };
    } catch (error) {
      console.error('Error getEstadoActual:', error);
      throw error;
    }
  }

  async updateComentario(idControlPresenciaFichaje, comentarios = '') {
    try {
      if (idControlPresenciaFichaje == null) throw new Error('Se requiere IdControlPresenciaFichaje');
      await PresenciaModel.updateFichaje(idControlPresenciaFichaje, null, null, comentarios);
      return { ok: true };
    } catch (error) {
      console.error('Error updateComentario:', error);
      return { ok: false, error: error.message };
    }
  }

  async updateFichaje(payload = {}) {
    try {
      const {
        idControlPresenciaFichaje,
        idControlPresenciaTipoEvento,
        fecha,
        hora,
        fechaHora
      } = payload || {};

      if (idControlPresenciaFichaje == null) throw new Error('Se requiere IdControlPresenciaFichaje');
      if (idControlPresenciaTipoEvento == null) throw new Error('Se requiere IdControlPresenciaTipoEvento');

      let fechaFinal = null;
      if (fechaHora) {
        fechaFinal = new Date(fechaHora);
      } else if (fecha && hora) {
        fechaFinal = new Date(`${fecha}T${hora}:00`);
      }

      if (!fechaFinal || Number.isNaN(fechaFinal.getTime())) {
        throw new Error('Fecha y hora no válidas.');
      }

      await PresenciaModel.updateFichaje(idControlPresenciaFichaje, idControlPresenciaTipoEvento, fechaFinal, null);
      return { ok: true };
    } catch (error) {
      console.error('Error updateFichaje:', error);
      return { ok: false, error: error.message };
    }
  }

  async deleteFichaje(idControlPresenciaFichaje) {
    try {
      if (idControlPresenciaFichaje == null) throw new Error('Se requiere IdControlPresenciaFichaje');
      await PresenciaModel.deleteFichaje(idControlPresenciaFichaje);
      return { ok: true };
    } catch (error) {
      console.error('Error deleteFichaje:', error);
      return { ok: false, error: error.message };
    }
  }
}

module.exports = new PresenciaController();
