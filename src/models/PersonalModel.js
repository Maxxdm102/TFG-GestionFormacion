/* ═══════════════════════════════════════════════
   MODELS/PERSONALMODEL.JS — Acceso a datos: Personal
   Usa stored procedure up_bp_Personal_Select_Corto
   ═══════════════════════════════════════════════ */

const { getPool, sql } = require('../database/db');

class PersonalModel {

  /**
   * Obtiene lista de personal
   * @param {object} filtros - { activo: true/false/null }
   */
  async getAll(filtros = {}) {
    const pool = await getPool();
    const request = pool.request();

    // @Activo: 1 = solo activos, 0 = solo inactivos, null = todos
    const activo = filtros.activo === true  ? 1
                 : filtros.activo === false ? 0
                 : null;

    request.input('IdPersonal',         sql.Int,          null);
    request.input('IdSociedad',         sql.Int,          null);
    request.input('Activo',             sql.TinyInt,      activo);
    request.input('NombreCompleto',     sql.VarChar(200), null);
    request.input('IdSociedadExcluir',  sql.Int,          null);
    request.input('IdComercialIncluir', sql.Int,          null);
    request.input('IdCentroTrabajo',    sql.Int,          null);
    request.input('ConCodigoPersonal',  sql.TinyInt,      null);
    request.input('CadenaIdPersonal', sql.VarChar(sql.MAX), null);
    request.input('CodigoTarjeta',      sql.VarChar(50),  null);

    const result = await request.execute('up_bp_Personal_Select_Corto');
    return result.recordset;
  }
}

module.exports = new PersonalModel();
