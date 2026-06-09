/* ═══════════════════════════════════════════════
   MODELS/TAREAMODEL.JS — Acceso a datos: Tareas
   Usa stored procedure up_bp_Tareas_Select
   ═══════════════════════════════════════════════ */

const { getPool, sql } = require('../database/db');

class TareaModel {
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
      if (!this._isWithinSmallDateRange(year, month, day)) return null;
      const d = new Date(year, month - 1, day, 12, 0, 0);
      if (Number.isNaN(d.getTime())) return null;
      return d;
    }

    const parsed = new Date(raw);
    if (Number.isNaN(parsed.getTime())) return null;
    const year = parsed.getFullYear();
    const month = parsed.getMonth() + 1;
    const day = parsed.getDate();
    if (!this._isWithinSmallDateRange(year, month, day)) return null;
    return new Date(year, month - 1, day, 12, 0, 0);
  }

  _isWithinSmallDateRange(year, month, day) {
    if (!Number.isInteger(year) || !Number.isInteger(month) || !Number.isInteger(day)) return false;
    if (year < 1900 || year > 2079) return false;
    if (year === 2079) {
      if (month > 6) return false;
      if (month === 6 && day > 6) return false;
    }
    return month >= 1 && month <= 12 && day >= 1 && day <= 31;
  }

  async getAll(filtros = {}) {
    const pool = await getPool();
    const request = pool.request();

    request.input('IdTarea', sql.Int, filtros.idTarea || null);
    request.input('IdPersonalCreador', sql.Int, filtros.idPersonalCreador || null);
    request.input('IdPersonalAsignado', sql.Int, filtros.idPersonalAsignado || null);
    request.input('CadenaIdsTareaTipo', sql.VarChar(sql.MAX), filtros.cadenaTipo || null);
    request.input('CadenaIdsTareaEstado', sql.VarChar(sql.MAX), filtros.cadenaEstado || null);
    request.input('FechaCreacionDesde', sql.SmallDateTime, filtros.fechaCreacionDesde || null);
    request.input('FechaCreacionHasta', sql.SmallDateTime, filtros.fechaCreacionHasta || null);
    request.input('ConFechaPrevistaEntrega', sql.TinyInt, filtros.conFechaPrevistaEntrega != null ? (filtros.conFechaPrevistaEntrega ? 1 : 0) : null);
    request.input('FechaPrevistaEntregaDesde', sql.SmallDateTime, filtros.fechaPrevistaEntregaDesde || null);
    request.input('FechaPrevistaEntregaHasta', sql.SmallDateTime, filtros.fechaPrevistaEntregaHasta || null);
    request.input('Iniciada', sql.TinyInt, filtros.iniciada != null ? (filtros.iniciada ? 1 : 0) : null);
    request.input('FechaInicioDesde', sql.SmallDateTime, filtros.fechaInicioDesde || null);
    request.input('FechaInicioHasta', sql.SmallDateTime, filtros.fechaInicioHasta || null);
    request.input('Finalizada', sql.TinyInt, filtros.finalizada != null ? (filtros.finalizada ? 1 : 0) : null);
    request.input('FechaFinDesde', sql.SmallDateTime, filtros.fechaFinDesde || null);
    request.input('FechaFinHasta', sql.SmallDateTime, filtros.fechaFinHasta || null);
    request.input('Comprobada', sql.TinyInt, filtros.comprobada != null ? (filtros.comprobada ? 1 : 0) : null);
    request.input('FechaComprobacionDesde', sql.SmallDateTime, filtros.fechaComprobacionDesde || null);
    request.input('FechaComprobacionHasta', sql.SmallDateTime, filtros.fechaComprobacionHasta || null);
    request.input('ConTiempos', sql.TinyInt, filtros.conTiempos != null ? (filtros.conTiempos ? 1 : 0) : null);
    request.input('FechaTiemposDesde', sql.SmallDateTime, filtros.fechaTiemposDesde || null);
    request.input('FechaTiemposHasta', sql.SmallDateTime, filtros.fechaTiemposHasta || null);
    request.input('Descripcion', sql.VarChar(sql.MAX), filtros.descripcion || null);
    request.input('Comentario', sql.VarChar(sql.MAX), filtros.comentario || null);
    request.input('Observaciones', sql.VarChar(sql.MAX), filtros.observaciones || null);
    request.input('IdCliente', sql.Int, filtros.idCliente || null);
    request.input('CobrarAlCliente', sql.TinyInt, filtros.cobrarAlCliente != null ? (filtros.cobrarAlCliente ? 1 : 0) : null);
    request.input('IdPresupuesto', sql.Int, filtros.idPresupuesto || null);
    request.input('IdPresupuestoLinea', sql.Int, filtros.idPresupuestoLinea || null);
    request.input('DescripcionPresupuesto', sql.VarChar(sql.MAX), filtros.descripcionPresupuesto || null);
    request.input('DescripcionLineaPresupuesto', sql.VarChar(sql.MAX), filtros.descripcionLineaPresupuesto || null);
    request.input('Albaraneada', sql.TinyInt, filtros.albaraneada != null ? (filtros.albaraneada ? 1 : 0) : null);
    request.input('IdAlbaran', sql.Int, filtros.idAlbaran || null);
    request.input('DescripcionLineaAlbaran', sql.VarChar(sql.MAX), filtros.descripcionLineaAlbaran || null);
    request.input('IdFacturaCliente', sql.Int, filtros.idFacturaCliente || null);
    request.input('DescripcionLineaFactura', sql.VarChar(sql.MAX), filtros.descripcionLineaFactura || null);
    request.input('CadenaIdsTareaExcluir', sql.VarChar(sql.MAX), filtros.cadenaExcluir || null);
    request.input('IdSociedad', sql.Int, filtros.idSociedad || null);
    request.input('IdsPresupuesto', sql.VarChar(sql.MAX), filtros.idsPresupuesto || null);
    request.input('IdPersonalDepartamentoAsignado', sql.Int, filtros.idDepartamentoAsignado || null);
    request.input('IdPersonalDepartamentoCreador', sql.Int, filtros.idDepartamentoCreador || null);
    request.input('Publicada', sql.TinyInt, filtros.publicada != null ? (filtros.publicada ? 1 : 0) : null);

    const result = await request.query(`
      SET DATEFORMAT dmy;
      EXEC up_bp_Tareas_Select
        @IdTarea                       = @IdTarea,
        @IdPersonalCreador             = @IdPersonalCreador,
        @IdPersonalAsignado            = @IdPersonalAsignado,
        @CadenaIdsTareaTipo            = @CadenaIdsTareaTipo,
        @CadenaIdsTareaEstado          = @CadenaIdsTareaEstado,
        @FechaCreacionDesde            = @FechaCreacionDesde,
        @FechaCreacionHasta            = @FechaCreacionHasta,
        @ConFechaPrevistaEntrega       = @ConFechaPrevistaEntrega,
        @FechaPrevistaEntregaDesde     = @FechaPrevistaEntregaDesde,
        @FechaPrevistaEntregaHasta     = @FechaPrevistaEntregaHasta,
        @Iniciada                      = @Iniciada,
        @FechaInicioDesde              = @FechaInicioDesde,
        @FechaInicioHasta              = @FechaInicioHasta,
        @Finalizada                    = @Finalizada,
        @FechaFinDesde                 = @FechaFinDesde,
        @FechaFinHasta                 = @FechaFinHasta,
        @Comprobada                    = @Comprobada,
        @FechaComprobacionDesde        = @FechaComprobacionDesde,
        @FechaComprobacionHasta        = @FechaComprobacionHasta,
        @ConTiempos                    = @ConTiempos,
        @FechaTiemposDesde             = @FechaTiemposDesde,
        @FechaTiemposHasta             = @FechaTiemposHasta,
        @Descripcion                   = @Descripcion,
        @Comentario                    = @Comentario,
        @Observaciones                 = @Observaciones,
        @IdCliente                     = @IdCliente,
        @CobrarAlCliente               = @CobrarAlCliente,
        @IdPresupuesto                 = @IdPresupuesto,
        @IdPresupuestoLinea            = @IdPresupuestoLinea,
        @DescripcionPresupuesto        = @DescripcionPresupuesto,
        @DescripcionLineaPresupuesto   = @DescripcionLineaPresupuesto,
        @Albaraneada                   = @Albaraneada,
        @IdAlbaran                     = @IdAlbaran,
        @DescripcionLineaAlbaran       = @DescripcionLineaAlbaran,
        @IdFacturaCliente              = @IdFacturaCliente,
        @DescripcionLineaFactura       = @DescripcionLineaFactura,
        @CadenaIdsTareaExcluir         = @CadenaIdsTareaExcluir,
        @IdSociedad                    = @IdSociedad,
        @IdsPresupuesto                = @IdsPresupuesto,
        @IdPersonalDepartamentoAsignado= @IdPersonalDepartamentoAsignado,
        @IdPersonalDepartamentoCreador = @IdPersonalDepartamentoCreador,
        @Publicada                     = @Publicada;
    `);
    let rows = result.recordset || [];

    // Fallback defensivo: si el SP devuelve 0 registros (ocurre cuando una tarea
    // tiene IdCliente o IdTareaTipo NULL y los INNER JOIN del SP la excluyen),
    // consultamos directamente la tabla con las columnas que realmente existen.
    // IMPORTANTE: respetar filtros (p.ej. IdPersonalAsignado) para no devolver
    // tareas de otros usuarios.
    if (rows.length === 0) {
      try {
        const req = pool.request()
          .input('IdPersonalAsignado', sql.Int, filtros.idPersonalAsignado || null)
          .input('IdPersonalCreador', sql.Int, filtros.idPersonalCreador || null)
          .input('Descripcion', sql.VarChar(sql.MAX), filtros.descripcion || null)
          .input('Comentario', sql.VarChar(sql.MAX), filtros.comentario || null)
          .input('Observaciones', sql.VarChar(sql.MAX), filtros.observaciones || null);

        const fallback = await req.query(`
          SELECT
              IdTarea,
              Descripcion,
              CAST('' AS varchar(200)) AS PersonalCreador,
              CAST('' AS varchar(200)) AS PersonalAsignado,
              idPersonal_Crea  AS IdPersonalCreador,
              idPersonal_Asigna AS IdPersonalAsignado,
              CAST('' AS varchar(200)) AS Cliente,
              idCliente        AS IdCliente,
              CAST('' AS varchar(200)) AS Presupuesto,
              idPresupuesto    AS IdPresupuesto,
              CAST('' AS varchar(200)) AS PresupuestoLinea,
              idPresupuestoLinea AS IdPresupuestoLinea,
              (
                SELECT ISNULL(SUM(Horas), 0) FROM dbo.TareasTiempos WHERE IdTarea = dbo.Tareas.IdTarea
              ) AS HorasReales,
              HorasEstimadas,
            CAST('' AS varchar(100)) AS TipoTarea,
            idTareaTipo      AS IdTareaTipo,
            Fecha            AS FechaCreacion,
            FechaPrevistaEntrega AS FechaPreviewEntrega,
            FechaPrevistaEntrega AS FechaPrevistaEntrega,
            FIniciada        AS FechaInicio,
            FRealizada       AS FechaFin,
            FComprobada      AS FechaComprobacion,
            FechaEnESpera    AS FechaEnEspera,
            CASE WHEN FComprobada IS NOT NULL THEN 'Comprobada'
                 WHEN FRealizada  IS NOT NULL THEN 'Realizada'
                 WHEN FIniciada   IS NOT NULL THEN 'Iniciada'
                 ELSE 'Asignada'
            END AS Estado,
            Prioridad,
            'No'             AS Albaraneado,
            Comentario,
            Observaciones,
            CarpetaTrabajo
          FROM dbo.Tareas
          WHERE (@IdPersonalAsignado IS NULL OR idPersonal_Asigna = @IdPersonalAsignado)
            AND (@IdPersonalCreador IS NULL OR idPersonal_Crea = @IdPersonalCreador)
            AND (@Descripcion IS NULL OR Descripcion LIKE @Descripcion)
            AND (@Comentario IS NULL OR Comentario LIKE @Comentario)
            AND (@Observaciones IS NULL OR Observaciones LIKE @Observaciones)
          ORDER BY IdTarea DESC
        `);

        const fallbackRows = fallback.recordset || [];
        if (fallbackRows.length > 0) {
          console.warn('[WARN] up_bp_Tareas_Select devolvió 0 registros. Usando fallback directo de Tareas (filtrado).');
          rows = fallbackRows;
        }
      } catch (e) {
        console.warn('[WARN] Fallback Tareas falló:', e.message);
      }
    }

    return rows;
  }

  async getById(id) {
    const pool = await getPool();
    const request = pool.request();

    request.input('IdTarea', sql.Int, id);
    request.input('IdPersonalCreador', sql.Int, null);
    request.input('IdPersonalAsignado', sql.Int, null);
    request.input('CadenaIdsTareaTipo', sql.VarChar(sql.MAX), null);
    request.input('CadenaIdsTareaEstado', sql.VarChar(sql.MAX), null);
    request.input('FechaCreacionDesde', sql.SmallDateTime, null);
    request.input('FechaCreacionHasta', sql.SmallDateTime, null);
    request.input('ConFechaPrevistaEntrega', sql.TinyInt, null);
    request.input('FechaPrevistaEntregaDesde', sql.SmallDateTime, null);
    request.input('FechaPrevistaEntregaHasta', sql.SmallDateTime, null);
    request.input('Iniciada', sql.TinyInt, null);
    request.input('FechaInicioDesde', sql.SmallDateTime, null);
    request.input('FechaInicioHasta', sql.SmallDateTime, null);
    request.input('Finalizada', sql.TinyInt, null);
    request.input('FechaFinDesde', sql.SmallDateTime, null);
    request.input('FechaFinHasta', sql.SmallDateTime, null);
    request.input('Comprobada', sql.TinyInt, null);
    request.input('FechaComprobacionDesde', sql.SmallDateTime, null);
    request.input('FechaComprobacionHasta', sql.SmallDateTime, null);
    request.input('ConTiempos', sql.TinyInt, null);
    request.input('FechaTiemposDesde', sql.SmallDateTime, null);
    request.input('FechaTiemposHasta', sql.SmallDateTime, null);
    request.input('Descripcion', sql.NVarChar(sql.MAX), null);
    request.input('Comentario', sql.NVarChar(sql.MAX), null);
    request.input('Observaciones', sql.NVarChar(sql.MAX), null);
    request.input('IdCliente', sql.Int, null);
    request.input('CobrarAlCliente', sql.TinyInt, null);
    request.input('IdPresupuesto', sql.Int, null);
    request.input('IdPresupuestoLinea', sql.Int, null);
    request.input('DescripcionPresupuesto', sql.NVarChar(sql.MAX), null);
    request.input('DescripcionLineaPresupuesto', sql.NVarChar(sql.MAX), null);
    request.input('Albaraneada', sql.TinyInt, null);
    request.input('IdAlbaran', sql.Int, null);
    request.input('DescripcionLineaAlbaran', sql.VarChar(sql.MAX), null);
    request.input('IdFacturaCliente', sql.Int, null);
    request.input('DescripcionLineaFactura', sql.VarChar(sql.MAX), null);
    request.input('CadenaIdsTareaExcluir', sql.VarChar(sql.MAX), null);
    request.input('IdSociedad', sql.Int, null);
    request.input('IdsPresupuesto', sql.NVarChar(sql.MAX), null);
    request.input('IdPersonalDepartamentoAsignado', sql.Int, null);
    request.input('IdPersonalDepartamentoCreador', sql.Int, null);
    request.input('Publicada', sql.TinyInt, null);

    const result = await request.query(`
      SET DATEFORMAT dmy;
      EXEC up_bp_Tareas_Select
        @IdTarea                       = @IdTarea,
        @IdPersonalCreador             = @IdPersonalCreador,
        @IdPersonalAsignado            = @IdPersonalAsignado,
        @CadenaIdsTareaTipo            = @CadenaIdsTareaTipo,
        @CadenaIdsTareaEstado          = @CadenaIdsTareaEstado,
        @FechaCreacionDesde            = @FechaCreacionDesde,
        @FechaCreacionHasta            = @FechaCreacionHasta,
        @ConFechaPrevistaEntrega       = @ConFechaPrevistaEntrega,
        @FechaPrevistaEntregaDesde     = @FechaPrevistaEntregaDesde,
        @FechaPrevistaEntregaHasta     = @FechaPrevistaEntregaHasta,
        @Iniciada                      = @Iniciada,
        @FechaInicioDesde              = @FechaInicioDesde,
        @FechaInicioHasta              = @FechaInicioHasta,
        @Finalizada                    = @Finalizada,
        @FechaFinDesde                 = @FechaFinDesde,
        @FechaFinHasta                 = @FechaFinHasta,
        @Comprobada                    = @Comprobada,
        @FechaComprobacionDesde        = @FechaComprobacionDesde,
        @FechaComprobacionHasta        = @FechaComprobacionHasta,
        @ConTiempos                    = @ConTiempos,
        @FechaTiemposDesde             = @FechaTiemposDesde,
        @FechaTiemposHasta             = @FechaTiemposHasta,
        @Descripcion                   = @Descripcion,
        @Comentario                    = @Comentario,
        @Observaciones                 = @Observaciones,
        @IdCliente                     = @IdCliente,
        @CobrarAlCliente               = @CobrarAlCliente,
        @IdPresupuesto                 = @IdPresupuesto,
        @IdPresupuestoLinea            = @IdPresupuestoLinea,
        @DescripcionPresupuesto        = @DescripcionPresupuesto,
        @DescripcionLineaPresupuesto   = @DescripcionLineaPresupuesto,
        @Albaraneada                   = @Albaraneada,
        @IdAlbaran                     = @IdAlbaran,
        @DescripcionLineaAlbaran       = @DescripcionLineaAlbaran,
        @IdFacturaCliente              = @IdFacturaCliente,
        @DescripcionLineaFactura       = @DescripcionLineaFactura,
        @CadenaIdsTareaExcluir         = @CadenaIdsTareaExcluir,
        @IdSociedad                    = @IdSociedad,
        @IdsPresupuesto                = @IdsPresupuesto,
        @IdPersonalDepartamentoAsignado= @IdPersonalDepartamentoAsignado,
        @IdPersonalDepartamentoCreador = @IdPersonalDepartamentoCreador,
        @Publicada                     = @Publicada;
    `);
    let row = result.recordset[0] || null;

    // Fallback: el SP puede devolver 0 filas si hay INNER JOINs con datos NULL.
    if (!row) {
      try {
        const fallback = await pool.request()
          .input('IdTarea', sql.Int, id)
          .query(`
            SELECT
              IdTarea,
              Descripcion,
              CAST('' AS varchar(200)) AS PersonalCreador,
              CAST('' AS varchar(200)) AS PersonalAsignado,
              idPersonal_Crea  AS IdPersonalCreador,
              idPersonal_Asigna AS IdPersonalAsignado,
              CAST('' AS varchar(200)) AS Cliente,
              idCliente        AS IdCliente,
              CAST('' AS varchar(200)) AS Presupuesto,
              idPresupuesto    AS IdPresupuesto,
              CAST('' AS varchar(200)) AS PresupuestoLinea,
              idPresupuestoLinea AS IdPresupuestoLinea,
              (
                SELECT ISNULL(SUM(Horas), 0) FROM dbo.TareasTiempos WHERE IdTarea = dbo.Tareas.IdTarea
              ) AS HorasReales,
              HorasEstimadas,
              CAST('' AS varchar(100)) AS TipoTarea,
              idTareaTipo      AS IdTareaTipo,
              Fecha            AS FechaCreacion,
              FechaPrevistaEntrega AS FechaPreviewEntrega,
              FechaPrevistaEntrega AS FechaPrevistaEntrega,
              FIniciada        AS FechaInicio,
              FRealizada       AS FechaFin,
              FComprobada      AS FechaComprobacion,
              FechaEnESpera    AS FechaEnEspera,
              CASE WHEN FComprobada IS NOT NULL THEN 'Comprobada'
                   WHEN FRealizada  IS NOT NULL THEN 'Realizada'
                   WHEN FIniciada   IS NOT NULL THEN 'Iniciada'
                   ELSE 'Asignada'
              END AS Estado,
              Prioridad,
              'No'             AS Albaraneado,
              Comentario,
              Observaciones,
              CarpetaTrabajo
            FROM dbo.Tareas
            WHERE IdTarea = @IdTarea
          `);
        row = fallback.recordset[0] || null;
        if (row) {
          console.warn('[WARN] up_bp_Tareas_Select devolvió 0 filas en getById. Usando fallback directo de Tareas.');
        }
      } catch (e) {
        console.warn('[WARN] Fallback getById falló:', e.message);
      }
    }

    return row;
  }

  /**
   * Obtiene los registros de tiempo de una tarea.
   */
  async getTiempos(idTarea) {
    const pool = await getPool();
    const result = await pool.request()
      .input('idTarea', sql.Int, idTarea)
      .query(`
        SELECT
          IdTareaTiempo,
          IdTarea,
          CONVERT(varchar(10), Fecha, 23) AS Fecha,
          Horas,
          Comentario,
          IdIdentidad
        FROM TareasTiempos
        WHERE IdTarea = @idTarea
        ORDER BY Fecha DESC
      `);
    return result.recordset;
  }

  async getTiempoById(idTareaTiempo) {
    const pool = await getPool();
    const result = await pool.request()
      .input('idTareaTiempo', sql.Int, idTareaTiempo)
      .query(`
        SELECT IdTareaTiempo, IdTarea,
               CONVERT(varchar(10), Fecha, 23) AS Fecha,
               Horas, Comentario, IdIdentidad
        FROM TareasTiempos
        WHERE IdTareaTiempo = @idTareaTiempo
      `);
    return result.recordset[0] || null;
  }

  async updateTiempo({ idTareaTiempo, fecha, horas, comentario, idIdentidad }) {
    const pool = await getPool();
    await pool.request()
      .input('idTareaTiempo', sql.Int, idTareaTiempo)
      .input('Fecha', sql.SmallDateTime, this._toDateOrNull(fecha))
      .input('Horas', sql.Decimal(12, 2), horas)
      .input('Comentario', sql.VarChar(sql.MAX), comentario || '')
      .input('IdIdentidad', sql.Int, idIdentidad || null)
      .query(`
        SET DATEFORMAT dmy;
        UPDATE TareasTiempos SET
          Fecha = @Fecha,
          Horas = @Horas,
          Comentario = @Comentario,
          IdIdentidad = COALESCE(@IdIdentidad, IdIdentidad)
        WHERE IdTareaTiempo = @idTareaTiempo
      `);
  }

  async deleteTiempo(idTareaTiempo) {
    const pool = await getPool();
    await pool.request()
      .input('idTareaTiempo', sql.Int, idTareaTiempo)
      .query('DELETE FROM TareasTiempos WHERE IdTareaTiempo = @idTareaTiempo');
  }

  /**
   * Devuelve listado de tiempos (una fila por registro en TareasTiempos)
   * con datos básicos de la tarea y del responsable asignado.
   */
  async getTiemposListado(filtros = {}) {
    const pool = await getPool();
    const request = pool.request();

    request.input('IdTarea', sql.Int, filtros.idTarea || null);
    request.input('IdPersonalAsignado', sql.Int, filtros.idPersonalAsignado || null);
    request.input('FechaDesde', sql.SmallDateTime, this._toDateOrNull(filtros.fechaDesde));
    request.input('FechaHasta', sql.SmallDateTime, this._toDateOrNull(filtros.fechaHasta));
    request.input('IdSociedad', sql.Int, filtros.idSociedad || null);

    const result = await request.query(`
      SET DATEFORMAT dmy;
      SELECT
        tt.IdTareaTiempo,
        t.IdTarea,
        CONVERT(varchar(10), tt.Fecha, 23) AS Fecha,
        tt.Horas,
        t.HorasEstimadas,
        t.Descripcion,
        t.Comentario,
        t.idPersonal_Asigna AS IdPersonalAsignado,
        t.idPresupuesto AS IdPresupuesto,
        CAST(t.idPresupuesto AS varchar(50)) AS Presupuesto,
        t.idCliente AS IdCliente,
        cli.NombreComercial AS Cliente
      FROM dbo.TareasTiempos tt
      INNER JOIN dbo.Tareas t ON t.IdTarea = tt.IdTarea
      LEFT JOIN dbo.gf_Clientes cli ON cli.IdCliente = t.idCliente
      WHERE (@IdTarea IS NULL OR t.IdTarea = @IdTarea)
        AND (@IdPersonalAsignado IS NULL OR t.idPersonal_Asigna = @IdPersonalAsignado)
        AND (@FechaDesde IS NULL OR tt.Fecha >= @FechaDesde)
        AND (@FechaHasta IS NULL OR tt.Fecha <= @FechaHasta)
        AND (@IdSociedad IS NULL OR t.IdSociedad = @IdSociedad)
      ORDER BY tt.Fecha DESC, tt.IdTareaTiempo DESC
    `);

    return result.recordset || [];
  }

  /**
   * Registra horas trabajadas llamando al SP up_bp_TareasTiempos_Insert.
   */
  async registrarTiempo({ idTarea, fecha, horas, comentario, idIdentidad }) {
    const pool = await getPool();
    console.log('[DEBUG] TareaModel.registrarTiempo params', { idTarea, fecha, horas, comentario, idIdentidad });
    const result = await pool.request()
      .input('IdTarea', sql.Int, idTarea)
      .input('Fecha', sql.SmallDateTime, this._toDateOrNull(fecha))
      .input('Horas', sql.Decimal(12, 2), horas)
      .input('Comentario', sql.VarChar(sql.MAX), comentario || '')
      .input('IdIdentidad', sql.Int, idIdentidad || null)
      .query(`
        SET DATEFORMAT dmy;
        DECLARE @IdTareaTiempo INT = 0, @IdTiempo INT = 0;
        EXEC up_bp_TareasTiempos_Insert
          @IdTareaTiempo = @IdTareaTiempo OUTPUT,
          @IdTarea       = @IdTarea,
          @Fecha         = @Fecha,
          @Horas         = @Horas,
          @Comentario    = @Comentario,
          @IdIdentidad   = @IdIdentidad,
          @IdTiempo      = @IdTiempo OUTPUT;
        SELECT @IdTareaTiempo AS IdTareaTiempo, @IdTiempo AS IdTiempo;
      `);
    console.log('[DEBUG] TareaModel.registrarTiempo result', result && result.recordset ? result.recordset[0] : null);
    return result.recordset[0];
  }

  /**
   * Devuelve la suma real de horas desde TareasTiempos.
   * NOTA: Tareas NO tiene columna HorasReales — el valor real es siempre
   * un SUM en vivo sobre TareasTiempos.
   */
  async sumarHorasReales(idTarea) {
    const pool = await getPool();
    const result = await pool.request()
      .input('IdTarea', sql.Int, idTarea)
      .query('SELECT ISNULL(SUM(horas), 0) AS HorasReales FROM dbo.TareasTiempos WHERE idTarea = @IdTarea');
    return Number(result.recordset[0].HorasReales || 0);
  }

  /**
   * Calcula la prioridad siguiente para un responsable (idPersonal_Asigna).
   * Regla: prioridad = MAX(prioridad) + 1 (sin duplicados).
   * Solo lectura (MAX en Tareas).
   */
  async getNextPrioridadForAsignado(idPersonalAsigna, idSociedad = null) {
    if (!idPersonalAsigna) return null;
    const pool = await getPool();
    const req = pool.request()
      .input('IdPersonalAsignado', sql.Int, idPersonalAsigna)
      .input('IdSociedad', sql.Int, idSociedad || null);

    const result = await req.query(`
      SELECT ISNULL(MAX(Prioridad), 0) AS MaxPrioridad
      FROM dbo.Tareas
      WHERE idPersonal_Asigna = @IdPersonalAsignado
        -- AND (@IdSociedad IS NULL OR IdSociedad = @IdSociedad) -- Comentado para que sea global por empleado
    `);
    const max = Number(result.recordset[0]?.MaxPrioridad || 0);
    return max + 1;
  }

  /**
   * Reordena prioridades para evitar duplicados al modificar una tarea.
   * Regla: mueve las tareas entre el rango afectado para mantener unicidad.
   */
  async reordenarPrioridades({ idTarea, idPersonalAsigna, prioridadNueva, idSociedad = null }) {
    if (!idTarea || !idPersonalAsigna) return;
    const nueva = Number(prioridadNueva);
    if (!Number.isFinite(nueva) || nueva < 1) return;

    const pool = await getPool();
    const tx = new sql.Transaction(pool);
    await tx.begin();

    try {
      const r1 = new sql.Request(tx)
        .input('IdTarea', sql.Int, idTarea)
        .query('SELECT Prioridad FROM dbo.Tareas WHERE IdTarea = @IdTarea');

      const currentRes = await r1;
      const actual = Number(currentRes.recordset[0]?.Prioridad);

      // Si no tiene prioridad (NULL), forzamos un recálculo completo después de este paso
      if (!Number.isFinite(actual)) {
        await tx.commit();
        await this.recalcularPrioridadesParaAsignado(idPersonalAsigna, idSociedad);
        return;
      }

      if (actual === nueva) {
        await tx.commit();
        // Aun así, por seguridad, si detectamos que hay duplicados, recalculamos
        return;
      }

      const req = new sql.Request(tx)
        .input('IdTarea', sql.Int, idTarea)
        .input('IdPersonalAsignado', sql.Int, idPersonalAsigna)
        .input('IdSociedad', sql.Int, idSociedad || null)
        .input('PrioridadNueva', sql.Int, nueva)
        .input('PrioridadActual', sql.Int, actual);

      if (nueva < actual) {
        await req.query(`
          UPDATE dbo.Tareas
          SET Prioridad = Prioridad + 1
          WHERE idPersonal_Asigna = @IdPersonalAsignado
            -- AND (@IdSociedad IS NULL OR IdSociedad = @IdSociedad)
            AND IdTarea <> @IdTarea
            AND Prioridad >= @PrioridadNueva
            AND Prioridad < @PrioridadActual
        `);
      } else {
        await req.query(`
          UPDATE dbo.Tareas
          SET Prioridad = Prioridad - 1
          WHERE idPersonal_Asigna = @IdPersonalAsignado
            -- AND (@IdSociedad IS NULL OR IdSociedad = @IdSociedad)
            AND IdTarea <> @IdTarea
            AND Prioridad <= @PrioridadNueva
            AND Prioridad > @PrioridadActual
        `);
      }

      await tx.commit();
    } catch (err) {
      try { await tx.rollback(); } catch {}
      throw err;
    }
  }

  /**
   * Fuerza un recálculo completo de prioridades para un responsable.
   * Útil para corregir situaciones en las que hay duplicados o NULLs.
   */
  async recalcularPrioridadesParaAsignado(idPersonalAsigna, idSociedad = null) {
    if (!idPersonalAsigna) return;
    const pool = await getPool();
    const req = pool.request()
      .input('IdPersonalAsignado', sql.Int, idPersonalAsigna)
      .input('IdSociedad', sql.Int, idSociedad || null);

    // Recalcular prioridades de forma determinista: NULLs al final, ordenar por Prioridad e IdTarea
    // Filtramos tareas activas (sin FRealizada/FComprobada o con fecha en el futuro)
    await req.query(`
      -- Primero, asignamos prioridades correlativas a todas las tareas activas
      UPDATE dbo.Tareas SET Prioridad = vw.PrioridadRecalculada
      FROM dbo.Tareas t
      INNER JOIN (
        SELECT ta.IdTarea,
               ROW_NUMBER() OVER (ORDER BY ISNULL(ta.Prioridad, 999999), ta.IdTarea) AS PrioridadRecalculada
        FROM dbo.Tareas ta
        WHERE ta.IdPersonal_Asigna = @IdPersonalAsignado
          AND (ta.FRealizada IS NULL OR CAST(ta.FRealizada AS DATE) > CAST(GETDATE() AS DATE))
          AND (ta.FComprobada IS NULL OR CAST(ta.FComprobada AS DATE) > CAST(GETDATE() AS DATE))
      ) vw ON vw.IdTarea = t.IdTarea;

      -- Segundo, nos aseguramos de que las terminadas NO tengan prioridad
      UPDATE dbo.Tareas SET Prioridad = NULL 
      WHERE IdPersonal_Asigna = @IdPersonalAsignado 
        AND (
          (FRealizada IS NOT NULL AND CAST(FRealizada AS DATE) <= CAST(GETDATE() AS DATE)) OR 
          (FComprobada IS NOT NULL AND CAST(FComprobada AS DATE) <= CAST(GETDATE() AS DATE))
        )
        AND Prioridad IS NOT NULL;
    `);
  }

  /**
   * Devuelve un mapa { IdTarea: HorasReales } para un conjunto de tareas.
   * Solo lectura (SUM en TareasTiempos).
   */
  async getHorasRealesByTareas(ids = []) {
    const idsInt = (Array.isArray(ids) ? ids : [])
      .map(n => Number(n))
      .filter(n => Number.isFinite(n));

    if (idsInt.length === 0) return {};

    const pool = await getPool();
    const req = pool.request();
    const params = idsInt.map((id, i) => {
      const key = 'Id' + i;
      req.input(key, sql.Int, id);
      return '@' + key;
    });

    const result = await req.query(`
      SELECT IdTarea, ISNULL(SUM(Horas), 0) AS HorasReales
      FROM dbo.TareasTiempos
      WHERE IdTarea IN (${params.join(',')})
      GROUP BY IdTarea
    `);

    const map = {};
    (result.recordset || []).forEach(r => {
      map[r.IdTarea] = Number(r.HorasReales || 0);
    });
    return map;
  }

  /**
   * Crea una tarea llamando al SP up_bp_Tareas_Insert.
   *
   * IMPORTANTE — por qué usamos un batch con SET DATEFORMAT dmy:
   * El SP internamente ejecuta CAST(CONVERT(VARCHAR, @Fecha, 103) AS SMALLDATETIME).
   * El formato 103 produce 'dd/mm/yyyy'. Si el servidor SQL tiene DATEFORMAT=mdy
   * (valor por defecto en instalaciones en inglés), ese CAST falla porque interpreta
   * el día como mes (ej. mes 16). Ejecutar SET DATEFORMAT dmy en el mismo batch
   * garantiza que la conversión funcione independientemente de la configuración del servidor.
   */
  async create(tarea) {
    const pool = await getPool();

    const result = await pool.request()
      .input('IdPersonalCreador',      sql.Int,           tarea.idPersonalCrea        || null)
      .input('IdPersonalAsignado',     sql.Int,           tarea.idPersonalAsigna      || null)
      .input('IdTareaTipo',            sql.Int,           tarea.idTareaTipo           || null)
      .input('FechaCreacion',          sql.SmallDateTime, this._toDateOrNull(tarea.fechaCreacion))
      .input('FechaInicio',            sql.SmallDateTime, this._toDateOrNull(tarea.fechaInicio))
      .input('FechaFin',               sql.SmallDateTime, this._toDateOrNull(tarea.fechaFin))
      .input('FechaComprobacion',      sql.SmallDateTime, this._toDateOrNull(tarea.fechaComprobacion))
      .input('FechaPrevistaEntrega',   sql.SmallDateTime, this._toDateOrNull(tarea.fechaEntrega))
      .input('FechaEnEspera',          sql.SmallDateTime, this._toDateOrNull(tarea.fechaEspera))
      .input('Descripcion',            sql.VarChar(2000), tarea.descripcion           || null)
      .input('Comentario',             sql.VarChar(2000), tarea.comentario            || null)
      .input('Observaciones',          sql.VarChar(2000), tarea.observaciones         || null)
      .input('CarpetaTrabajo',         sql.VarChar(500),  tarea.carpetaTrabajo        || null)
      .input('HorasEstimadas',         sql.Float,         tarea.horasEstimadas        || null)
      .input('IdCliente',              sql.Int,           tarea.idCliente             || null)
      .input('CobrarAlCliente',        sql.TinyInt,       tarea.cobrarAlCliente       ? 1 : 0)
      .input('IdPresupuesto',          sql.Int,           tarea.idPresupuesto         || null)
      .input('IdPresupuestoLinea',     sql.Int,           tarea.idPresupuestoLinea    || null)
      .input('IdPersonalDepartamento', sql.Int,           tarea.idPersonalDepartamento|| null)
      .input('IdContacto',             sql.Int,           tarea.idContacto            || null)
      .input('IdIdentidad',            sql.Int,           tarea.idIdentidad           || null)
      .input('IdSociedad',             sql.Int,           tarea.idSociedad            || null)
      .input('IdMaquina',              sql.Int,           tarea.idMaquina             || null)
      .input('Prioridad', sql.Int, (tarea.prioridad != null && Number.isFinite(Number(tarea.prioridad))) ? Number(tarea.prioridad) : null)
      .query(`
        SET DATEFORMAT dmy;
        DECLARE @NuevoIdTarea INT;
        EXEC up_bp_Tareas_Insert
          @IdTarea              = @NuevoIdTarea          OUTPUT,
          @IdPersonalCreador    = @IdPersonalCreador,
          @IdPersonalAsignado   = @IdPersonalAsignado,
          @IdTareaTipo          = @IdTareaTipo,
          @FechaCreacion        = @FechaCreacion,
          @FechaInicio          = @FechaInicio,
          @FechaFin             = @FechaFin,
          @FechaComprobacion    = @FechaComprobacion,
          @FechaPrevistaEntrega = @FechaPrevistaEntrega,
          @FechaEnEspera        = @FechaEnEspera,
          @Descripcion          = @Descripcion,
          @Comentario           = @Comentario,
          @Observaciones        = @Observaciones,
          @CarpetaTrabajo       = @CarpetaTrabajo,
          @HorasEstimadas       = @HorasEstimadas,
          @IdCliente            = @IdCliente,
          @CobrarAlCliente      = @CobrarAlCliente,
          @IdPresupuesto        = @IdPresupuesto,
          @IdPresupuestoLinea   = @IdPresupuestoLinea,
          @IdPersonalDepartamento = @IdPersonalDepartamento,
          @IdContacto           = @IdContacto,
          @IdIdentidad          = @IdIdentidad,
          @IdSociedad           = @IdSociedad,
          @IdMaquina            = @IdMaquina;
        SELECT @NuevoIdTarea AS IdTarea;
        -- Fijar Prioridad calculada (MAX+1 por asignado) si se proporcionó,
        -- evitando que el SP deje el valor por defecto de la columna (2).
        UPDATE Tareas SET
          Publicada = 1,
          Prioridad = CASE WHEN @Prioridad IS NOT NULL THEN @Prioridad ELSE Prioridad END
        WHERE IdTarea = @NuevoIdTarea;
      `);

    return result.recordset[0].IdTarea;
  }

  async update(id, tarea) {
    const pool = await getPool();
    await pool.request()
      .input('id', sql.Int, id)
      .input('idPersonalCrea', sql.Int, tarea.idPersonalCrea || null)
      .input('idPersonalAsigna', sql.Int, tarea.idPersonalAsigna || null)
      .input('fIniciada', sql.SmallDateTime, this._toDateOrNull(tarea.fechaInicio))
      .input('fRealizada', sql.SmallDateTime, this._toDateOrNull(tarea.fechaFin))
      .input('fComprobada', sql.SmallDateTime, this._toDateOrNull(tarea.fechaComprobacion))
      .input('horasEstimadas', sql.Float, tarea.horasEstimadas || 0)
      .input('descripcion', sql.VarChar(sql.MAX), tarea.descripcion)
      .input('comentario', sql.VarChar(sql.MAX), tarea.comentario || '')
      .input('observaciones', sql.VarChar(sql.MAX), tarea.observaciones || '')
      .input('idCliente', sql.Int, tarea.idCliente || null)
      .input('idPresupuesto', sql.Int, tarea.idPresupuesto || null)
      .input('idPresupuestoLinea', sql.Int, tarea.idPresupuestoLinea || null)
      .input('idTareaTipo', sql.Int, tarea.idTareaTipo || null)
      .input('prioridad', sql.Int, (tarea.prioridad != null && Number.isFinite(Number(tarea.prioridad))) ? Number(tarea.prioridad) : null)
      .input('fechaPrevistaEntrega', sql.SmallDateTime, this._toDateOrNull(tarea.fechaEntrega))
      .input('carpetaTrabajo', sql.VarChar(500), tarea.carpetaTrabajo || '')
      .input('fechaEnEspera', sql.SmallDateTime, this._toDateOrNull(tarea.fechaEspera))
      .query(`
        SET DATEFORMAT dmy;
        UPDATE Tareas SET
          idPersonal_Crea      = @idPersonalCrea,
          idPersonal_Asigna    = @idPersonalAsigna,
          FIniciada            = @fIniciada,
          FRealizada           = @fRealizada,
          FComprobada          = @fComprobada,
          HorasEstimadas       = @horasEstimadas,
          Descripcion          = @descripcion,
          Comentario           = @comentario,
          Observaciones        = @observaciones,
          idCliente            = @idCliente,
          idPresupuesto        = @idPresupuesto,
          idPresupuestoLinea   = @idPresupuestoLinea,
          idTareaTipo          = @idTareaTipo,
          Prioridad            = @prioridad,
          FechaPrevistaEntrega = @fechaPrevistaEntrega,
          CarpetaTrabajo       = @carpetaTrabajo,
          FechaEnESpera        = @fechaEnEspera
        WHERE idTarea = @id
      `);
  }

  async delete(id) {
    const pool = await getPool();
    await pool.request()
      .input('id', sql.Int, id)
      .query('EXEC up_bp_Tareas_Delete @IdTarea = @id');
  }
}

module.exports = new TareaModel();
