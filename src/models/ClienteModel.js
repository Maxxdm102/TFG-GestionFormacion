/* ═══════════════════════════════════════════════
   MODELS/CLIENTEMODEL.JS — Acceso a datos: Clientes
   ═══════════════════════════════════════════════ */

const { getPool, sql } = require('../database/db');

class ClienteModel {

  async getAll(filtros = {}) {
    const pool = await getPool();
    const request = pool.request();
    let where = 'WHERE 1=1';

    if (filtros.nombre) {
      request.input('nombre', sql.NVarChar(200), `%${filtros.nombre}%`);
      where += ' AND (c.NombreComercial COLLATE Latin1_General_CI_AI LIKE @nombre OR c.RazonSocial COLLATE Latin1_General_CI_AI LIKE @nombre)';
    }

    if (filtros.provincia) {
      request.input('provincia', sql.NVarChar(100), `%${filtros.provincia}%`);
      where += ' AND pr.Nombre COLLATE Latin1_General_CI_AI LIKE @provincia';
    }

    if (filtros.tipo || filtros.tipoDocumento) {
      const tipoVal = filtros.tipoDocumento || filtros.tipo;
      request.input('tipoDocumento', sql.NVarChar(100), `%${tipoVal}%`);
      where += ' AND tc.Nombre COLLATE Latin1_General_CI_AI LIKE @tipoDocumento';
    }

    if (filtros.email) {
      request.input('email', sql.NVarChar(200), `%${filtros.email}%`);
      where += ' AND c.Email COLLATE Latin1_General_CI_AI LIKE @email';
    }

    if (filtros.pais) {
      request.input('pais', sql.NVarChar(100), `%${filtros.pais}%`);
      where += ' AND p.Nombre COLLATE Latin1_General_CI_AI LIKE @pais';
    }

    if (filtros.numeroDocumento) {
      request.input('numeroDocumento', sql.NVarChar(50), `%${filtros.numeroDocumento}%`);
      where += ' AND c.Documento COLLATE Latin1_General_CI_AI LIKE @numeroDocumento';
    }

    if (filtros.telefono) {
      request.input('telefono', sql.NVarChar(30), `%${filtros.telefono}%`);
      where += ' AND (c.TelefonoFijo LIKE @telefono OR c.TelefonoMovil LIKE @telefono)';
    }

    if (filtros.numero) {
      const raw = String(filtros.numero).trim();
      if (raw) {
        request.input('numeroLike', sql.NVarChar(50), `%${raw}%`);
        const n = parseInt(raw, 10);
        if (Number.isFinite(n)) {
          request.input('numeroExact', sql.Int, n);
          where += ' AND (c.IdCliente = @numeroExact OR CAST(c.IdCliente AS NVARCHAR(20)) LIKE @numeroLike)';
        } else {
          where += ' AND CAST(c.IdCliente AS NVARCHAR(20)) LIKE @numeroLike';
        }
      }
    }

    const result = await request.query(`
      SELECT
        c.*,
        c.IdCliente AS Id,
        CAST(c.IdCliente AS NVARCHAR(20)) AS Numero,
        tc.Nombre AS TipoDocumento,
        c.Documento AS NumeroDocumento,
        p.Nombre AS Pais,
        pr.Nombre AS Provincia,
        COALESCE(c.TelefonoFijo, c.TelefonoMovil, '') AS Telefono
      FROM dbo.gf_Clientes c
      LEFT JOIN dbo.tiposCerrados tc ON tc.IdTipo = c.IdTipoDocumento AND tc.IdTipoDefinicion = 6
      LEFT JOIN dbo.Paises p ON p.IdPais = c.IdPais
      LEFT JOIN dbo.Provincias pr ON pr.IdProvincia = c.IdProvincia
      ${where}
      ORDER BY c.NombreComercial
    `);
    return result.recordset;
  }

  async getById(id) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.Int, id)
      .query(`
        SELECT
          c.*,
          c.IdCliente AS Id,
          CAST(c.IdCliente AS NVARCHAR(20)) AS Numero,
          tc.Nombre AS TipoDocumento,
          c.Documento AS NumeroDocumento,
          p.Nombre AS Pais,
          pr.Nombre AS Provincia,
          COALESCE(c.TelefonoFijo, c.TelefonoMovil, '') AS Telefono
        FROM dbo.gf_Clientes c
        LEFT JOIN dbo.tiposCerrados tc ON tc.IdTipo = c.IdTipoDocumento AND tc.IdTipoDefinicion = 6
        LEFT JOIN dbo.Paises p ON p.IdPais = c.IdPais
        LEFT JOIN dbo.Provincias pr ON pr.IdProvincia = c.IdProvincia
        WHERE c.IdCliente = @id
      `);
    return result.recordset[0] || null;
  }

  async create(cliente) {
    const pool = await getPool();
    const result = await pool.request()
      .input('numero',          sql.NVarChar(20),      cliente.numero)
      .input('nombreComercial', sql.NVarChar(200),     cliente.nombreComercial)
      .input('razonSocial',     sql.NVarChar(200),     cliente.razonSocial)
      .input('tipoDocumento',   sql.NVarChar(20),      cliente.tipoDocumento)
      .input('numDocumento',    sql.NVarChar(20),      cliente.numeroDocumento)
      .input('pais',            sql.NVarChar(100),     cliente.pais)
      .input('provincia',       sql.NVarChar(100),     cliente.provincia)
      .input('zonaGeografica',  sql.NVarChar(100),     cliente.zonaGeografica)
      .input('poblacion',       sql.NVarChar(100),     cliente.poblacion)
      .input('direccion',       sql.NVarChar(300),     cliente.direccion)
      .input('tipo',            sql.NVarChar(50),      cliente.tipo)
      .input('procedencia',     sql.NVarChar(100),     cliente.procedencia)
      .input('telefono',        sql.NVarChar(30),      cliente.telefono)
      .input('fax',             sql.NVarChar(30),      cliente.fax)
      .input('email',           sql.NVarChar(200),     cliente.email)
      .query(`
        INSERT INTO dbo.gf_Clientes (
          Numero, NombreComercial, RazonSocial, TipoDocumento, NumeroDocumento,
          Pais, Provincia, ZonaGeografica, Poblacion, Direccion,
          Tipo, Procedencia, Telefono, Fax, Email, FechaAlta, Activo
        )
        OUTPUT INSERTED.IdCliente AS Id
        VALUES (
          @numero, @nombreComercial, @razonSocial, @tipoDocumento, @numDocumento,
          @pais, @provincia, @zonaGeografica, @poblacion, @direccion,
          @tipo, @procedencia, @telefono, @fax, @email, GETDATE(), 1
        )
      `);
    return result.recordset[0].Id;
  }

  async update(id, cliente) {
    const pool = await getPool();
    await pool.request()
      .input('id',              sql.Int,           id)
      .input('nombreComercial', sql.NVarChar(200), cliente.nombreComercial)
      .input('razonSocial',     sql.NVarChar(200), cliente.razonSocial)
      .input('tipoDocumento',   sql.NVarChar(20),  cliente.tipoDocumento)
      .input('numDocumento',    sql.NVarChar(20),  cliente.numeroDocumento)
      .input('pais',            sql.NVarChar(100), cliente.pais)
      .input('provincia',       sql.NVarChar(100), cliente.provincia)
      .input('zonaGeografica',  sql.NVarChar(100), cliente.zonaGeografica)
      .input('poblacion',       sql.NVarChar(100), cliente.poblacion)
      .input('direccion',       sql.NVarChar(300), cliente.direccion)
      .input('tipo',            sql.NVarChar(50),  cliente.tipo)
      .input('procedencia',     sql.NVarChar(100), cliente.procedencia)
      .input('telefono',        sql.NVarChar(30),  cliente.telefono)
      .input('fax',             sql.NVarChar(30),  cliente.fax)
      .input('email',           sql.NVarChar(200), cliente.email)
      .query(`
        UPDATE dbo.gf_Clientes SET
          NombreComercial = @nombreComercial,
          RazonSocial     = @razonSocial,
          TipoDocumento   = @tipoDocumento,
          NumeroDocumento = @numDocumento,
          Pais            = @pais,
          Provincia       = @provincia,
          ZonaGeografica  = @zonaGeografica,
          Poblacion       = @poblacion,
          Direccion       = @direccion,
          Tipo            = @tipo,
          Procedencia     = @procedencia,
          Telefono        = @telefono,
          Fax             = @fax,
          Email           = @email
        WHERE IdCliente = @id
      `);
  }

  async delete(id) {
    const pool = await getPool();
    await pool.request()
      .input('id', sql.Int, id)
      .query('DELETE FROM dbo.gf_Clientes WHERE IdCliente = @id');
  }
}

module.exports = new ClienteModel();
