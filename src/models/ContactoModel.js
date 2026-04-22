/* ═══════════════════════════════════════════════
   MODELS/CONTACTOMODEL.JS — Acceso a datos: Contactos
   ═══════════════════════════════════════════════ */

const { getPool, sql } = require('../database/db');

class ContactoModel {

  _toDateOrNull(value) {
    if (!value) return null;
    if (value instanceof Date) {
      if (Number.isNaN(value.getTime())) return null;
      return value;
    }

    const raw = String(value).trim();
    if (!raw) return null;

    const iso = raw.match(/^(\d{4})-(\d{2})-(\d{2})/);
    if (iso) {
      const year = Number(iso[1]);
      const month = Number(iso[2]);
      const day = Number(iso[3]);
      if (!Number.isInteger(year) || !Number.isInteger(month) || !Number.isInteger(day)) return null;
      if (year < 1900 || year > 2079) return null;
      const d = new Date(year, month - 1, day, 12, 0, 0);
      if (Number.isNaN(d.getTime())) return null;
      return d;
    }

    const parsed = new Date(raw);
    if (Number.isNaN(parsed.getTime())) return null;
    return parsed;
  }

  _toTinyInt(value) {
    if (value === null || value === undefined) return null;
    if (typeof value === 'boolean') return value ? 1 : 0;
    if (typeof value === 'number') return Number.isFinite(value) ? (value ? 1 : 0) : null;
    const raw = String(value).trim().toLowerCase();
    if (!raw) return null;
    if (['1', 'si', 'sí', 's', 'true', 't', 'yes', 'y'].includes(raw)) return 1;
    if (['0', 'no', 'n', 'false', 'f'].includes(raw)) return 0;
    return null;
  }

  _idsToString(value) {
    if (value === null || value === undefined) return null;
    if (Array.isArray(value)) {
      const list = value.map(v => String(v).trim()).filter(Boolean);
      return list.length ? list.join(',') : null;
    }
    if (typeof value === 'number') return Number.isFinite(value) ? String(value) : null;
    const raw = String(value).trim();
    return raw ? raw : null;
  }

  async getAll(filtros = {}) {
    const pool = await getPool();
    const request = pool.request();
    const idTipoPropietarioAsociado = (filtros.idTipoPropietarioAsociado != null)
      ? filtros.idTipoPropietarioAsociado
      : 4;
    const idTipoPropietarioRealizador = (filtros.idTipoPropietarioRealizador != null)
      ? filtros.idTipoPropietarioRealizador
      : 1;

    const idsAsociado = this._idsToString(
      filtros.idsPropietarioAsociado ?? filtros.idsCliente ?? filtros.idCliente ?? null
    );
    const idsRealizador = this._idsToString(
      filtros.idsPropietarioRealizador ?? filtros.idsPersonal ?? filtros.idPersonal ?? null
    );

    request.input('IdContacto', sql.Int, filtros.idContacto || null);
    request.input('CadenaIdsContactos', sql.VarChar(sql.MAX), this._idsToString(filtros.cadenaIdsContactos ?? filtros.idsContactos ?? null));
    request.input('IdTipoPropietarioAsociado', sql.Int, idTipoPropietarioAsociado);
    request.input('IdTipoPropietarioRealizador', sql.Int, idTipoPropietarioRealizador);
    request.input('IdsPropietarioAsociado', sql.NVarChar(sql.MAX), idsAsociado);
    request.input('IdsPropietarioRealizador', sql.NVarChar(sql.MAX), idsRealizador);
    request.input('IdContactoClasificacion', sql.Int, filtros.idContactoClasificacion || null);
    request.input('IdTipoContacto', sql.Int, filtros.idTipoContacto || null);
    request.input('FechaDesde', sql.SmallDateTime, this._toDateOrNull(filtros.fechaDesde));
    request.input('FechaHasta', sql.SmallDateTime, this._toDateOrNull(filtros.fechaHasta));
    request.input('PersonaContactada', sql.VarChar(200), filtros.personaContactada || null);
    request.input('Rellamada', sql.TinyInt, this._toTinyInt(filtros.rellamada));
    request.input('PlanificadoRealizado', sql.TinyInt, this._toTinyInt(filtros.planificadoRealizado));
    request.input('NivelMostrar', sql.TinyInt, filtros.nivelMostrar != null ? Number(filtros.nivelMostrar) : 2);

    const result = await request.query(`
      SET DATEFORMAT dmy;
      EXEC up_Contactos_Select_Agrupado
        @IdContacto = @IdContacto,
        @CadenaIdsContactos = @CadenaIdsContactos,
        @IdTipoPropietarioAsociado = @IdTipoPropietarioAsociado,
        @IdTipoPropietarioRealizador = @IdTipoPropietarioRealizador,
        @IdsPropietarioAsociado = @IdsPropietarioAsociado,
        @IdsPropietarioRealizador = @IdsPropietarioRealizador,
        @IdContactoClasificacion = @IdContactoClasificacion,
        @IdTipoContacto = @IdTipoContacto,
        @FechaDesde = @FechaDesde,
        @FechaHasta = @FechaHasta,
        @PersonaContactada = @PersonaContactada,
        @Rellamada = @Rellamada,
        @PlanificadoRealizado = @PlanificadoRealizado,
        @NivelMostrar = @NivelMostrar;
    `);
    return result.recordset || [];
  }

  async getById(id) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.Int, id)
      .query('SELECT * FROM Contactos WHERE Id = @id');
    return result.recordset[0] || null;
  }

  async create(contacto) {
    const pool = await getPool();
    const result = await pool.request()
      .input('personal',        sql.NVarChar(200),     contacto.personal)
      .input('fechaContacto',   sql.Date,              contacto.fechaContacto)
      .input('horaContacto',    sql.NVarChar(10),      contacto.horaContacto)
      .input('cliente',         sql.NVarChar(200),     contacto.cliente)
      .input('propietario',     sql.NVarChar(200),     contacto.propietario)
      .input('direccion',       sql.NVarChar(300),     contacto.direccion)
      .input('provincia',       sql.NVarChar(100),     contacto.provincia)
      .input('poblacion',       sql.NVarChar(100),     contacto.poblacion)
      .input('numTelefono',     sql.NVarChar(30),      contacto.numeroTelefono)
      .input('personaContacto', sql.NVarChar(200),     contacto.personaContacto)
      .input('tipoContacto',    sql.NVarChar(50),      contacto.tipoContacto)
      .input('estado',          sql.NVarChar(50),      contacto.estado || 'Planificado')
      .input('rellamada',       sql.Bit,               contacto.rellamada ? 1 : 0)
      .input('observaciones',   sql.NVarChar(sql.MAX), contacto.observaciones)
      .input('clasificadoComo', sql.NVarChar(100),     contacto.clasificadoComo)
      .query(`
        INSERT INTO Contactos (
          Personal, FechaContacto, HoraContacto, Cliente, Propietario,
          Direccion, Provincia, Poblacion, NumeroTelefono, PersonaContacto,
          TipoContacto, Estado, Rellamada, Observaciones, ClasificadoComo
        )
        OUTPUT INSERTED.Id
        VALUES (
          @personal, @fechaContacto, @horaContacto, @cliente, @propietario,
          @direccion, @provincia, @poblacion, @numTelefono, @personaContacto,
          @tipoContacto, @estado, @rellamada, @observaciones, @clasificadoComo
        )
      `);
    return result.recordset[0].Id;
  }

  async update(id, contacto) {
    const pool = await getPool();
    await pool.request()
      .input('id',              sql.Int,           id)
      .input('personal',        sql.NVarChar(200), contacto.personal)
      .input('fechaContacto',   sql.Date,          contacto.fechaContacto)
      .input('horaContacto',    sql.NVarChar(10),  contacto.horaContacto)
      .input('cliente',         sql.NVarChar(200), contacto.cliente)
      .input('personaContacto', sql.NVarChar(200), contacto.personaContacto)
      .input('tipoContacto',    sql.NVarChar(50),  contacto.tipoContacto)
      .input('estado',          sql.NVarChar(50),  contacto.estado)
      .input('rellamada',       sql.Bit,           contacto.rellamada ? 1 : 0)
      .input('observaciones',   sql.NVarChar(sql.MAX), contacto.observaciones)
      .input('clasificadoComo', sql.NVarChar(100), contacto.clasificadoComo)
      .query(`
        UPDATE Contactos SET
          Personal        = @personal,
          FechaContacto   = @fechaContacto,
          HoraContacto    = @horaContacto,
          Cliente         = @cliente,
          PersonaContacto = @personaContacto,
          TipoContacto    = @tipoContacto,
          Estado          = @estado,
          Rellamada       = @rellamada,
          Observaciones   = @observaciones,
          ClasificadoComo = @clasificadoComo
        WHERE Id = @id
      `);
  }

  async delete(id) {
    const pool = await getPool();
    await pool.request()
      .input('id', sql.Int, id)
      .query('DELETE FROM Contactos WHERE Id = @id');
  }
}

module.exports = new ContactoModel();
