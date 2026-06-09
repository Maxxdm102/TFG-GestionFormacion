/* ═══════════════════════════════════════════════
   MODELS/PRESENCIAMODEL.JS — Acceso a datos: Presencia
   ═══════════════════════════════════════════════ */

const { getPool, sql } = require('../database/db');

class PresenciaModel {

  async getFichajes(idPersonal = null, fechaFiltro = null) {
    const pool = await getPool();
    const request = pool.request();
    if (idPersonal != null) request.input('IdPersonal', sql.Int, idPersonal);
    if (fechaFiltro)        request.input('FechaFiltro', sql.Date, fechaFiltro);
    const result = await request.execute('up_ControlPresencia_Select');
    return result.recordset || [];
  }

  async insertFichaje(idPersonal, idControlPresenciaTipoEvento, ipDispositivo = null, comentarios = null) {
    const pool = await getPool();
    const request = pool.request();
    request.output('IdControlPresenciaFichaje', sql.Int);
    request.input('IdPersonal',                    sql.Int,          idPersonal);
    request.input('IdControlPresenciaTipoEvento',  sql.Int,          idControlPresenciaTipoEvento);
    if (ipDispositivo) request.input('IpDispositivo', sql.VarChar(100), ipDispositivo);
    if (comentarios)   request.input('Comentarios',   sql.VarChar(500), comentarios);

    await request.execute('up_ControlPresencia_Insert');
    return request.parameters.IdControlPresenciaFichaje.value;
  }

  async updateFichaje(idControlPresenciaFichaje, idControlPresenciaTipoEvento = null, fechaHora = null, comentarios = null) {
    const pool = await getPool();
    const request = pool.request();
    request.input('IdControlPresenciaFichaje',     sql.Int,      idControlPresenciaFichaje);
    if (idControlPresenciaTipoEvento != null) request.input('IdControlPresenciaTipoEvento', sql.Int, idControlPresenciaTipoEvento);
    if (fechaHora)   request.input('FechaHora',   sql.DateTime,   fechaHora);
    if (comentarios) request.input('Comentarios', sql.VarChar(500), comentarios);

    await request.execute('up_ControlPresencia_Update');
    return true;
  }

  async deleteFichaje(idControlPresenciaFichaje) {
    const pool = await getPool();
    const request = pool.request();
    request.input('IdControlPresenciaFichaje', sql.Int, idControlPresenciaFichaje);
    await request.execute('up_ControlPresencia_Delete');
    return true;
  }
}

module.exports = new PresenciaModel();
