/* â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
   MODELS/PRESUPUESTOMODEL.JS â€” Acceso a datos: Presupuestos
   â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â• */

const { getPool, sql } = require('../database/db');

class PresupuestoModel {

  async getAll(filtros = {}) {
    const pool = await getPool();
    const request = pool.request();
    let where = 'WHERE 1=1';

    if (filtros.cliente) {
      request.input('cliente', sql.NVarChar(200), `%${filtros.cliente}%`);
      where += ' AND (p.NombreComercialCliente COLLATE Latin1_General_CI_AI LIKE @cliente' +
               ' OR p.NombreFiscalCliente COLLATE Latin1_General_CI_AI LIKE @cliente' +
               ' OR p.Cliente COLLATE Latin1_General_CI_AI LIKE @cliente' +
               ' OR cli.NombreComercial COLLATE Latin1_General_CI_AI LIKE @cliente' +
               ' OR cli.RazonSocial COLLATE Latin1_General_CI_AI LIKE @cliente)';
    }

    if (filtros.idCliente != null) {
      request.input('idCliente', sql.Int, filtros.idCliente);
      where += ' AND p.IdCliente = @idCliente';
    }

    if (filtros.estado) {
      request.input('estado', sql.NVarChar(50), filtros.estado);
      where += ' AND p.NombreEstadoPresupuesto COLLATE Latin1_General_CI_AI = @estado';
    }

    if (filtros.albaraneado !== undefined) {
      if (filtros.albaraneado === true) {
        where += ' AND p.FechaAlbaraneado IS NOT NULL';
      } else if (filtros.albaraneado === false) {
        where += ' AND p.FechaAlbaraneado IS NULL';
      }
    }

    if (filtros.numero) {
      request.input('numero', sql.NVarChar(30), `%${filtros.numero}%`);
      where += ' AND p.NumeroPresupuesto LIKE @numero';
    }

    const result = await request.query(`
      SELECT
        p.IdPresupuesto AS Id,
        p.NumeroPresupuesto AS Numero,
        p.Version,
        p.Fecha,
        COALESCE(p.NombreComercialCliente, p.NombreFiscalCliente, p.Cliente, cli.NombreComercial, cli.RazonSocial, '') AS Cliente,
        p.Descripcion,
        p.FechaEntrega AS FechaEntrega,
        NULL AS ImporteBase,
        NULL AS ImporteIVA,
        COALESCE(p.ImportePresupuesto, p.CostePrevistosTotales, 0) AS ImporteTotal,
        p.NombreEstadoPresupuesto AS Estado,
        p.FechaEstadoPresupuesto AS FechaEstado,
        p.NombreEstadoProduccion AS EstadoProduccion,
        p.FechaEstadoProduccion AS FechaEstadoProduccion,
        p.NombreTipo AS Tipo,
        p.NumeroLineasSinTarea AS NumLineasSinTareas,
        p.NumeroTareasNoRealizadas AS NumTareasNoRealizadas,
        p.NumeroTareasRealizadas AS NumTareasRealizadas,
        CAST(CASE WHEN p.FechaAlbaraneado IS NOT NULL THEN 1 ELSE 0 END AS bit) AS Albaraneado,
        CAST(0 AS bit) AS Facturado
      FROM vw_bp_Presupuestos p
      LEFT JOIN dbo.gf_Clientes cli ON cli.IdCliente = p.IdCliente
      ${where}
      ORDER BY p.Fecha DESC, p.NumeroPresupuesto DESC
    `);
    return result.recordset;
  }

  async getById(id) {
    const pool = await getPool();
    const result = await pool.request()
      .input('id', sql.Int, id)
      .query('SELECT * FROM Presupuestos WHERE idPresupuesto = @id');
    return result.recordset[0] || null;
  }

  /**
   * Obtiene las lÃ­neas de un presupuesto
   */
  async getLineas(presupuestoId) {
    const pool = await getPool();
    const result = await pool.request()
      .input('presupuestoId', sql.Int, presupuestoId)
      .query(`
        SELECT
          l.idPresupuestoLinea AS Id,
          l.idPresupuesto AS PresupuestoId,
          l.NumOrden AS NumeroOrden,
          COALESCE(NULLIF(LTRIM(RTRIM(l.Codigo)), ''), CAST(l.idArticulo AS varchar(50))) AS CodigoArticulo,
          l.Descripcion,
          l.Cantidad,
          COALESCE(um.Simbolo, um.Nombre, '') AS UnidadMedida,
          l.Precio,
          l.Descuento,
          l.Importe,
          l.RequiereTarea,
          l.RequierePedido,
          l.CarpetaTrabajo,
          COALESCE(pv.NombreComercial, pv.RazonSocial, '') AS Proveedor
        FROM Presupuestos_Lineas l
        LEFT JOIN UnidadesMedida um ON um.IdUnidadMedida = l.idUnidadMedida
        LEFT JOIN gf_Proveedores pv ON pv.IdProveedor = l.idProveedor
        WHERE l.idPresupuesto = @presupuestoId
        ORDER BY l.NumOrden
      `);
    return result.recordset;
  }

  async create(presupuesto) {
    const pool = await getPool();
    const result = await pool.request()
      .input('numero',      sql.NVarChar(50),      presupuesto.numero)
      .input('version',     sql.Int,               presupuesto.version || 1)
      .input('fecha',       sql.Date,              presupuesto.fecha)
      .input('idCliente',   sql.Int,               presupuesto.idCliente || null)
      .input('cliente',     sql.NVarChar(200),     presupuesto.cliente)
      .input('descripcion', sql.NVarChar(1000),    presupuesto.descripcion)
      .input('fEntrega',    sql.Date,              presupuesto.fechaEntrega || null)
      .input('estado',      sql.NVarChar(100),     presupuesto.estado || 'Preparación')
      .query(`
        INSERT INTO Presupuestos (
          NumPresupuesto, Version, Fecha, idCliente, Descripcion,
          FechaLimite, Estado, FechaPreparacion, NombreComercialCliente, NombreFiscalCliente
        )
        OUTPUT INSERTED.idPresupuesto
        VALUES (
          @numero, @version, @fecha, @idCliente, @descripcion,
          @fEntrega, @estado, GETDATE(), @cliente, @cliente
        )
      `);
    return result.recordset[0].idPresupuesto;
  }
  async update(id, presupuesto) {
    const pool = await getPool();
    await pool.request()
      .input('id',          sql.Int,            id)
      .input('cliente',     sql.NVarChar(200),  presupuesto.cliente)
      .input('descripcion', sql.NVarChar(1000), presupuesto.descripcion)
      .input('fEntrega',    sql.Date,           presupuesto.fechaEntrega || null)
      .input('estado',      sql.NVarChar(100),  presupuesto.estado)
      .query(`
        UPDATE Presupuestos SET
          NombreComercialCliente = @cliente,
          NombreFiscalCliente    = @cliente,
          Descripcion            = @descripcion,
          FechaLimite            = @fEntrega,
          Estado                 = @estado,
          FechaModificacion      = GETDATE()
        WHERE idPresupuesto = @id
      `);
  }
  async delete(id) {
    const pool = await getPool();
    // Borrar lÃ­neas primero (integridad referencial)
    await pool.request()
      .input('id', sql.Int, id)
      .query('DELETE FROM LineasPresupuesto WHERE PresupuestoId = @id');
    await pool.request()
      .input('id', sql.Int, id)
      .query('DELETE FROM Presupuestos WHERE idPresupuesto = @id');
  }
}

module.exports = new PresupuestoModel();

