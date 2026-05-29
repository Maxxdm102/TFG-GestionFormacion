-- =========================================================================
-- DATABASE CREATION SCRIPT FOR TareasGForma
-- Generated automatically from w2019-sql / GestionFormacion
-- =========================================================================

CREATE DATABASE TareasGForma;
GO
USE TareasGForma;
GO

-- Table structure for dbo.gf_Clientes
CREATE TABLE dbo.gf_Clientes (
  [IdCliente] INT IDENTITY(1,1) NOT NULL,
  [IdTipoDocumento] INT NULL,
  [Documento] VARCHAR(50) NULL,
  [Nuss] VARCHAR(20) NULL,
  [RazonSocial] VARCHAR(200) NULL,
  [Direccion] VARCHAR(100) NULL,
  [CodigoPostal] VARCHAR(20) NULL,
  [Poblacion] VARCHAR(100) NULL,
  [IdProvincia] INT NULL,
  [IdPais] INT NULL,
  [NombrePersonaContacto] VARCHAR(100) NULL,
  [PrimerApellidoPersonaContacto] VARCHAR(100) NULL,
  [SegundoApellidoPersonaContacto] VARCHAR(100) NULL,
  [IdConsultor] INT NULL,
  [Observaciones] VARCHAR(MAX) NULL,
  [IdClienteBasicPyme] INT NULL,
  [UsuarioWeb] VARCHAR(50) NULL,
  [ClaveWeb] VARCHAR(50) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdSector] INT NULL,
  [IdCnae] INT NULL,
  [TelefonoFijo] VARCHAR(20) NULL,
  [TelefonoMovil] VARCHAR(20) NULL,
  [Fax] VARCHAR(20) NULL,
  [Pyme] TINYINT NULL,
  [IdTipoActividad] INT NULL,
  [IdTipoNaturalezaJuridica] INT NULL,
  [IdTipoPlantilla] INT NULL,
  [Email] VARCHAR(320) NULL,
  [IdTipoFormaPago] INT NULL,
  [CargoPersonaContacto] VARCHAR(100) NULL,
  [NombreComercial] VARCHAR(200) NULL,
  [IdPoblacion] INT NULL,
  [IdTipoOrigen] INT NULL,
  [Origen] VARCHAR(MAX) NULL,
  [EsClienteERP] TINYINT NULL DEFAULT ((0)),
  [IdConvenio] INT NULL,
  PRIMARY KEY ([IdCliente])
);
GO

-- Table structure for dbo.tiposCerrados
CREATE TABLE dbo.tiposCerrados (
  [IdTipo] INT NOT NULL,
  [IdTipoDefinicion] INT NOT NULL,
  [Nombre] VARCHAR(100) NOT NULL,
  [Descripcion] VARCHAR(100) NULL,
  [Bloqueado] TINYINT NOT NULL DEFAULT ((0)),
  [Visible] TINYINT NOT NULL DEFAULT ((0)),
  [Orden] INT NOT NULL DEFAULT ((0)),
  [IdTipoPadre] INT NULL,
  [PermiteSubtipo] TINYINT NOT NULL DEFAULT ((0)),
  [Tag] VARCHAR(MAX) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [PorDefecto] TINYINT NULL DEFAULT ((0)),
  PRIMARY KEY ([IdTipo])
);
GO

-- Table structure for dbo.Paises
CREATE TABLE dbo.Paises (
  [IdPais] INT IDENTITY(1,1) NOT NULL,
  [Nombre] VARCHAR(50) NOT NULL,
  [Prefijo] VARCHAR(50) NULL,
  [Codigo] VARCHAR(20) NULL,
  [Observaciones] VARCHAR(250) NULL,
  [ISO2] VARCHAR(50) NULL,
  [ISO3] VARCHAR(50) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [Activo] TINYINT NOT NULL DEFAULT ((1)),
  [IdMaestro] INT NULL,
  [CodigoFOCVSValencia] VARCHAR(25) NULL,
  PRIMARY KEY ([IdPais])
);
GO

-- Table structure for dbo.Provincias
CREATE TABLE dbo.Provincias (
  [IdProvincia] INT IDENTITY(1,1) NOT NULL,
  [Nombre] VARCHAR(50) NOT NULL,
  [Prefijo] VARCHAR(50) NULL,
  [Codigo] VARCHAR(20) NULL,
  [Observaciones] VARCHAR(250) NULL,
  [IdComunidad] INT NULL,
  [IdPais] INT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [NombreProvincia_XML_FTFE] VARCHAR(50) NULL,
  [IdMaestro] INT NULL,
  PRIMARY KEY ([IdProvincia])
);
GO

-- Table structure for dbo.Contactos
CREATE TABLE dbo.Contactos (
  [IdContacto] INT IDENTITY(1,1) NOT NULL,
  [IdContactoClasificacion] INT NULL,
  [IdTipoContacto] INT NULL,
  [Fecha] SMALLDATETIME NULL,
  [PersonaContactada] VARCHAR(200) NULL,
  [Rellamada] TINYINT NULL,
  [Observaciones] VARCHAR(MAX) NULL,
  [PlanificadoRealizado] TINYINT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdPersonaContacto] INT NULL,
  [FechaFin] SMALLDATETIME NULL,
  [IdTipoEstado] INT NULL,
  [IdContactoTipificacionLlamada] INT NULL,
  [IdLlamadaCentralita] INT NULL,
  [IdContactoTipoHorarioPreferencia] INT NULL,
  PRIMARY KEY ([IdContacto])
);
GO

-- Table structure for dbo.Presupuestos
CREATE TABLE dbo.Presupuestos (
  [idPresupuesto] INT IDENTITY(1,1) NOT NULL,
  [NumPresupuesto] VARCHAR(50) NULL,
  [Version] VARCHAR(50) NULL,
  [Fecha] SMALLDATETIME NULL,
  [idCliente] INT NULL,
  [FechaLimite] SMALLDATETIME NULL,
  [Descripcion] VARCHAR(250) NULL,
  [Estado] TINYINT NULL,
  [FechaPreparacion] SMALLDATETIME NULL,
  [FechaEnviado] SMALLDATETIME NULL,
  [FechaAceptado] SMALLDATETIME NULL,
  [FechaRechazado] SMALLDATETIME NULL,
  [FechaPendiente] SMALLDATETIME NULL,
  [idSociedad] INT NULL,
  [Total_Coste_PrevistoELIMINAR] MONEY NOT NULL DEFAULT ((0)),
  [Total_Coste_RealELIMINAR] MONEY NOT NULL DEFAULT ((0)),
  [TipoCreacion_ELIMINAR] INT NOT NULL DEFAULT ((0)),
  [FechaEnProduccion] SMALLDATETIME NULL,
  [FechaPendienteFacturacion] SMALLDATETIME NULL,
  [idPresupuestoTipo] INT NULL,
  [ImporteCostesPrevistosPersonal] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [TotalCostesPrevistosPersonal] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [TotalCostesPrevistosProveedores] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [TotalCostesPrevistosOtrosCostes] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [ImporteCostesRealesPersonal] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [TotalCostesRealesPersonal] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [TotalCostesRealesProveedores] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [TotalCostesRealesOtrosCostes] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [PorcentajeCosteEstructural] DECIMAL(10, 2) NULL,
  [MostrarTareasCostesPrevistosPersonal] TINYINT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdPersonaContacto] INT NULL,
  [Email] VARCHAR(320) NULL,
  [IdTipoPeriodoFacturacionPeriodica] INT NULL,
  [IdAlmacen] INT NULL,
  [IdMonedaCliente] INT NULL,
  [IdMonedaSociedad] INT NULL,
  [FactorConversionMonedaSociedad] MONEY NULL,
  [FactorConversionMonedaCliente] MONEY NULL,
  [IdEstadoDocumento] INT NULL,
  [IdDireccionEnvio] INT NULL,
  [TipoOrigenDireccionEnvio] TINYINT NULL,
  [NombreDireccionEnvio] VARCHAR(200) NULL,
  [Direccion] VARCHAR(100) NULL,
  [Poblacion] VARCHAR(100) NULL,
  [CodigoPostal] VARCHAR(20) NULL,
  [IdProvincia] INT NULL,
  [IdPais] INT NULL,
  [Telefono] VARCHAR(20) NULL,
  [Fax] VARCHAR(20) NULL,
  [Horario] VARCHAR(MAX) NULL,
  [PersonaContacto] VARCHAR(200) NULL,
  [Observaciones] VARCHAR(MAX) NULL,
  [Latitud] VARCHAR(50) NULL,
  [Longitud] VARCHAR(50) NULL,
  [IdProveedorPortes] INT NULL,
  [NumeroBultos] VARCHAR(50) NULL,
  [IdIdentidadInsert] INT NULL,
  [FechaInsert] SMALLDATETIME NULL,
  [DesdePedidos] TINYINT NULL,
  [IdComercial] INT NULL,
  [Servido] TINYINT NULL,
  [IdFormaPago] INT NULL,
  [DescPago] FLOAT NULL,
  [DescCantidad] FLOAT NULL,
  [OtrosDesc] FLOAT NULL,
  [NombreFiscalCliente] VARCHAR(150) NULL,
  [NombreComercialCliente] VARCHAR(150) NULL,
  [IdTipoCif] INT NULL,
  [Cif] VARCHAR(20) NULL,
  [ObservacionesDocumentosVenta] VARCHAR(MAX) NULL,
  [IdProyecto] INT NULL,
  [IdProyectoTarea] INT NULL,
  [IdTipoTarifa] INT NULL,
  [IdTesoreria] INT NULL,
  [PortesPagados] TINYINT NULL,
  [Referencia] VARCHAR(50) NULL,
  [DescuentoCascada] TINYINT NULL,
  [IdSerie] INT NULL,
  [NumeroSerie] INT NULL,
  [Puntos] FLOAT NULL,
  [ConRecargoEquivalencia] TINYINT NULL,
  [IdClienteContado] INT NULL,
  [IdCentroTrabajo] INT NULL,
  [Referencia2] VARCHAR(50) NULL,
  [IdPedidoPrestashop] INT NULL,
  [IdTipoRuta] INT NULL,
  PRIMARY KEY ([idPresupuesto])
);
GO

-- Table structure for dbo.Presupuestos_Lineas
CREATE TABLE dbo.Presupuestos_Lineas (
  [idPresupuestoLinea] INT IDENTITY(1,1) NOT NULL,
  [idPresupuesto] INT NULL,
  [Cantidad] FLOAT NULL,
  [idUnidadMedida] INT NULL,
  [Precio] MONEY NULL,
  [Descuento] FLOAT NULL,
  [Descripcion] VARCHAR(2000) NULL,
  [idArticulo] INT NULL,
  [NumOrden] INT NULL,
  [Precio_CostesPrevELIMINAR] MONEY NOT NULL DEFAULT ((0)),
  [Desc_CostesPrevELIMINAR] FLOAT NOT NULL DEFAULT ((0)),
  [idmantenimientocliente] INT NULL,
  [idProveedor] INT NULL,
  [RequiereTarea] TINYINT NOT NULL DEFAULT ((1)),
  [CarpetaTrabajo] VARCHAR(500) NULL,
  [RequierePedido] TINYINT NOT NULL DEFAULT ((0)),
  [FechaPedido] SMALLDATETIME NULL,
  [FechaEntrega] SMALLDATETIME NULL,
  [Entregado] TINYINT NOT NULL DEFAULT ((0)),
  [IdFacturacionPeriodica] INT NULL,
  [IdArticuloReferencia] INT NULL,
  [FactorConversionRespectoPrimeraUnidad] FLOAT NULL DEFAULT ((1)),
  [Importe] MONEY NULL,
  [Codigo] VARCHAR(50) NULL,
  [IdArticuloAtributoConjunto] INT NULL,
  [ArticuloEspecial] TINYINT NULL,
  [CantidadCliente] FLOAT NULL,
  [idUnidadMedidaCliente] INT NULL,
  [FactorConversionUnidad] FLOAT NULL,
  [PrecioCliente] MONEY NULL,
  [Observaciones] VARCHAR(MAX) NULL,
  [IdTarifaLineaComision] INT NULL,
  [Comision] FLOAT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdIdentidadInsert] INT NULL,
  [FechaInsert] SMALLDATETIME NULL,
  [IdPresupuestoLineaOnix] INT NULL,
  [ConceptoFacturacion] VARCHAR(2000) NULL,
  [TipoDescuento1] TINYINT NULL,
  [TipoDescuento2] TINYINT NULL,
  [Porc_Descuento1] FLOAT NULL,
  [Porc_Descuento2] FLOAT NULL,
  [TipoBase] TINYINT NULL,
  [IdIva] INT NULL,
  [IdRetencion] INT NULL,
  [Porc_Iva] FLOAT NULL,
  [Porc_Recargo] FLOAT NULL,
  [Porc_Retencion] FLOAT NULL,
  [CosteModificado] TINYINT NULL,
  [Coste] FLOAT NULL,
  [Puntos] FLOAT NULL,
  [DescuentoPuntos] FLOAT NULL,
  PRIMARY KEY ([idPresupuestoLinea])
);
GO

-- Table LineasPresupuesto was not found in the source database.

-- Table structure for dbo.UnidadesMedida
CREATE TABLE dbo.UnidadesMedida (
  [IdUnidadMedida] INT IDENTITY(1,1) NOT NULL,
  [Nombre] VARCHAR(100) NULL,
  [Simbolo] VARCHAR(10) NULL,
  [IdTipo] INT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] DATETIME NULL,
  [IdUnidadMedidaFranquicia] INT NULL,
  [PorDefecto] TINYINT NULL,
  PRIMARY KEY ([IdUnidadMedida])
);
GO

-- Table structure for dbo.gf_Proveedores
CREATE TABLE dbo.gf_Proveedores (
  [IdProveedor] INT IDENTITY(1,1) NOT NULL,
  [IdTipoDocumento] INT NOT NULL,
  [Documento] VARCHAR(50) NULL,
  [IdTipo] INT NULL,
  [RazonSocial] VARCHAR(200) NOT NULL,
  [NombreComercial] VARCHAR(200) NULL,
  [PersonaContacto] VARCHAR(100) NULL,
  [Responsable] VARCHAR(100) NULL,
  [Direccion] VARCHAR(200) NULL,
  [IdPais] INT NOT NULL,
  [CodigoPostal] VARCHAR(50) NULL,
  [IdProvincia] INT NULL,
  [Poblacion] VARCHAR(100) NULL,
  [Observaciones] VARCHAR(MAX) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  PRIMARY KEY ([IdProveedor])
);
GO

-- Table structure for dbo.Tareas
CREATE TABLE dbo.Tareas (
  [idTarea] INT IDENTITY(1,1) NOT NULL,
  [idPersonal_Crea] INT NULL,
  [idPersonal_Asigna] INT NULL,
  [Fecha] SMALLDATETIME NULL,
  [FIniciada] SMALLDATETIME NULL,
  [FRealizada] SMALLDATETIME NULL,
  [FComprobada] SMALLDATETIME NULL,
  [HorasEstimadas] FLOAT NULL,
  [Descripcion] VARCHAR(2000) NULL,
  [Comentario] VARCHAR(2000) NULL,
  [idCliente] INT NULL,
  [idPresupuesto] INT NULL,
  [idPersonalDepartamento] INT NULL,
  [idTareaTipo] INT NULL,
  [Cobrar] TINYINT NULL DEFAULT ((0)),
  [idPresupuestoLinea] INT NULL,
  [Prioridad] INT NULL,
  [Coste] MONEY NULL,
  [NombreSolicitante] VARCHAR(300) NULL,
  [EmailSolicitante] VARCHAR(320) NULL,
  [ExtensionSolicitante] VARCHAR(50) NULL,
  [DepartamentoSolicitante] VARCHAR(200) NULL,
  [FechaPrevistaEntrega] SMALLDATETIME NULL,
  [CarpetaTrabajo] VARCHAR(500) NULL,
  [Observaciones] VARCHAR(2000) NULL,
  [FechaEnESpera] SMALLDATETIME NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] DATETIME NULL,
  [IdContacto] INT NULL,
  [IdSociedad] INT NULL,
  [IdMaquina] INT NULL,
  [Publicada] TINYINT NULL DEFAULT ((0)),
  [FInicioPlanning] SMALLDATETIME NULL,
  [FFinPlanning] SMALLDATETIME NULL,
  [AllDay] BIT NULL,
  PRIMARY KEY ([idTarea])
);
GO

-- Table structure for dbo.TareasTiempos
CREATE TABLE dbo.TareasTiempos (
  [idTareaTiempo] INT IDENTITY(1,1) NOT NULL,
  [idTarea] INT NULL,
  [Fecha] SMALLDATETIME NULL,
  [horas] FLOAT NOT NULL DEFAULT ((0)),
  [Comentario] VARCHAR(2000) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  PRIMARY KEY ([idTareaTiempo])
);
GO

-- View structure for dbo.vw_bp_Presupuestos
CREATE VIEW dbo.vw_bp_Presupuestos
AS
SELECT 
		pre.IdPresupuesto AS IdPresupuesto, 
		pre.IdSociedad,
		pre.IdCliente,
		ISNULL(cli.NombreComercial,cli.RazonSocial) AS Cliente,
		cli.Documento AS CifCliente,
		IdClienteProcedencia = NULL, --cli.IdClienteProcedencia, 
		pre.IdPresupuestoTipo,
		p_t.CodigoTipo AS CodigoTipoPresupuesto,
		pre.NumPresupuesto AS NumeroPresupuesto,
		p_t.NombreTipo,
		pre.Version AS Version,
		p_t.CodigoTipo + ' - ' + pre.NumPresupuesto AS CodigoNumeroPresupuesto, 
		pre.descripcion collate Modern_Spanish_CI_AS AS Descripcion,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(15),pre.Fecha,103)) AS Fecha,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR(15),pre.FechaLimite,103)) AS FechaEntrega, 
		pre.IdPersonaContacto,
		PersCont.Nombre + ' ' + PersCont.Apellido1 + ' ' + PersCont.Apellido2 AS NombreCompletoPersonaContacto,
		pre.Email,
		
		/*Estos estados ya no se utilizan*/
		/*pre.Estado,
		dbo.UF_DAME_ESTADOPRESUPUESTO(pre.Estado) AS NombreEstado, 

		CASE WHEN pre.estado = 0 THEN CONVERT(VARCHAR(15),pre.fechapreparacion,103)
			 WHEN pre.estado = 1 THEN CONVERT(VARCHAR(15),pre.fechaenviado,103)
			 WHEN pre.estado = 2 THEN CONVERT(VARCHAR(15),pre.fechaaceptado,103)
			 WHEN pre.estado = 3 THEN CONVERT(VARCHAR(15),pre.fecharechazado,103)
			 WHEN pre.estado = 4 THEN CONVERT(VARCHAR(15),pre.fechapendiente,103) 
			 WHEN pre.estado = 5 THEN CONVERT(VARCHAR(15),pre.FechaEnProduccion,103)
			 WHEN pre.estado = 6 THEN CONVERT(VARCHAR(15),pre.FechaPendienteFacturacion,103) 
		END  AS FechaEstado,  */

		/*Estado presupuesto*/
		CASE WHEN pre.FechaRechazado IS NOT NULL THEN	3
			 WHEN pre.FechaAceptado IS NOT NULL THEN	2
			 WHEN pre.FechaEnviado IS NOT NULL THEN		1
			 ELSE										0
		END AS IdEstadoPresupuesto,

		CASE WHEN pre.FechaRechazado IS NOT NULL THEN	'Rechazado'
			 WHEN pre.FechaAceptado IS NOT NULL THEN	'Aceptado'
			 WHEN pre.FechaEnviado IS NOT NULL THEN		'Enviado'
			 ELSE										'Preparación'
		END AS NombreEstadoPresupuesto,

		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,COALESCE(pre.FechaRechazado, pre.FechaAceptado, pre.FechaEnviado, pre.FechaPreparacion), 103)) AS FechaEstadoPresupuesto,

		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,pre.FechaPreparacion,103)) AS FechaPreparacion,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,pre.FechaEnviado,103)) AS FechaEnviado,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,pre.FechaAceptado,103)) AS FechaAceptado,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,pre.FechaRechazado,103)) AS FechaRechazado,

		/*Estado producción*/ 
		CASE WHEN ISNULL(vw_LineasFactura.NumeroLineasAlbaranEnFactura,0) /*LEN(ISNULL(dbo.uf_bp_Presupuestos_Facturas(pre.IdPresupuesto), ''))*/ > 0 THEN	5
			 WHEN ISNULL(vw_LineasAlbaran.NumeroLineasEnAlbaran,0) /*LEN(ISNULL(dbo.uf_bp_Presupuestos_Albaranes(pre.IdPresupuesto), ''))*/ > 0 THEN	4
			 WHEN pre.FechaPendienteFacturacion IS NOT NULL THEN								3
			 WHEN pre.FechaPendiente IS NOT NULL THEN											2
			 WHEN ISNULL(vw_Tareas.NumeroTareas,0)> 0 THEN										1
			 ELSE																				0									 
		END AS IdEstadoProduccion,

		CASE WHEN ISNULL(vw_LineasFactura.NumeroLineasAlbaranEnFactura,0) /*LEN(ISNULL(dbo.uf_bp_Presupuestos_Facturas(pre.IdPresupuesto), ''))*/ > 0 THEN	'Facturado'
			 WHEN ISNULL(vw_LineasAlbaran.NumeroLineasEnAlbaran,0) /*LEN(ISNULL(dbo.uf_bp_Presupuestos_Albaranes(pre.IdPresupuesto), ''))*/ > 0 THEN	'Albaraneado'
			 WHEN pre.FechaPendienteFacturacion IS NOT NULL THEN								'Pendiente facturación'
			 WHEN pre.FechaPendiente IS NOT NULL THEN											'Parado'
			 WHEN ISNULL(vw_Tareas.NumeroTareas,0)>0  THEN										'En producción'
			 ELSE																				'Pendiente producción'
		END AS NombreEstadoProduccion,

		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,CASE WHEN ISNULL(vw_LineasFactura.NumeroLineasAlbaranEnFactura,0) /*LEN(ISNULL(dbo.uf_bp_Presupuestos_Facturas(pre.IdPresupuesto), ''))*/ > 0 THEN	vw_LineasFactura.FechaPrimeraFactura
							 WHEN ISNULL(vw_LineasAlbaran.NumeroLineasEnAlbaran,0) /*LEN(ISNULL(dbo.uf_bp_Presupuestos_Albaranes(pre.IdPresupuesto), ''))*/ > 0 THEN	vw_LineasAlbaran.FechaPrimerAlbaran
							 WHEN pre.FechaPendienteFacturacion IS NOT NULL THEN								pre.FechaPendienteFacturacion
							 WHEN pre.FechaPendiente IS NOT NULL THEN											pre.FechaPendiente
							 WHEN ISNULL(vw_Tareas.NumeroTareas,0)>0  THEN										vw_Tareas.FechaPrimeraTarea
							 ELSE																				NULL
						END 
		, 103)) AS FechaEstadoProduccion,

		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,vw_Tareas.FechaPrimeraTarea,103)) AS FechaEnProduccion,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,pre.FechaPendiente,103)) AS FechaParado,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,pre.FechaPendienteFacturacion,103)) AS FechaPendienteFacturacion,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,vw_LineasAlbaran.FechaPrimerAlbaran,103)) AS FechaAlbaraneado,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,vw_LineasFactura.FechaPrimeraFactura,103)) AS FechaFacturado,

		ISNULL(vw_Tareas.NumeroTareas,0) AS NumeroTareas,
		ISNULL(vw_LineasSinTarea.NumeroLineasSinTarea,0) AS NumeroLineasSinTarea, 
		ISNULL(vw_Tareas.TareasNoRealizadas,0) AS NumeroTareasNoRealizadas ,
		ISNULL(vw_Tareas.TareasRealizadas,0) AS NumeroTareasRealizadas, 
		ISNULL(vw_Tareas.HorasEstimadas,0) AS TareasHorasEstimadas, 
		ISNULL(vw_Tareas.HorasReales,0) AS TareasHorasReales,       

		ISNULL(vw_lineasPresupuesto.NumeroLineas,0)  AS NumeroLineasPresupuesto, 
		ISNULL(vw_lineasPresupuesto.Cantidad,0) AS CantidadPresupuesto, 
		CASE
			WHEN ISNULL(pre.DescuentoCascada,0)>0 THEN  CONVERT(DECIMAL(12,2),vw_lineasPresupuesto.Importe *(1-(DescPago)/100)*(1-(DescCantidad)/100)*(1-(OtrosDesc)/100))
            ELSE CONVERT(DECIMAL(12,2),vw_lineasPresupuesto.Importe *( 1- (ISNULL(DescPago + DescCantidad + OtrosDesc,0))/100))
		END AS ImportePresupuesto, 
		ISNULL(vw_LineasAlbaran.NumeroLineasEnAlbaran,0) AS NumeroLineasEnAlbaran, 
		ISNULL(vw_LineasAlbaran.CantidadAlbaran,0) AS CantidadAlbaran,		
		ISNULL(dbo.uf_bp_Presupuestos_Albaranes(pre.IdPresupuesto), 'No')AS Albaranes,
		CONVERT(DECIMAL(12,2),ISNULL(vw_LineasAlbaran.ImporteAlbaraneado,0)) AS ImporteAlbaraneado,

		ISNULL(vw_LineasFactura.NumeroLineasAlbaranEnFactura,0) AS NumeroLineasAlbaranEnFacturas,																																
		ISNULL(vw_LineasFactura.CantidadFactura,0) AS CantidadFactura,	
		ISNULL(dbo.uf_bp_Presupuestos_Facturas(pre.IdPresupuesto), 'No')AS Facturas,
		CONVERT(DECIMAL(12,2),ISNULL(vw_LineasFactura.ImporteFacturado,0)) AS ImporteFacturado, 
		CONVERT(DECIMAL(12,2),ISNULL(vw_LineasFactura.ImportePagado,0)) AS ImporteFacturadoPagado,

		/*Estudio de costes*/
		CONVERT(DECIMAL(12,2),ISNULL(pre.TotalCostesPrevistosPersonal,0)) AS CostePrevistosTrabajadores,
		CONVERT(DECIMAL(12,2),ISNULL(pre.TotalCostesPrevistosProveedores,0)) AS CostePrevistosProveedores,
		CONVERT(DECIMAL(12,2),ISNULL(pre.TotalCostesPrevistosOtrosCostes,0)) AS OtrosCostesPrevistos,
		CONVERT(DECIMAL(12,2),(ISNULL(pre.TotalCostesPrevistosPersonal,0) + 
							   ISNULL(pre.TotalCostesPrevistosProveedores,0) + 
							   ISNULL(pre.TotalCostesPrevistosOtrosCostes,0))) AS CostePrevistosTotales,
       
		CONVERT(DECIMAL(12,2),ISNULL(pre.TotalCostesRealesPersonal,0)) AS CostesRealTrabajador,
		CONVERT(DECIMAL(12,2),ISNULL(pre.TotalCostesRealesProveedores,0)) AS CosteRealProveedor,
		CONVERT(DECIMAL(12,2),ISNULL(pre.TotalCostesRealesOtrosCostes,0)) AS OtrosCostesReales,
		CONVERT(DECIMAL(12,2),(ISNULL(pre.TotalCostesRealesPersonal,0) + 
							   ISNULL(pre.TotalCostesRealesProveedores,0) + 
							   ISNULL(pre.TotalCostesRealesOtrosCostes,0))) AS CostesRealesTotales,
       
		CONVERT(DECIMAL(12,2),(ISNULL(pre.TotalCostesRealesPersonal,0) - ISNULL(pre.TotalCostesPrevistosPersonal,0))) AS TotalDesviacionesTrabajadores,
		CONVERT(DECIMAL(12,2),(ISNULL(pre.TotalCostesRealesProveedores,0) - ISNULL(pre.TotalCostesPrevistosProveedores,0))) AS TotalDesviacionesProveedores,
		CONVERT(DECIMAL(12,2),(ISNULL(pre.TotalCostesRealesOtrosCostes,0) - ISNULL(pre.TotalCostesPrevistosOtrosCostes,0))) AS TotalOtrosCostesDesviaciones,
       
		CONVERT(DECIMAL(12,2),(ISNULL(pre.TotalCostesRealesPersonal,0) - ISNULL(pre.TotalCostesPrevistosPersonal,0))+
							  (ISNULL(pre.TotalCostesRealesProveedores,0) - ISNULL(pre.TotalCostesPrevistosProveedores,0))+
							  (ISNULL(pre.TotalCostesRealesOtrosCostes,0) - ISNULL(pre.TotalCostesPrevistosOtrosCostes,0))
		) AS TotalDesviaciones,
       
		/*Albaranes y facturas*/
		CASE
			WHEN CONVERT(DECIMAL(12,2),	ISNULL(pre.TotalCostesRealesPersonal,0) + 
										ISNULL(pre.TotalCostesRealesProveedores,0) + 
										ISNULL(pre.TotalCostesRealesOtrosCostes,0)
						) <> 0 	THEN	
						 CONVERT(DECIMAL(12,2),
										(	(		ISNULL(vw_LineasAlbaran.ImporteAlbaraneado,0) 
												-	(	ISNULL(pre.TotalCostesRealesPersonal,0) + 
														ISNULL(pre.TotalCostesRealesProveedores,0) + 
														ISNULL(pre.TotalCostesRealesOtrosCostes,0)
													) 
											)
											* 100
										)
										/	(	ISNULL(pre.TotalCostesRealesPersonal,0) + 
												ISNULL(pre.TotalCostesRealesProveedores,0) + 
												ISNULL(pre.TotalCostesRealesOtrosCostes,0)
											) 
								)
			ELSE 0
		END AS MargenAlbaran,
		
		CONVERT(DECIMAL(12,2),
				ISNULL(vw_LineasAlbaran.ImporteAlbaraneado, 0) 
			-	(	ISNULL(pre.TotalCostesRealesPersonal,0) + 
					ISNULL(pre.TotalCostesRealesProveedores,0) + 
					ISNULL(pre.TotalCostesRealesOtrosCostes,0)
				) 
		) AS BeneficioAlbaran,	
       
		CASE
			WHEN CONVERT(DECIMAL(12,2),	ISNULL(pre.TotalCostesRealesPersonal,0) + 
										ISNULL(pre.TotalCostesRealesProveedores,0) + 
										ISNULL(pre.TotalCostesRealesOtrosCostes,0)
						) <> 0 	THEN	
						 CONVERT(DECIMAL(12,2),
										(	(		ISNULL(vw_LineasFactura.ImporteFacturado,0) 
												-	(	ISNULL(pre.TotalCostesRealesPersonal,0) + 
														ISNULL(pre.TotalCostesRealesProveedores,0) + 
														ISNULL(pre.TotalCostesRealesOtrosCostes,0)
													) 
											)
											* 100
										)
										/	(	ISNULL(pre.TotalCostesRealesPersonal,0) + 
												ISNULL(pre.TotalCostesRealesProveedores,0) + 
												ISNULL(pre.TotalCostesRealesOtrosCostes,0)
											) 
								)
			ELSE 0
		END AS MargenFactura,
		
       CONVERT(DECIMAL(12,2),
				ISNULL(vw_LineasFactura.Importefacturado, 0)
			-	(	ISNULL(pre.TotalCostesRealesPersonal,0) + 
					ISNULL(pre.TotalCostesRealesProveedores,0) + 
					ISNULL(pre.TotalCostesRealesOtrosCostes,0)
				) 
		) AS BeneficioFacturado	,	
		pre.idIdentidad,
		pre.FechaModificacion,
		pre.IdAlmacen,
		
		Pre.IdMonedaCliente,
		pre.IdMonedaSociedad,
		FactorConversionMonedaCliente,
		FactorConversionMonedaSociedad,
		moncli.Simbolo AS MonedaCliente,
		monsoc.simbolo AS MonedaSociedad,
		pre.IdEstadoDocumento,
		
		
			    
	    pre.IdDireccionEnvio,
		dir.Nombre + ':' + dir.Direccion + ', ' + dir.Cp  + ' ' + dir.Poblacion + ' (' + dirPro.Nombre + ') ' + dirPa.Nombre COLLATE Modern_Spanish_CI_AS AS DireccionEnvioCompleta,
		pre.NombreDireccionEnvio,
		pre.Direccion,
		pre.Poblacion,
		pre.CodigoPostal,
		pre.IdProvincia,
		pre.IdPais,
		pre.Latitud,
		pre.Longitud,
		pre.Telefono,
		pre.Fax,
		pre.Horario,
		pre.PersonaContacto,
		pre.Observaciones,
		pre.TipoOrigenDireccionEnvio,
		pre.IdProveedorPortes,
		pre.NumeroBultos,
		provportes.NombreComercial AS NombreProveedorPortes,
		ISNULL(pre.DesdePedidos,0) AS DesdePedidos,
		IdComercial,
		ISNULL(pre.Servido,0) AS Servido,
		p_t.CodigoTipo + ' - ' + pre.NumPresupuesto  + ' - ' + CONVERT(VARCHAR(50),pre.Fecha,103)+' - '+ pre.Descripcion AS DescripcionCompleta,
		pre.IdFormaPago,
		ISNULL(pre.DescPago,0) AS DescuentoPago,
		ISNULL(pre.DescCantidad,0) AS DescuentoCantidad,
		ISNULL(pre.OtrosDesc,0) AS OtrosDescuentos,
		pre.NombreComercialCliente,
		pre.NombreFiscalCliente,
		pre.IdTipoCif,
		pre.Cif,
		pre.ObservacionesDocumentosVenta,
		pre.IdProyecto,
		ISNULL(p.Codigo + '-','') +p.Nombre AS Proyecto,
		pre.IdProyectoTarea,
		pre.DescPago,
		pre.DescCantidad,
		pre.OtrosDesc,
		pre.IdTipoTarifa,
		pre.IdTesoreria,
		pre.PortesPagados,
		pre.Referencia,
		ISNULL(pre.DescuentoCascada,0) AS DescuentoCascada,
		ISNULL(pre.ConRecargoEquivalencia,0) AS ConRecargoEquivalencia,
		vw_LineasPresupuesto.Coste,
		pre.IdClienteContado,
		cc.NombreComercial AS ClienteContado,
		pre.IdCentroTrabajo,
		pre.Referencia2,
		pre.IdTipoRuta

	FROM		dbo.Presupuestos		pre
		INNER JOIN	dbo.gf_Clientes			cli			ON cli.IdCliente = pre.IdCliente 
		LEFT JOIN dbo.Proyectos p					    ON p.IdProyecto = pre.IdProyecto
		LEFT  JOIN	dbo.Presupuestos_Tipos	p_t			ON p_t.IdPresupuestoTipo = pre.IdPresupuestoTipo 
        LEFT  JOIN	dbo.PersonasContacto	PersCont	ON PersCont.IdPersonaContacto = pre.IdPersonaContacto
        LEFT  JOIN (
					SELECT	p_l.IdPresupuesto,
							COUNT(p_l.idpresupuestolinea) AS Numerolineas,
							SUM(ISNULL(p_l.cantidad,0))	AS Cantidad,
							SUM(CONVERT(DECIMAL(18,2), 
									( ISNULL(p_l.cantidad, 0) * ISNULL(p_l.precio, 0) )
								-	( (ISNULL(p_l.cantidad, 0) * ISNULL(p_l.precio, 0)) * ISNULL(p_l.descuento, 0) / 100 )
								)) AS Importe,
							Sum (p_l.CantidadCliente * ISNULL(p_l.Coste,0)) AS Coste 
				

					FROM	dbo.Presupuestos_Lineas p_l 
					GROUP BY p_l.IdPresupuesto
					) vw_LineasPresupuesto ON vw_LineasPresupuesto.IdPresupuesto = pre.IdPresupuesto
			
		LEFT JOIN (
					SELECT	p_l.IdPresupuesto,
							COUNT(DISTINCT p_l.IdPresupuestoLinea) AS NumeroLineasEnAlbaran,
							SUM(ISNULL(a_l.Cantidad,0)) AS CantidadAlbaran ,
							SUM(CONVERT(DECIMAL(18,2), 
									( ISNULL(p_l.cantidad, 0) * ISNULL(p_l.precio,0) )
								-	( (ISNULL(p_l.cantidad, 0) * ISNULL(p_l.precio,0)) * ISNULL(p_l.descuento, 0) / 100 )
								)) AS ImporteAlbaraneado ,
							MIN(a.FechaEmision) AS FechaPrimerAlbaran

					FROM		dbo.Presupuestos_Lineas		p_l 
				 	INNER JOIN	dbo.Albaranes_Lineas		a_l ON p_l.IdPresupuestoLinea = a_l.IdPresupuestoLinea		
					INNER JOIN	dbo.Albaranes				a	ON a.IdAlbaran = a_l.IdAlbaran			
					GROUP BY p_l.IdPresupuesto
					) vw_LineasAlbaran ON vw_LineasAlbaran.IdPresupuesto = pre.IdPresupuesto
			
		LEFT JOIN ( SELECT	p_l.IdPresupuesto,
							COUNT(DISTINCT a_l.idalbaranlinea) AS NumeroLineasAlbaranEnFactura,
							SUM(ISNULL(fc_l.cantidad,0)) AS CantidadFactura,
							SUM(fc_l.Importe) AS ImporteFacturado,  
							SUM(ISNULL(vw_vencimientos.ImportePagado ,0)) AS ImportePagado,
							MIN(fc.FechaFactura) AS FechaPrimeraFactura
					FROM		dbo.Presupuestos_Lineas		p_l 
					INNER JOIN	dbo.Albaranes_Lineas		a_l		ON p_l.IdPresupuestoLinea = a_l.IdPresupuestoLinea 
					INNER JOIN	dbo.vw_bp_FacturasClientes_Lineas fc_l	ON a_l.IdAlbaranLinea = fc_l.IdAlbaranLinea 
					INNER JOIN	dbo.FacturasClientes		fc		ON fc.IdFacturaCliente = fc_l.IdFacturaCliente
					LEFT  JOIN (	SELECT f_v.IdFacturaCliente, 
											SUM(ISNULL(f_v.imp_pagado,0)) AS ImportePagado 
									FROM dbo.Facturasclientes_Vencimientos f_v 
									WHERE f_v.Pagado=1 
									GROUP BY f_v.IdFacturaCliente 
							     ) vw_vencimientos ON vw_vencimientos.IdFacturaCliente = fc_l.IdFacturaCliente 
					GROUP BY p_l.IdPresupuesto 
					) vw_LineasFactura ON vw_LineasFactura.idpresupuesto=pre.idpresupuesto 
			
        LEFT JOIN ( SELECT	p_l.IdPresupuesto, 
							COUNT(p_l.IdPresupuestolinea) AS NumeroLineasSinTarea 
                    FROM	dbo.Presupuestos_Lineas p_l
                    WHERE	p_l.IdPresupuestoLinea NOT IN (	SELECT tar.IdPresupuestolinea 
															FROM dbo.Tareas tar 
															WHERE tar.IdPresupuestolinea IS NOT NULL) 
						  AND p_l.RequiereTarea = 1 
                    GROUP BY p_l.IdPresupuesto 
				) vw_LineasSinTarea ON vw_LineasSinTarea.IdPresupuesto = pre.IdPresupuesto 
                    
        LEFT JOIN ( SELECT	p_l.IdPresupuesto,
							COUNT(tar.IdTarea) AS NumeroTareas,
							SUM(CASE WHEN tar.IdTarea IS NOT NULL AND tar.FRealizada IS NULL AND tar.FComprobada IS NULL THEN 1 ELSE 0 END) AS TareasNoRealizadas,
							SUM(CASE WHEN tar.IdTarea IS NOT NULL AND tar.FRealizada IS NOT NULL THEN 1 ELSE 0 END) AS TareasRealizadas,
							SUM(ISNULL(tar.HorasEstimadas,0)) AS HorasEstimadas, 
							SUM(ISNULL(tt.Total,0)) AS HorasReales,
							MIN(tar.Fecha) AS FechaPrimeraTarea
					FROM		dbo.Presupuestos_Lineas p_l
					LEFT  JOIN	dbo.Tareas				tar ON tar.IdPresupuestoLinea = p_l.IdPresupuestoLinea
					LEFT  JOIN	dbo.vw_Tareas_Tiempos	tt	ON tt.IdTarea = tar.IdTarea
                    GROUP BY p_l.IdPresupuesto
				 ) vw_Tareas ON vw_Tareas.IdPresupuesto = pre.IdPresupuesto
		LEFT  JOIN  dbo.Monedas				moncli		ON moncli.IdMoneda = pre.IdMonedaCliente
        LEFT  JOIN  dbo.Monedas				monsoc		ON monsoc.IdMoneda = pre.IdMonedaSociedad
        LEFT  JOIN dbo.DireccionesEnvio		dir		    ON dir.IdDireccionEnvio = pre.IdDireccionEnvio
        LEFT  JOIN dbo.Provincias			dirPro		ON dirPro.IdProvincia = dir.IdProvincia
		LEFT  JOIN dbo.Paises				dirPa		ON dirPa.IdPais = dir.IdPais
		LEFT  JOIN dbo.gf_Proveedores			provportes	ON provportes.idProveedor = pre.IdProveedorPortes
		LEFT  JOIN dbo.gf_Clientes				cc			ON cc.IdCliente = pre.IdClienteContado


GO

-- Stored Procedure structure for dbo.SeguridadUnificada_Identidad_Select
CREATE PROCEDURE dbo.SeguridadUnificada_Identidad_Select
(
	@IdIdentidad INT = NULL,
	@Usuario VARCHAR(100) = NULL,
	@Contrasena VARCHAR (100) = NULL,
	@IdTipoUsuario INT = NULL,
	@Nombre VARCHAR(500) = NULL,
	@Activo INT = 1,
	@IdUsuario INT = NULL,
	@IdsTiposUsuario VARCHAR(MAX) = NULL,
	@IdAplicacionConPermiso INT = NULL
)
AS

	/*ATENCIÓN: no es igual en todas las BBDD*/

	SELECT
		SeguridadUnificada_Identidad.IdIdentidad,
		SeguridadUnificada_Identidad.IdUsuario,
		Nombre = 
			ISNULL (
					CASE 
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 1 THEN (SELECT LTRIM(RTRIM(ISNULL(p.Nombre,'') + ' ' + ISNULL(p.PrimerApellido ,'') + ' ' + ISNULL(p.SegundoApellido,''))) FROM dbo.gf_Personal p WHERE IdPersonal = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 2 THEN (SELECT LTRIM(RTRIM(ISNULL(a.Nombre,'') + ' ' + ISNULL(a.PrimerApellido ,'') + ' ' + ISNULL(a.SegundoApellido,''))) FROM dbo.gf_Alumnos a WHERE IdAlumno = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 3 THEN (SELECT LTRIM(RTRIM(ISNULL(c.RazonSocial,'')))		FROM dbo.gf_Clientes c					WHERE IdCliente = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 4 THEN (SELECT LTRIM(RTRIM(ISNULL(e.RazonSocial,'')))		FROM dbo.gf_EntidadesImpartidoras e		WHERE IdEntidadImpartidora = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 5 THEN (SELECT LTRIM(RTRIM(ISNULL(co.RazonSocial,'')))	FROM dbo.gf_EntidadesColaboradoras co	WHERE IdEntidadColaboradora = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 6 THEN (SELECT LTRIM(RTRIM(ISNULL(d.Nombre,'') + ' ' + ISNULL(d.PrimerApellido ,'') + ' ' + ISNULL(d.SegundoApellido,''))) FROM dbo.gf_Docentes d WHERE IdDocente = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 7 THEN (SELECT LTRIM(RTRIM(ISNULL(e.RazonSocial,'')))		FROM dbo.gf_EntidadesSupervisoras e		WHERE e.IdEntidadSupervisora = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 8 THEN (	SELECT LTRIM(RTRIM(ISNULL(p.Nombre,'') + ' ' + ISNULL(p.PrimerApellido ,'') + ' ' + ISNULL(p.SegundoApellido,'') + '(' + ISNULL(ent.RazonSocial,'') + ')' )) 
																					FROM dbo.gf_Personal p 
																					LEFT JOIN dbo.gf_EntidadesImpartidoras ent ON ent.IdEntidadImpartidora = p.IdEntidadImpartidora
																					WHERE IdPersonal = IdUsuario)
					END,'(Sin texto descriptivo)' 
				) + ' (' + Usuario + ')',
		SeguridadUnificada_Identidad.IdTipoUsuario,
		SeguridadUnificada_TipoUsuario.Nombre AS TipoUsuario,
		Departamento = '',
		NumeroGrupos = (SELECT COUNT(*) FROM SeguridadUnificada_IdentidadGrupo WHERE (SeguridadUnificada_IdentidadGrupo.IdIdentidad = SeguridadUnificada_Identidad.IdIdentidad)),
		
		SeguridadUnificada_Identidad.Usuario,
		SeguridadUnificada_Identidad.Contrasena,
		CASE gf_Personal.Activo WHEN 1 THEN 0 ELSE 1 END AS Obsoleto,
		SeguridadUnificada_TipoUsuario.Color,
		SeguridadUnificada_Identidad.AvisoBackup,
		SeguridadUnificada_Identidad.Activo,
		ActivoTexto = CASE WHEN ISNULL(dbo.SeguridadUnificada_Identidad.Activo,0) = 1 THEN 'Sí' ELSE 'No' END,

		AutenticarConActiveDirectory = CASE WHEN ISNULL(dbo.SeguridadUnificada_Identidad.IdDominio,0) > 0 THEN 1 ELSE 0 END,
		AutenticarConActiveDirectoryTexto = CASE WHEN ISNULL(dbo.SeguridadUnificada_Identidad.IdDominio,0) > 0 THEN 'Sí' ELSE 'No' END,
		dbo.SeguridadUnificada_Identidad.IdTipoValidacionUsuarioDominio,
		TipoValidacionUsuarioDominio = tvus.Nombre,
		SeguridadUnificada_Identidad.IdDominio,

		UsuarioNombre = SeguridadUnificada_Identidad.Usuario + '//' + 
						ISNULL (
								CASE 
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 1 THEN (SELECT Nombre 	FROM gf_Personal 		WHERE IdPersonal = IdUsuario) 
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 2 THEN (SELECT LTRIM(RTRIM(ISNULL(a.Nombre,'') + ' ' + ISNULL(a.PrimerApellido ,'') + ' ' + ISNULL(a.SegundoApellido,''))) FROM dbo.gf_Alumnos a WHERE IdAlumno = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 3 THEN (SELECT LTRIM(RTRIM(ISNULL(c.RazonSocial,'')))		FROM dbo.gf_Clientes c					WHERE IdCliente = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 4 THEN (SELECT LTRIM(RTRIM(ISNULL(e.RazonSocial,'')))		FROM dbo.gf_EntidadesImpartidoras e		WHERE IdEntidadImpartidora = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 5 THEN (SELECT LTRIM(RTRIM(ISNULL(co.RazonSocial,'')))	FROM dbo.gf_EntidadesColaboradoras co	WHERE IdEntidadColaboradora = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 6 THEN (SELECT LTRIM(RTRIM(ISNULL(d.Nombre,'') + ' ' + ISNULL(d.PrimerApellido ,'') + ' ' + ISNULL(d.SegundoApellido,''))) FROM dbo.gf_Docentes d WHERE IdDocente = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 7 THEN (SELECT LTRIM(RTRIM(ISNULL(e.RazonSocial,'')))		FROM dbo.gf_EntidadesSupervisoras e		WHERE e.IdEntidadSupervisora = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 8 THEN (	SELECT LTRIM(RTRIM(ISNULL(p.Nombre,'') + ' ' + ISNULL(p.PrimerApellido ,'') + ' ' + ISNULL(p.SegundoApellido,'') + '(' + ISNULL(ent.RazonSocial,'') + ')' )) 
																								FROM dbo.gf_Personal p 
																								LEFT JOIN dbo.gf_EntidadesImpartidoras ent ON ent.IdEntidadImpartidora = p.IdEntidadImpartidora
																								WHERE IdPersonal = IdUsuario)
								END, '(Sin nombre descriptivo)'
							) COLLATE Modern_Spanish_CI_AS,
		vw_Conf.ContraseñaAltaSeguridad,
		vw_Conf.CaducidadContraseña,
		vw_Conf.NumeroMesesCaducidadContraseña,
		SeguridadUnificada_Identidad.FechaCambioContraseña,
		UsuarioNombreSimple = ISNULL (
								CASE 
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 1 THEN (SELECT LTRIM(RTRIM(Nombre +  ISNULL(' ' + PrimerApellido ,'') +  ISNULL(' ' + SegundoApellido ,''))) 	FROM gf_Personal 		WHERE IdPersonal = IdUsuario) 
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 2 THEN (SELECT LTRIM(RTRIM(ISNULL(a.Nombre,'') +  ISNULL(' ' + a.PrimerApellido ,'') + ISNULL(' ' + a.SegundoApellido,''))) FROM dbo.gf_Alumnos a WHERE IdAlumno = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 3 THEN (SELECT LTRIM(RTRIM(ISNULL(c.RazonSocial,'')))		FROM dbo.gf_Clientes c					WHERE IdCliente = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 4 THEN (SELECT LTRIM(RTRIM(ISNULL(e.RazonSocial,'')))		FROM dbo.gf_EntidadesImpartidoras e		WHERE IdEntidadImpartidora = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 5 THEN (SELECT LTRIM(RTRIM(ISNULL(co.RazonSocial,'')))	FROM dbo.gf_EntidadesColaboradoras co	WHERE IdEntidadColaboradora = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 6 THEN (SELECT LTRIM(RTRIM(ISNULL(d.Nombre,'') +  ISNULL(' ' + d.PrimerApellido ,'') + ISNULL(' ' + d.SegundoApellido ,'') )) FROM dbo.gf_Docentes d WHERE IdDocente = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 7 THEN (SELECT LTRIM(RTRIM(ISNULL(e.RazonSocial,'')))		FROM dbo.gf_EntidadesSupervisoras e		WHERE e.IdEntidadSupervisora = IdUsuario)
									WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 8 THEN (	SELECT LTRIM(RTRIM(ISNULL(p.Nombre,'') +  ISNULL(' ' + p.PrimerApellido ,'') + ISNULL(' ' + p.SegundoApellido ,'') + '(' + ISNULL(ent.RazonSocial,'') + ')' )) 
																								FROM dbo.gf_Personal p 
																								LEFT JOIN dbo.gf_EntidadesImpartidoras ent ON ent.IdEntidadImpartidora = p.IdEntidadImpartidora
																								WHERE IdPersonal = IdUsuario)
								END, '(Sin nombre descriptivo)'
							),
		Robot = ISNULL(gf_Personal.Robot,0),
		SeguridadUnificada_Identidad.ContraseñaProvisional,
		[ContraseñaProvisionalTexto] = CASE WHEN ISNULL(SeguridadUnificada_Identidad.ContraseñaProvisional,0) = 1 THEN 'Sí' ELSE 'No' END 
		
	FROM
					SeguridadUnificada_Identidad
		LEFT JOIN	dbo.gf_Personal					ON SeguridadUnificada_Identidad.IdUsuario = gf_Personal.IdPersonal 
		LEFT JOIN	SeguridadUnificada_TipoUsuario	ON SeguridadUnificada_TipoUsuario.Numero = SeguridadUnificada_Identidad.IdTipoUsuario
		LEFT JOIN dbo.TiposCerrados tvus  ON tvus.IdTipo = dbo.SeguridadUnificada_Identidad.IdTipoValidacionUsuarioDominio
		OUTER APPLY (
						SELECT 
							conf.ContraseñaAltaSeguridad,
							conf.CaducidadContraseña,
							conf.NumeroMesesCaducidadContraseña
						FROM dbo.SeguridadUnificada_Configuracion conf
					) vw_Conf
	WHERE
			(@IdIdentidad IS NULL OR SeguridadUnificada_Identidad.IdIdentidad = @IdIdentidad)
		AND (@Usuario IS NULL OR SeguridadUnificada_Identidad.Usuario = @Usuario)
		AND (@IdTipoUsuario IS NULL OR SeguridadUnificada_Identidad.IdTipoUsuario = @IdTipoUsuario)
		AND (@Contrasena IS NULL OR
				(
					(PWDCOMPARE(@Contrasena,SeguridadUnificada_Identidad.ContrasenaEnc) = 1) 
					OR (SeguridadUnificada_Identidad.Contrasena = @Contrasena) 
				)
			)
		AND	(@Nombre IS NULL OR	
			ISNULL (
					CASE 
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 1 THEN (SELECT LTRIM(RTRIM(ISNULL(p.Nombre,'') + ' ' + ISNULL(p.PrimerApellido ,'') + ' ' + ISNULL(p.SegundoApellido,''))) FROM dbo.gf_Personal p WHERE IdPersonal = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 2 THEN (SELECT LTRIM(RTRIM(ISNULL(a.Nombre,'') + ' ' + ISNULL(a.PrimerApellido ,'') + ' ' + ISNULL(a.SegundoApellido,''))) FROM dbo.gf_Alumnos a WHERE IdAlumno = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 3 THEN (SELECT LTRIM(RTRIM(ISNULL(c.RazonSocial,'')))		FROM dbo.gf_Clientes c					WHERE IdCliente = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 4 THEN (SELECT LTRIM(RTRIM(ISNULL(e.RazonSocial,'')))		FROM dbo.gf_EntidadesImpartidoras e		WHERE IdEntidadImpartidora = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 5 THEN (SELECT LTRIM(RTRIM(ISNULL(co.RazonSocial,'')))	FROM dbo.gf_EntidadesColaboradoras co	WHERE IdEntidadColaboradora = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 6 THEN (SELECT LTRIM(RTRIM(ISNULL(d.Nombre,'') + ' ' + ISNULL(d.PrimerApellido ,'') + ' ' + ISNULL(d.SegundoApellido,''))) FROM dbo.gf_Docentes d WHERE IdDocente = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 7 THEN (SELECT LTRIM(RTRIM(ISNULL(e.RazonSocial,'')))		FROM dbo.gf_EntidadesSupervisoras e		WHERE e.IdEntidadSupervisora = IdUsuario)
						WHEN SeguridadUnificada_Identidad.IdTipoUsuario = 8 THEN (	SELECT LTRIM(RTRIM(ISNULL(p.Nombre,'') + ' ' + ISNULL(p.PrimerApellido ,'') + ' ' + ISNULL(p.SegundoApellido,'') + '(' + ISNULL(ent.RazonSocial,'') + ')' )) 
																					FROM dbo.gf_Personal p 
																					LEFT JOIN dbo.gf_EntidadesImpartidoras ent ON ent.IdEntidadImpartidora = p.IdEntidadImpartidora
																					WHERE IdPersonal = IdUsuario)
					END,'(Sin texto descriptivo)'
				) + ' (' + Usuario + ')' LIKE '%' + @Nombre + '%'
		   )
		AND	(CASE 
					WHEN @Activo IS NULL OR @Activo = -1 THEN 1
					WHEN SeguridadUnificada_Identidad.Activo = @Activo THEN 1
					ELSE 0
			END = 1)
		AND (@IdUsuario IS NULL OR SeguridadUnificada_Identidad.IdUsuario = @IdUsuario)
		AND (@IdsTiposUsuario IS NULL OR SeguridadUnificada_Identidad.IdTipoUsuario IN (SELECT [str] FROM dbo.uf_ListaATabla(@IdsTiposUsuario,',')))
		AND (@IdAplicacionConPermiso IS NULL OR 
												/*Pertenezca a un grupo de la @IdAplicacionConPermiso*/
												(SeguridadUnificada_Identidad.IdIdentidad IN (	SELECT 
																									ig2.IdIdentidad
																								FROM dbo.SeguridadUnificada_IdentidadGrupo ig2 
																									INNER JOIN dbo.SeguridadUnificada_Grupo				gr2 ON gr2.IdGrupo = ig2.IdGrupo
																								WHERE
																										(gr2.IdAplicacion = @IdAplicacionConPermiso)
																							)
												AND 
												/*Que tenga permiso al @IdAplicacionConPermiso el IdIdentiad.*/
												SeguridadUnificada_Identidad.IdIdentidad IN (	SELECT 
																									fe2.IdIdentidad
																								FROM dbo.SeguridadUnificada_Formulario f2 
																									INNER JOIN dbo.SeguridadUnificada_FormularioEnlace fe2 ON fe2.IdFormulario = f2.IdFormulario

																								WHERE
																										(f2.IdAplicacion = @IdAplicacionConPermiso)
																									AND (fe2.Valor = 1 )
																							)
												)
			)
	ORDER BY
		Nombre

GO

-- Stored Procedure structure for dbo.up_Contactos_Select_Agrupado
CREATE PROC dbo.up_Contactos_Select_Agrupado
(
	@IdContacto INT = NULL,
	@CadenaIdsContactos VARCHAR(MAX) = NULL	,
	@IdTipoPropietarioAsociado INT = NULL,
	@IdTipoPropietarioRealizador INT = NULL,	
	@IdsPropietarioAsociado NVARCHAR(MAX) = NULL,
	@IdsPropietarioRealizador NVARCHAR(MAX) = NULL,	
	@IdContactoClasificacion INT = NULL,
	@IdTipoContacto INT = NULL,
	@FechaDesde SMALLDATETIME = NULL,
	@FechaHasta SMALLDATETIME = NULL,
	@PersonaContactada VARCHAR(200) = NULL,
	@Rellamada TINYINT = NULL,
	@PlanificadoRealizado TINYINT = NULL,
	@NivelMostrar TINYINT = 2--,
	--@IdPropietarioSubAsociado INT = NULL  
)
AS

	DECLARE @L_IdContacto INT = @IdContacto,
			@L_CadenaIdsContactos VARCHAR(MAX) = @CadenaIdsContactos,	
			@L_IdTipoPropietarioAsociado INT = @IdTipoPropietarioAsociado,
			@L_IdTipoPropietarioRealizador INT = @IdTipoPropietarioRealizador,	
			@L_IdsPropietarioAsociado NVARCHAR(MAX) = @IdsPropietarioAsociado,
			@L_IdsPropietarioRealizador NVARCHAR(MAX) = @IdsPropietarioRealizador,	
			@L_IdContactoClasificacion INT = @IdContactoClasificacion,
			@L_IdTipoContacto INT = @IdTipoContacto,
			@L_FechaDesde SMALLDATETIME = @FechaDesde,
			@L_FechaHasta SMALLDATETIME = @FechaHasta,
			@L_PersonaContactada VARCHAR(200) = @PersonaContactada,
			@L_Rellamada TINYINT = @Rellamada,
			@L_PlanificadoRealizado TINYINT = @PlanificadoRealizado,
			@L_NivelMostrar TINYINT = @NivelMostrar

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    IF (@L_IdContacto IS NOT NULL AND @L_IdTipoPropietarioAsociado IS NULL)
        SET @L_IdTipoPropietarioAsociado =   (SELECT cp.IdTipoPropietario 
                                            FROM dbo.Contactos_Propietarios cp 
                                                 INNER JOIN dbo.ContactosTiposPropietarios ctp ON cp.IdTipoPropietario = ctp.IdTipoPropietario AND ctp.IdTipo = 1
                                            WHERE IdContacto = @L_IdContacto)
    IF (@L_IdContacto IS NOT NULL AND @L_IdTipoPropietarioRealizador IS NULL)
        SET @L_IdTipoPropietarioRealizador = (SELECT cp.IdTipoPropietario 
                                            FROM dbo.Contactos_Propietarios cp 
                                                 INNER JOIN dbo.ContactosTiposPropietarios ctp ON cp.IdTipoPropietario = ctp.IdTipoPropietario AND ctp.IdTipo = 0
                                            WHERE IdContacto = @L_IdContacto)                                                                                             
  	
		SELECT
			[AgrupadoFecha] =			   GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)),
			[AgrupadoIdContacto] =		   GROUPING(con.IdContacto),
			[Nivel] =					   GROUPING(cp_Realizado.IdPropietario) 
									     + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) 
									     + GROUPING(con.IdContacto),
			[NumeroRegistros] =			   SUM(1),
			[IdContacto] =				   MAX(con.IdContacto),
			[IdTipoPropietarioRealizador] =  MAX(cp_Realizado.IdTipoPropietario),
			[IdTipoPropietarioAsociado] =  MAX(cp_Asociado.IdTipoPropietario),
			[IdPropietarioRealizador] =	   MAX(cp_Realizado.IdPropietario),
			[IdPropietarioAsociado] =	   MAX(cp_Asociado.IdPropietario),
			[TipoPropietarioRealizador] =  CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN 
													MAX(cpTRea.Nombre)
												ELSE NULL	
										   END ,
			[TipoPropietarioAsociado] =	   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN
													MAX(cpTAso.Nombre)
												ELSE NULL	
											END ,	
			[NombrePropietarioRealizador] =  NULL,
			[NombrePropietarioAsociado] =	 Null,
			
			[Fecha] =					   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) <2 THEN
													MAX(con.Fecha)
												ELSE NULL
										   END ,			
			[Hora] =					   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN 
													MAX(con.Hora)
												ELSE NULL	
										   END ,
			[FechaFin] =				   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN 
													MAX(con.FechaFin)
												ELSE NULL
										   END ,					
			[HoraFin] =					   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN 
													MAX(con.HoraFin)
												ELSE NULL	
										   END ,
			
			[IdContactoClasificacion] =	   MAX(con.IdContactoClasificacion),
			[NombreClasificacion] =		   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN 
													MAX(concla.Nombre)
												ELSE NULL
										   END ,
			[IdTipoContacto] =			   MAX(con.IdTipoContacto),
			[TipoContacto] =			   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN 
													MAX(tip.Nombre)
												ELSE NULL	
										   END ,
			[IdPersonaContacto] =		   MAX(con.IdPersonaContacto),
			[PersonaContactada] =		   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN 
													MAX(con.PersonaContactada)
												ELSE NULL	
											END,
			
			[Rellamada] =				   MAX(con.Rellamada),
			[RellamadaTexto] =			   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN  
													MAX(con.RellamadaTexto)
												ELSE NULL	
										   END , 
			[Observaciones] =			   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN  
													MAX(con.Observaciones)
												ELSE NULL	
										   END ,
			[PlanificadoRealizado] =	   MAX(con.PlanificadoRealizado),
			[PlanificadoRealizadoTexto] =  CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN  
													MAX(con.PlanificadoRealizadoTexto)
												ELSE NULL	
										   END ,
			[DescripcionContacto] =		   CASE WHEN GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) = 0 THEN 
													MAX(CONVERT(VARCHAR, con.Fecha, 103)) + ' - ' 
											      + MAX(CONVERT(VARCHAR, con.Fecha, 108)) + ' - '
									              -- + MAX(t_Realizado.' + ctp_Realizado.CampoMostrar + ') + ' - '
									              + MAX(tip.Nombre) + ' - ' + MAX(con.Observaciones)
									            ELSE NULL
									        END ,
									   
			[IdTipoEstado] =			   MAX(con.IdTipoEstado),
			[IdContactoTipificacionLlamada]= MAX(con.IdContactoTipificacionLlamada),
			[IdContactoTipoHorarioPreferencia] = MAX(con.IdContactoTipoHorarioPreferencia)										
		FROM
				   (
						SELECT
							vw_con.IdContacto,
							vw_con.IdTipoContacto,
							vw_con.IdContactoClasificacion,
							vw_con.Fecha,
							Hora =		CONVERT(VARCHAR, vw_con.Fecha, 108),
							FechaFin =	ISNULL(vw_con.FechaFin, vw_con.Fecha),
							HoraFin =	CONVERT(VARCHAR, ISNULL(vw_con.FechaFin, vw_con.Fecha), 108),
							vw_con.Rellamada,
							RellamadaTexto = CASE WHEN vw_con.Rellamada = 0 THEN 'No'	
												  ELSE 'Sí'
											 END,
							vw_con.PlanificadoRealizado,
							PlanificadoRealizadoTexto =  CASE WHEN vw_con.PlanificadoRealizado = 0 
															  THEN 'Planificado'	
															  ELSE 'Realizado' 
														  END,
							vw_con.IdPersonaContacto,
							vw_con.PersonaContactada,
							vw_con.IdTipoEstado,
							vw_con.IdContactoTipificacionLlamada,
							vw_con.Observaciones,
							vw_con.IdContactoTipoHorarioPreferencia
							
						FROM  dbo.Contactos	vw_con
						WHERE 
								CASE WHEN @L_IdContacto IS  NULL			THEN 1
									 WHEN vw_con.IdContacto = @L_IdContacto	THEN 1
								END	= 1	
							AND CASE WHEN @L_CadenaIdsContactos IS NULL THEN 1
									 WHEN vw_con.IdContacto IN (SELECT [STR] FROM dbo.uf_ListaATabla(@L_CadenaIdsContactos,',')) THEN 1
								END = 1 
							AND CASE WHEN @L_IdContactoClasificacion IS NULL	   THEN 1
									 WHEN vw_con.IdContactoClasificacion = @L_IdContactoClasificacion THEN 1
								END	= 1
							AND CASE WHEN @L_IdTipoContacto IS NULL   THEN 1
									 WHEN vw_con.IdTipoContacto = @L_IdTipoContacto THEN 1
								END	 = 1
							AND CASE WHEN @L_FechaDesde IS NULL THEN 1
									 WHEN CAST(CONVERT(VARCHAR, vw_con.Fecha, 103) AS SMALLDATETIME) BETWEEN CAST(CONVERT(VARCHAR, @L_FechaDesde, 103) AS SMALLDATETIME) AND CAST(CONVERT(VARCHAR, @L_FechaHasta, 103) AS SMALLDATETIME) THEN 1
								END = 1	
							AND CASE WHEN @L_PersonaContactada IS NULL THEN 1
									 WHEN vw_con.PersonaContactada LIKE '%' + @L_PersonaContactada + '%' THEN 1
								END = 1	
							AND CASE WHEN @L_Rellamada IS NULL THEN 1
									 WHEN vw_con.Rellamada = @L_Rellamada THEN 1 
								END	= 1
							AND CASE WHEN @L_PlanificadoRealizado IS NULL	 THEN 1
									 WHEN vw_con.PlanificadoRealizado = @L_PlanificadoRealizado THEN 1 
								END = 1					
					) con			
		INNER JOIN dbo.Contactos_Propietarios		cp_Realizado	ON con.IdContacto = cp_Realizado.IdContacto 
		INNER JOIN dbo.ContactosTiposPropietarios	cpTRea			ON cpTRea.IdTipoPropietario = cp_Realizado.IdTipoPropietario AND cpTRea.IdTipo = 0 
		INNER JOIN dbo.Contactos_Propietarios		cp_Asociado		ON con.IdContacto = cp_Asociado.IdContacto 
		INNER JOIN dbo.ContactosTiposPropietarios	cpTAso			ON cpTAso.IdTipoPropietario = cp_Asociado.IdTipoPropietario AND cpTAso.IdTipo = 1
		LEFT JOIN dbo.Tipos							tip				ON con.IdTipoContacto = tip.IdTipo
		LEFT JOIN dbo.ContactosClasificaciones		concla			ON con.IdContactoClasificacion =  concla.IdContactoClasificacion				
		WHERE			
				(@L_IdTipoPropietarioAsociado IS NULL		OR cpTAso.IdTipoPropietario = @L_IdTipoPropietarioAsociado)
			AND (@L_IdTipoPropietarioRealizador IS NULL	OR cpTRea.IdTipoPropietario = @L_IdTipoPropietarioRealizador)
		
			AND CASE WHEN @L_IdsPropietarioAsociado IS NULL	THEN 1
					 WHEN cp_Asociado.IdPropietario IN (SELECT [STR] FROM dbo.uf_ListaATabla(@L_IdsPropietarioAsociado,',')) THEN 1
			    END = 1	
			AND CASE WHEN @L_IdsPropietarioRealizador IS NULL	THEN 1
					 WHEN cp_Realizado.IdPropietario IN (SELECT [STR] FROM dbo.uf_ListaATabla(@L_IdsPropietarioRealizador,',')) THEN 1
				END = 1 	
			
		GROUP BY 
			cp_Realizado.IdPropietario,
			CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME),
			con.IdContacto
			WITH ROLLUP
		HAVING 
			GROUPING(cp_Realizado.IdPropietario) 
			+ GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) 
			+ GROUPING(con.IdContacto) <= @L_NivelMostrar				 		
	
	ORDER BY 
	   -- NombrePropietarioRealizador,
	    GROUPING(cp_Realizado.IdPropietario), 
	    cp_Realizado.IdPropietario,
	    AgrupadoFecha, 
	    CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME) DESC, 
	    GROUPING(cp_Realizado.IdPropietario) + GROUPING(CAST(CONVERT(VARCHAR, con.Fecha, 103) AS SMALLDATETIME)) + GROUPING(con.IdContacto) ASC,
	    MAX(con.Hora) DESC	,
	    AgrupadoIdContacto


GO

-- Stored Procedure structure for dbo.up_bp_Personal_Select_Corto
CREATE PROCEDURE [dbo].[up_bp_Personal_Select_Corto] 
	(
	@IdPersonal INT = NULL,
	@IdSociedad INT = NULL,
	@Activo TINYINT = NULL,
	@NombreCompleto VARCHAR(250) = NULL,
	@IdSociedadExcluir INT = NULL,
	@IdComercialIncluir INT = NULL,
	@IdCentroTrabajo INT = NULL,
	@ConCodigoPersonal TINYINT = 0,
	@CadenaIdPersonal VARCHAR(250) = NULL,
	@CodigoTarjeta VARCHAR(50) = NULL
) 
AS
	SELECT 
		Per.IdPersonal as IdPersonal,
		/*Paula 14/06/2022 lo comento proque no existen estos campos
		CASE @ConCodigoPersonal 
			WHEN 0 THEN	
				ISNULL(Per.Nombre,'') + ' ' + ISNULL(Per.Apellidos,'') + ' ' + ISNULL(Per.Apellidos2,'') 
			ELSE 
				CASE WHEN ISNULL(per.codigoPersonal,'') = '' THEN ISNULL(per.CodigoPersonal,'') 
					 ELSE CodigoPersonal +' - ' 
				END  + ISNULL(Per.Nombre,'') + ' ' + ISNULL(Per.Apellidos,'') + ' ' + ISNULL(Per.Apellidos2,'')
		END AS NombreCompleto,*/
		ISNULL(Per.Nombre,'') + ' ' + ISNULL(Per.PrimerApellido,'') + ' ' + ISNULL(Per.SegundoApellido,'') AS NombreCompleto,
		null as IdSociedad
					
	FROM 
		dbo.gf_Personal Per
		
	WHERE 
		    (@IdPersonal IS NULL OR					Per.IdPersonal = @IdPersonal) 
		--AND (@IdSociedad IS NULL OR					Per.IdSociedad = @IdSociedad) 
		AND (@Activo IS NULL OR						Per.Activo = @Activo)
		
		/*AND (@NombreCompleto IS NULL OR				CASE @ConCodigoPersonal
													WHEN 0 THEN  ISNULL(Per.Nombre,'') + ' ' + ISNULL(Per.Apellidos,'') + ' ' + ISNULL(Per.Apellidos2,'') 
													ELSE ISNULL(per.codigoPersonal + '-','')  + ISNULL(Per.Nombre,'') + ' ' + ISNULL(Per.Apellidos,'') + ' ' + ISNULL(Per.Apellidos2,'')
													END	 LIKE '%' + @NombreCompleto + '%')*/

		AND (@NombreCompleto IS NULL OR				ISNULL(Per.Nombre,'') + ' ' + ISNULL(Per.PrimerApellido,'') + ' ' + ISNULL(Per.SegundoApellido,'') LIKE '%' + @NombreCompleto + '%')
		
		--AND (@IdSociedadExcluir IS NULL OR			per.idpersonal NOT IN (SELECT DISTINCT ISNULL(IdPersonal,0) FROM dbo.Comerciales WHERE IdSociedad = @IdSociedadExcluir AND IdComercial <> @IdComercialIncluir))
		--AND (@IdCentroTrabajo IS NULL OR			per.IdCentroTrabajo = @IdCentroTrabajo)
		AND (@CadenaIdPersonal IS NULL OR			per.idpersonal IN (SELECT [str] FROM dbo.uf_ListaATabla(@CadenaidPersonal,',')))
		--AND	(@CodigoTarjeta IS NULL OR				(per.CodigoPersonal = @CodigoTarjeta OR per.NumeroTarjeta = @CodigoTarjeta ))
		
		
	ORDER BY Nombre, PrimerApellido, SegundoApellido


GO

-- Stored Procedure structure for dbo.up_ControlPresencia_Select
CREATE PROCEDURE [dbo].[up_ControlPresencia_Select]
(
	@IdPersonal INT = NULL,
	@FechaFiltro DATE = NULL
)
AS
	SELECT
		F.IdControlPresenciaFichaje,
		F.IdPersonal,
		P.Nombre + ' ' + P.PrimerApellido AS NombreCompleto,
		F.FechaHora,
		F.IdControlPresenciaTipoEvento,
		T.Descripcion AS TipoEventoStr,
		F.IpDispositivo,
		F.Comentarios
	FROM
		dbo.ControlPresencia_Fichajes F
		INNER JOIN dbo.ControlPresencia_TiposEvento T
			ON F.IdControlPresenciaTipoEvento = T.IdControlPresenciaTipoEvento
		INNER JOIN dbo.gf_Personal P
			ON F.IdPersonal = P.IdPersonal
	WHERE
		(@IdPersonal IS NULL OR F.IdPersonal = @IdPersonal)
		AND (@FechaFiltro IS NULL OR CAST(F.FechaHora AS DATE) = @FechaFiltro)
	ORDER BY
		F.FechaHora DESC

GO

-- Stored Procedure structure for dbo.up_ControlPresencia_Insert
CREATE PROCEDURE [dbo].[up_ControlPresencia_Insert]
(
	@IdControlPresenciaFichaje INT OUTPUT,
	@IdPersonal INT,
	@IdControlPresenciaTipoEvento INT,
	@IpDispositivo VARCHAR(100) = NULL,
	@Comentarios VARCHAR(500) = NULL
)
AS
	INSERT INTO dbo.ControlPresencia_Fichajes
		(IdPersonal, IdControlPresenciaTipoEvento, IpDispositivo, Comentarios)
	VALUES
		(@IdPersonal, @IdControlPresenciaTipoEvento, @IpDispositivo, @Comentarios)

	SET @IdControlPresenciaFichaje = SCOPE_IDENTITY()

GO

-- Stored Procedure structure for dbo.up_ControlPresencia_Update
CREATE PROCEDURE [dbo].[up_ControlPresencia_Update]
(
	@IdControlPresenciaFichaje INT,
	@IdControlPresenciaTipoEvento INT = NULL,
	@FechaHora DATETIME = NULL,
	@Comentarios VARCHAR(500) = NULL
)
AS
	UPDATE dbo.ControlPresencia_Fichajes
	SET
		IdControlPresenciaTipoEvento = ISNULL(@IdControlPresenciaTipoEvento, IdControlPresenciaTipoEvento),
		FechaHora = ISNULL(@FechaHora, FechaHora),
		Comentarios = ISNULL(@Comentarios, Comentarios)
	WHERE
		IdControlPresenciaFichaje = @IdControlPresenciaFichaje

GO

-- Stored Procedure structure for dbo.up_ControlPresencia_Delete
CREATE PROCEDURE [dbo].[up_ControlPresencia_Delete]
(
	@IdControlPresenciaFichaje INT
)
AS
	DELETE FROM dbo.ControlPresencia_Fichajes
	WHERE IdControlPresenciaFichaje = @IdControlPresenciaFichaje

GO

-- Stored Procedure structure for dbo.up_bp_Tareas_Select
CREATE PROCEDURE [dbo].[up_bp_Tareas_Select]
(
	@IdTarea INT = NULL,
	@IdPersonalCreador  INT = NULL,
	@IdPersonalAsignado INT = NULL,
	@CadenaIdsTareaTipo VARCHAR(MAX)= NULL,
	@CadenaIdsTareaEstado VARCHAR(MAX)= NULL,

	@FechaCreacionDesde SMALLDATETIME = NULL,
	@FechaCreacionHasta SMALLDATETIME = NULL,

	@ConFechaPrevistaEntrega TINYINT = NULL,/*Sólo se filtra por fecha de entrega si en @ConFechaPrevistaEntrega se pasa un 1*/
	@FechaPrevistaEntregaDesde SMALLDATETIME = NULL,
	@FechaPrevistaEntregaHasta SMALLDATETIME = NULL,

	@Iniciada	 TINYINT = NULL,
    @FechaInicioDesde SMALLDATETIME = NULL, /*Sólo se filtra por fecha de inicio si en @Iniciada se pasa un 1*/
	@FechaInicioHasta SMALLDATETIME = NULL,

	@Finalizada  TINYINT = NULL,
    @FechaFinDesde  SMALLDATETIME = NULL, /*Sólo se filtra por fecha de fin si en @Finalizada se pasa un 1*/
	@FechaFinHasta  SMALLDATETIME = NULL,

	@Comprobada	 TINYINT = NULL,
    @FechaComprobacionDesde SMALLDATETIME = NULL, /*Sólo se filtra por fecha de comprobación si en @Comprobada se pasa un 1*/
	@FechaComprobacionHasta SMALLDATETIME = NULL,

	@ConTiempos TINYINT = NULL, 	
    @FechaTiemposDesde SMALLDATETIME = NULL,
	@FechaTiemposHasta SMALLDATETIME = NULL,

	@Descripcion   VARCHAR(MAX) = NULL,
	@Comentario    VARCHAR(MAX) = NULL,
	@Observaciones VARCHAR(MAX) = NULL,

	@IdCliente     INT = NULL,
	@CobrarAlCliente TINYINT = NULL,

	@IdPresupuesto INT = NULL,
	@IdPresupuestoLinea INT = NULL,
	@DescripcionPresupuesto   VARCHAR(MAX) = NULL,
	@DescripcionLineaPresupuesto VARCHAR(MAX) = NULL,

	@Albaraneada TINYINT = NULL, /* 0 - No  1 - Si */
	@IdAlbaran	 INT = NULL,
	@DescripcionLineaAlbaran VARCHAR(MAX) = NULL,
	
	@IdFacturaCliente INT = NULL,
	@DescripcionLineaFactura VARCHAR(MAX) = NULL,

	@CadenaIdsTareaExcluir VARCHAR(MAX) = NULL,
	@IdSociedad INT = NULL,
	@IdsPresupuesto VARCHAR(MAX) = NULL,
	@IdPersonalDepartamentoAsignado INT = NULL,
	@IdPersonalDepartamentoCreador INT = NULL,
	@Publicada TINYINT = NULL
)WITH RECOMPILE
AS	

	SELECT 
		0 AS Anadir,
		Tar.IdTarea,
		Tar.IdPersonal_Crea AS IdPersonalCreador,
		ISNULL(PerCre.Nombre, '') + ' ' + ISNULL(PerCre.PrimerApellido, '') + ' ' + ISNULL(PerCre.SegundoApellido, '') AS PersonalCreador,
		Tar.IdPersonal_Asigna AS IdPersonalAsignado,
		ISNULL(PerAsi.Nombre, '') + ' ' + ISNULL(PerAsi.PrimerApellido, '') + ' ' + ISNULL(PerAsi.SegundoApellido, '') AS PersonalAsignado,
		Tar.IdPersonalDepartamento,
		/*PerDep.Nombre*/ '' AS Departamento,
		Tar.IdTareaTipo,
		Tip.Nombre	AS TipoTarea,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR,Tar.Fecha, 103))		  AS FechaCreacion,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR, Tar.FIniciada, 103))   AS FechaInicio,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR, Tar.FRealizada, 103))  AS FechaFin,
		CONVERT(SMALLDATETIME,CONVERT(VARCHAR, Tar.FComprobada, 103)) AS FechaComprobacion,
		ISNULL(CONVERT(VARCHAR, Tar.FIniciada, 103)  ,'No') AS FechaInicioTexto,
		ISNULL(CONVERT(VARCHAR, Tar.FRealizada, 103) ,'No') AS FechaFinTexto,
		ISNULL(CONVERT(VARCHAR, Tar.FComprobada, 103),'No') AS FechaComprobacionTexto,
		CONVERT(VARCHAR,Tar.FechaPrevistaEntrega, 103) AS FechaPrevistaEntrega,
		CONVERT(VARCHAR,Tar.FechaEnEspera, 103) AS FechaEnEspera,
		ISNULL(Tar.HorasEstimadas,0) AS HorasEstimadas,
		ISNULL(Tiem.Total,0) AS HorasReales,
		Tar.Descripcion,
		Tar.Comentario,
		Tar.Observaciones,
		Tar.IdCliente,
		CASE WHEN ISNULL(Cli.NombreComercial,'') = '' THEN ISNULL(cli.RazonSocial,'') ELSE ISNULL(Cli.NombreComercial,'')END As Cliente,
		Tar.IdPresupuestoLinea,
		Pre.IdPresupuesto,
		ISNULL(PreT.CodigoTipo,'') + ' - ' + ISNULL(Pre.NumPresupuesto,'') + ' - ' + ISNULL(Pre.Descripcion,'')  AS Presupuesto,
		ISNULL(PreT.CodigoTipo,'') + ' - ' + ISNULL(Pre.NumPresupuesto,'') AS CodigoNumeroPresupuesto,
		ISNULL(PreLin.Descripcion,'') AS PresupuestoLinea,
		ISNULL(PreLin.NumOrden, 1) AS PresupuestoLineaNumeroOrden,
		Tar.Cobrar AS CobrarAlCliente,
		Tar.Prioridad,	
		ISNULL(Tar.Coste,0) AS CosteHora,
		CASE WHEN LEN(LTRIM(RTRIM(ISNULL(Tar.CarpetaTrabajo,'')))) > 0 THEN LTRIM(RTRIM(ISNULL(Tar.CarpetaTrabajo,'')))
			 ELSE LTRIM(RTRIM(ISNULL(PreLin.CarpetaTrabajo,'')))
		END AS CarpetaTrabajo,
		ISNULL(dbo.uf_bp_Tareas_Albaranes(Tar.IdTarea), 'No') AS Albaraneado,
		CONVERT(DECIMAL(12,2),ISNULL(Tar.HorasEstimadas,0) * ISNULL(tar.Coste,0)) AS ImporteCostesPrevistos, 
		CONVERT(DECIMAL(12,2),ISNULL(Tiem.Total,0) * ISNULL(tar.Coste,0)) AS ImporteCostesReales,
		CASE WHEN Tar.FComprobada IS NULL AND Tar.FRealizada IS NULL AND Tar.FechaEnEspera IS NOT NULL THEN 5 -- En Espera
			 WHEN Tar.FComprobada IS NOT NULL THEN	4 -- Comprobada
			 WHEN Tar.FRealizada IS NOT NULL THEN	3 -- Realizada
			 WHEN Tar.FIniciada IS NOT NULL THEN	2 -- Iniciada
			 ELSE									1 -- Asignada
	    END AS IdTareaEstado,
	    CASE WHEN tar.idPresupuesto IS NOT NULL THEN pre.idSociedad
			 ELSE NULL --PerAsi.idSociedad
	    END  AS IdSociedad,
	    tar.IdContacto,
	   /* CONVERT(VARCHAR, Con.Fecha, 103) + ' - ' + CONVERT(VARCHAR, Con.Fecha, 108) + ' - ' +
		PerCon.Nombre + ' ' + PerCon.apellidos + ' ' + PerCon.apellidos2 + ' - ' +
		TipCon.Nombre + ' - ' + CONVERT(VARCHAR(2000),Con.Observaciones)*/ '' /*Comentado Victor 02/03/2026*/ AS DescripcionContacto,
		CONVERT(VARCHAR, Tar.IdTarea) + CASE WHEN PreT.CodigoTipo IS NOT NULL THEN
											CASE WHEN Pre.NumPresupuesto IS NOT NULL THEN
												' (' + PreT.CodigoTipo + ' - ' + Pre.NumPresupuesto + ')'
											ELSE
												' (' + PreT.CodigoTipo + ')'
											END
										ELSE
											CASE WHEN Pre.NumPresupuesto IS NOT NULL THEN
												' (' + Pre.NumPresupuesto + ')'
											ELSE
												''
											END
										END AS CampoDescriptivoTarea, /* Nº tarea + Código presupuesto */
		tar.IdSociedad,
		tar.IdMaquina,
		ISNULL(maq.Codigo + '-','') + maq.Nombre AS Maquina,
		CASE WHEN Tar.FComprobada IS NULL AND Tar.FRealizada IS NULL AND Tar.FechaEnEspera IS NOT NULL THEN 'En Espera' --5
			 WHEN Tar.FComprobada IS NOT NULL THEN 'Comprobada' --4
			 WHEN Tar.FRealizada IS NOT NULL THEN 'Realizada' --3
			 WHEN Tar.FIniciada IS NOT NULL THEN 'Iniciada' --2
			 ELSE								 'Asignada' --1
	    END AS Estado,
	    ISNULL(Tar.FechaEnESpera,ISNULL(fcomprobada,ISNULL(tar.FRealizada,Tar.FIniciada))) AS FechaEstado,
	   ISNULL(vw_CosteMaterial.CosteMaterial,0) AS CosteMaterial, 
	    ISNULL(Tiem.Coste,0) AS CostePersonal,
		PerCre.email AS EmailPersonalCreador,
		PerAsi.email AS EmailPersonalAsignada,
		ISNULL(Tar.Publicada,0) AS Publicada,
		CASE 
			WHEN ISNULL(tar.Publicada,0)  = 0 THEN 'No'
			ELSE 'Sí'
		END AS PublicadaTexto
		
	FROM		dbo.Tareas					Tar
    INNER JOIN  dbo.gf_Personal				PerCre	ON Tar.IdPersonal_Crea = PerCre.IdPersonal
	INNER JOIN  dbo.gf_Personal				PerAsi	ON Tar.IdPersonal_Asigna = PerAsi.IdPersonal 
	INNER JOIN  dbo.gf_Clientes				Cli     ON Cli.IdCliente = Tar.IdCliente
	INNER JOIN  dbo.TareasTipos				Tip	    ON Tip.IdTareaTipo = Tar.IdTareaTipo
	LEFT  JOIN  dbo.vw_Tareas_Tiempos		Tiem	ON Tiem.IdTarea = Tar.IdTarea
    LEFT  JOIN  dbo.Presupuestos_Lineas		PreLin  ON PreLin.IdPresupuestoLinea = Tar.IdPresupuestoLinea 
	LEFT  JOIN  dbo.Presupuestos			Pre		ON PreLin.IdPresupuesto = Pre.IdPresupuesto      
	LEFT  JOIN  dbo.Presupuestos_Tipos		PreT	ON PreT.IdPresupuestoTipo = Pre.IdPresupuestoTipo
    --LEFT  JOIN  dbo.Personal_Departamentos	PerDep	ON PerDep.IdPersonalDepartamento = Tar.IdPersonalDepartamento
    --LEFT  JOIN	dbo.Contactos				Con		ON Con.IdContacto = Tar.IdContacto
    --LEFT  JOIN	dbo.gf_Personal				PerCon	ON PerCon.IdPersonal = Con.IdPersonal
    --LEFT  JOIN	dbo.Tipos					TipCon	ON TipCon.IdTipo = Con.IdTipoContacto
    LEFT  JOIN	dbo.Maquinas				maq		ON maq.IdMaquina = tar.IdMaquina
    LEFT  JOIN 
				(SELECT 
					    sum (Tarm.Importe) AS CosteMaterial,
						tarm.IdTareaOnix
				  FROM
					 dbo.TareasOnixMateriales    tarm
				GROUP BY IdTareaOnix) vw_CosteMaterial ON vw_CosteMaterial.IdTareaOnix = tar.idTarea
   
	WHERE
			(@IdTarea				 IS NULL OR      Tar.IdTarea = @IdTarea)
		AND	(@IdPersonalCreador		 IS NULL OR      Tar.IdPersonal_Crea = @IdPersonalCreador)
		AND	(@IdPersonalAsignado	 IS NULL OR      Tar.IdPersonal_Asigna = @IdPersonalAsignado)
		AND (@CadenaIdsTareaTipo	 IS NULL OR		 Tar.IdTareaTipo IN (SELECT [str] FROM dbo.uf_ListaATabla(@CadenaIdsTareaTipo, ',')))

		AND (@CadenaIdsTareaEstado	 IS NULL OR		 CASE WHEN Tar.FComprobada IS NULL AND Tar.FRealizada IS NULL AND Tar.FechaEnEspera IS NOT NULL THEN 5 -- En Espera
														  WHEN Tar.FComprobada IS NOT NULL THEN	4 -- Comprobada
														  WHEN Tar.FRealizada IS NOT NULL THEN	3 -- Realizada
														  WHEN Tar.FIniciada IS NOT NULL THEN	2 -- Iniciada
														  ELSE									1 -- Asignada
												     END IN (SELECT [str] FROM dbo.uf_ListaATabla(@CadenaIdsTareaEstado, ','))
			)

		AND	(@FechaCreacionDesde	IS NULL OR      CAST(CONVERT(VARCHAR, Tar.Fecha, 103) AS SMALLDATETIME) BETWEEN CAST(CONVERT(VARCHAR, @FechaCreacionDesde, 103) AS SMALLDATETIME) AND CAST(CONVERT(VARCHAR, @FechaCreacionHasta, 103) AS SMALLDATETIME))

		AND	(@ConFechaPrevistaEntrega IS NULL OR	(
															(@ConFechaPrevistaEntrega = 0   AND Tar.FechaPrevistaEntrega       IS NULL)		
														OR	(@ConFechaPrevistaEntrega = 1   AND (CAST(CONVERT(VARCHAR, tar.FechaPrevistaEntrega, 103) AS SMALLDATETIME) BETWEEN CAST(CONVERT(VARCHAR, @FechaPrevistaEntregaDesde, 103) AS SMALLDATETIME) AND CAST(CONVERT(VARCHAR, @FechaPrevistaEntregaHasta, 103) AS SMALLDATETIME)))
													 )
			)
		AND	(@Iniciada				 IS NULL OR		 (
															(@Iniciada = 0   AND Tar.FIniciada       IS NULL)		
														OR	(@Iniciada = 1   AND (CAST(CONVERT(VARCHAR, tar.FIniciada, 103) AS SMALLDATETIME) BETWEEN CAST(CONVERT(VARCHAR, @FechaInicioDesde, 103) AS SMALLDATETIME) AND CAST(CONVERT(VARCHAR, @FechaInicioHasta, 103) AS SMALLDATETIME)))
													 )
			)
		AND	(@Finalizada			 IS NULL OR	     (
															(@Finalizada = 0 AND Tar.FRealizada  IS NULL)		
														OR	(@Finalizada = 1 AND (CAST(CONVERT(VARCHAR, tar.FRealizada, 103) AS SMALLDATETIME) BETWEEN CAST(CONVERT(VARCHAR, @FechaFinDesde, 103) AS SMALLDATETIME) AND CAST(CONVERT(VARCHAR, @FechaFinHasta, 103) AS SMALLDATETIME)))
													 )
			)
		AND	(@Comprobada			 IS NULL OR		 (
															(@Comprobada = 0 AND Tar.FComprobada IS NULL)		
														OR	(@Comprobada = 1 AND (CAST(CONVERT(VARCHAR, Tar.FComprobada, 103) AS SMALLDATETIME) BETWEEN CAST(CONVERT(VARCHAR, @FechaComprobacionDesde, 103) AS SMALLDATETIME) AND CAST(CONVERT(VARCHAR, @FechaComprobacionHasta, 103) AS SMALLDATETIME)))
													  )
			)

		AND	(@ConTiempos			 IS NULL OR		 (
															(@ConTiempos = 0 AND NOT EXISTS (SELECT Tart.IdTarea FROM dbo.TareasTiempos Tart WHERE Tart.IdTarea = tar.IdTarea) )		
														OR	(@ConTiempos = 1 AND Tar.IdTarea IN (	SELECT DISTINCT	Tart.IdTarea 
																									FROM	dbo.TareasTiempos Tart 
																									WHERE  (@FechaTiemposDesde IS NULL OR  Tart.Fecha BETWEEN CAST(CONVERT(VARCHAR, @FechaTiemposDesde, 103) AS SMALLDATETIME)AND CAST(CONVERT(VARCHAR, @FechaTiemposHasta, 103) AS SMALLDATETIME) )
																								)
															)
													  )
			)
		AND	(@Descripcion					IS NULL OR	Tar.Descripcion LIKE '%' + @Descripcion + '%'COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI)
		AND	(@Comentario					IS NULL OR	Tar.Comentario LIKE '%' + @Comentario + '%'  COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI)
		AND	(@Observaciones					IS NULL OR  Tar.Observaciones LIKE '%' + @Observaciones + '%' COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI)
		AND	(@IdCliente						IS NULL OR  Tar.IdCliente = @IdCliente)
		AND	(@CobrarAlCliente				IS NULL OR  Tar.Cobrar = @CobrarAlCliente)

		AND (@IdPresupuesto					IS NULL OR	Tar.IdPresupuesto = @IdPresupuesto)
		AND	(@IdPresupuestoLinea			IS NULL OR	Tar.IdPresupuestoLinea = @IdPresupuestoLinea)
		AND	(@DescripcionPresupuesto		IS NULL OR  Pre.Descripcion LIKE '%' + @DescripcionPresupuesto + '%'COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI)
		AND (@DescripcionLineaPresupuesto	IS NULL OR  PreLin.Descripcion LIKE '%' + @DescripcionLineaPresupuesto + '%'COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI)

		AND (@Albaraneada			 IS NULL OR		 (		@Albaraneada = 0 
														AND NOT EXISTS (SELECT * FROM dbo.Albaranes_Lineas albL WHERE albL.IdTarea = tar.Idtarea)
														AND NOT EXISTS (SELECT * FROM dbo.Presupuestos_Lineas p_l
																				 INNER JOIN dbo.Albaranes_Lineas	a_l ON a_l.IdPresupuestoLinea = p_l.IdPresupuestoLinea
																				 WHERE p_l.IdPresupuestoLinea = Tar.IdPresupuestoLinea )
													 )
											 OR		 (		@Albaraneada = 1 
														AND (	EXISTS (SELECT * FROM dbo.Albaranes_Lineas albL WHERE albL.IdTarea = tar.Idtarea)
																OR 
																EXISTS (SELECT * FROM dbo.Presupuestos_Lineas p_l
																				 INNER JOIN dbo.Albaranes_Lineas	a_l ON a_l.IdPresupuestoLinea = p_l.IdPresupuestoLinea
																				 WHERE p_l.IdPresupuestoLinea = Tar.IdPresupuestoLinea )
															)
													 )
			)
		AND (@IdAlbaran				 IS NULL OR		 Tar.IdTarea IN (SELECT DISTINCT albL.IdTarea FROM dbo.Albaranes_Lineas albL WHERE albL.IdTarea IS NOT NULL AND albL.IdAlbaran = @IdAlbaran )
											 OR		 Tar.IdPresupuestoLinea IN ( SELECT DISTINCT p_l.IdPresupuestoLinea
																				 FROM		dbo.Presupuestos_Lineas p_l
																				 INNER JOIN dbo.Albaranes_Lineas	a_l ON a_l.IdPresupuestoLinea = p_l.IdPresupuestoLinea
																				 WHERE a_l.IdAlbaran = @IdAlbaran
																				)
			 )
		AND (@DescripcionLineaAlbaran	IS NULL OR	Tar.IdTarea IN (SELECT DISTINCT albL.IdTarea FROM dbo.Albaranes_Lineas albL WHERE  albL.IdTarea IS NOT NULL AND albL.Descripcion LIKE '%' + @DescripcionLineaAlbaran + '%'COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI  )
												OR	Tar.IdPresupuestoLinea IN ( SELECT DISTINCT p_l.IdPresupuestoLinea
																				 FROM		dbo.Presupuestos_Lineas p_l
																				 INNER JOIN dbo.Albaranes_Lineas	a_l ON a_l.IdPresupuestoLinea = p_l.IdPresupuestoLinea
																				 WHERE a_l.Descripcion LIKE '%' + @DescripcionLineaAlbaran + '%'COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI
																				)
			 )

		AND (@IdFacturaCliente				 IS NULL OR		 Tar.IdTarea IN (	SELECT		albL.IdTarea 
																		FROM		dbo.Albaranes_Lineas			albL 
																		INNER JOIN	dbo.FacturasClientes_Lineas		facL ON facL.IdAlbaranLinea = albL.IdAlbaranLinea
																		WHERE albL.IdTarea IS NOT NULL AND facL.IdFacturaCliente  = @IdFacturaCliente  
																	)
											 OR		 Tar.IdPresupuestoLinea IN ( SELECT		p_l.IdPresupuestoLinea
																				 FROM		dbo.Presupuestos_Lineas		p_l
																				 INNER JOIN dbo.Albaranes_Lineas		a_l ON a_l.IdPresupuestoLinea = p_l.IdPresupuestoLinea
																				 INNER JOIN	dbo.FacturasClientes_Lineas	facL ON facL.IdAlbaranLinea = a_l.IdAlbaranLinea
																				 WHERE facL.IdFacturaCliente = @IdFacturaCliente
																				)
			 )

		AND (@DescripcionLineaFactura				 IS NULL OR		 Tar.IdTarea IN (	SELECT		albL.IdTarea 
																		FROM		dbo.Albaranes_Lineas		albL 
																		INNER JOIN	dbo.FacturasClientes_Lineas	facL ON facL.IdAlbaranLinea = albL.IdAlbaranLinea
																		WHERE albL.IdTarea IS NOT NULL AND  facL.Concepto LIKE '%' + @DescripcionLineaFactura + '%'COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI
																	)
											 OR		 Tar.IdPresupuestoLinea IN ( SELECT		p_l.IdPresupuestoLinea
																				 FROM		dbo.Presupuestos_Lineas		p_l
																				 INNER JOIN dbo.Albaranes_Lineas		a_l ON a_l.IdPresupuestoLinea = p_l.IdPresupuestoLinea
																				 INNER JOIN	dbo.FacturasClientes_Lineas	facL ON facL.IdAlbaranLinea = a_l.IdAlbaranLinea
																				 WHERE  facL.Concepto LIKE '%' + @DescripcionLineaFactura + '%'COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI
																				)
			 )
		AND (@CadenaIdsTareaExcluir IS NULL OR Tar.IdTarea NOT IN (SELECT [str] FROM dbo.uf_ListaATabla(@CadenaIdsTareaExcluir, ',')) )
		AND	(@IdSociedad	IS NULL OR  tar.IdSociedad = @IdSociedad )
		AND (@IdsPresupuesto IS NULL OR Tar.IdPresupuesto IN (SELECT [str] FROM dbo.uf_ListaATabla(@IdsPresupuesto,',')))
		--AND (@IdPersonalDepartamentoAsignado IS NULL OR PerAsi.idpersonaldepartamento = @IdPersonalDepartamentoAsignado)
		--AND (@IdPersonalDepartamentoCreador IS NULL OR PerCre.idpersonaldepartamento = @IdPersonalDepartamentoCreador)
		AND (@Publicada IS NULL OR			ISNULL(tar.Publicada,0) = @Publicada)
	ORDER BY 
		CASE WHEN Tar.Prioridad IS NULL THEN '1' ELSE '0' END, 
		Tar.Prioridad, 
		Tar.Fecha DESC,
		Tar.Idtarea DESC





GO

-- Stored Procedure structure for dbo.up_bp_Tareas_Insert
CREATE PROCEDURE dbo.up_bp_Tareas_Insert
(
	@IdTarea INT OUTPUT,
	@IdPersonalCreador INT = NULL,
	@IdPersonalAsignado INT = NULL,
	@IdTareaTipo INT = NULL,
	@FechaCreacion SMALLDATETIME = NULL,
	@FechaInicio SMALLDATETIME = NULL,
	@FechaFin SMALLDATETIME = NULL,
	@FechaComprobacion SMALLDATETIME = NULL,
	@FechaPrevistaEntrega SMALLDATETIME = NULL,
	@FechaEnEspera SMALLDATETIME = NULL,
	
	@Descripcion VARCHAR(2000) = NULL,
	@Comentario VARCHAR(2000) = NULL,
	@Observaciones VARCHAR(2000) = NULL,
	@CarpetaTrabajo VARCHAR(500) = NULL,

	@HorasEstimadas FLOAT = NULL,

	@IdCliente INT = NULL,
	@CobrarAlCliente TINYINT = 0,
	@IdPresupuesto INT = NULL,
	@IdPresupuestoLinea INT = NULL,

	@IdPersonalDepartamento INT = NULL,
	@IdContacto INT = NULL,
	@IdIdentidad INT = NULL,
	@IdSociedad INT = NULL,
	@IdMaquina INT  = NULL
)
AS

	DECLARE @Prioridad TINYINT
	DECLARE @CosteHora DECIMAL (12,2) = 0

	--SELECT @CosteHora = ISNULL(CosteHora,0) FROM dbo.gf_Personal WHERE IdPersonal = @IdPersonalAsignado Victor 02/03/2026 (no existe el campo de coste)

	SET @Prioridad = 1

	SELECT @Prioridad = MAX(ISNULL( Prioridad ,0)) + 1 FROM dbo.Tareas WHERE IdPersonal_Asigna = @IdPersonalAsignado
	
	IF @IdSociedad IS NULL 
		BEGIN
			IF @IdPresupuesto IS NOT NULL 
				SELECT @IdSociedad = idSociedad FROM dbo.Presupuestos WHERE idPresupuesto  = @IdPresupuesto
			ELSE
				SELECT @IdSociedad = idSociedad FROM dbo.gf_Personal_Sociedades_Departamentos WHERE idpersonal = @IdPersonalCreador
		END

	IF @IdPresupuestoLinea IS NOT NULL 
		BEGIN
			DECLARE @PermitirCrearTareas TINYINT
	
			EXEC @PermitirCrearTareas = dbo.up_bp_Presupuestos_Lineas_Select_PermitirCrearTareas @IdPresupuestoLinea
			
			IF @PermitirCrearTareas = 0 
				BEGIN
					RAISERROR ('No puede asignar tareas a una presupuesto ya albaraneado.',16,1)
					RETURN
				END
		END 

	INSERT INTO
		dbo.Tareas
		(
			IdPersonal_Crea,
			IdPersonal_Asigna,
			Fecha,
			FIniciada,
			FRealizada,
			FComprobada,
			HorasEstimadas,
			Descripcion,
			Comentario,
			IdCliente,
			IdPresupuesto,
			IdPersonalDepartamento,
			IdTareaTipo,
			Cobrar,
			IdPresupuestoLinea,
			Prioridad,
			Coste,
			FechaPrevistaEntrega,
			FechaEnEspera,
			CarpetaTrabajo,
			Observaciones,
			IdContacto,
			IdIdentidad,
			FechaModificacion,
			IdSociedad,
			IdMaquina
		)
	VALUES
		(
			@IdPersonalCreador,
			@IdPersonalAsignado,
			CAST(CONVERT(VARCHAR, @FechaCreacion, 103) AS SMALLDATETIME),
			CAST(CONVERT(VARCHAR, @FechaInicio, 103) AS SMALLDATETIME),
			CAST(CONVERT(VARCHAR, @FechaFin, 103) AS SMALLDATETIME),
			CAST(CONVERT(VARCHAR, @FechaComprobacion, 103) AS SMALLDATETIME),
			@HorasEstimadas,
			@Descripcion,
			@Comentario,
			@IdCliente,
			@IdPresupuesto,
			@IdPersonalDepartamento,
			@IdTareaTipo,
			@CobrarAlCliente,
			@IdPresupuestoLinea,
			CASE WHEN @FechaFin IS NULL AND @FechaComprobacion IS NULL THEN @Prioridad ELSE NULL END,
			@CosteHora,
			CAST(CONVERT(VARCHAR, @FechaPrevistaEntrega, 103) AS SMALLDATETIME),
			CAST(CONVERT(VARCHAR, @FechaEnEspera, 103) AS SMALLDATETIME),
			@CarpetaTrabajo,
			@Observaciones,
			@IdContacto,
			@IdIdentidad,
			GETDATE(),
			@IdSociedad,
			@IdMaquina
		)

	SET @IdTarea = SCOPE_IDENTITY()
	
	IF (SELECT DB_NAME()) = 'OnixInteco' AND @IdPersonalDepartamento = 21
	BEGIN
		DECLARE @Cliente VARCHAR(150) = ''
		DECLARE @Email VARCHAR (350) = ''
		SELECT @Email = ISNULL(c.Email,''), @Cliente = c.NombreComercial FROM dbo.gf_Clientes AS c WHERE c.idCliente = @IdCliente
		IF LEN (@Email) >0
		BEGIN
			DECLARE @NumeroTarea AS VARCHAR(15)
			SET @NumeroTarea = CONVERT(varchar(15),@IdTarea)
			IF @FechaFin IS NULL 
			BEGIN	
			EXECUTE dbo.up_bp_Tareas_EnviarEmail @InicioFin = 0,    -- int
												 @Descripcion = @Descripcion, -- varchar(2000)
												 @Email = @Email,       -- varchar(350)
												 @Cliente = @Cliente,     -- varchar(150)
												 @NumeroTarea = @NumeroTarea -- varchar(15)
			END
			ELSE
			--IF @FechaFin IS NOT NULL
			BEGIN
				EXECUTE dbo.up_bp_Tareas_EnviarEmail @InicioFin = 1,    -- int
												 @Descripcion = @Descripcion, -- varchar(2000)
												 @Email = @Email,       -- varchar(350)
												 @Cliente = @Cliente,     -- varchar(150)
												 @NumeroTarea = @NumeroTarea  -- varchar(15)
            END
		END 
	END 

	-- Actualizar prioridades (Hacemos esto por si hay algún error en las prioridades se corrige)	
	EXEC up_bp_Tareas_Update_Prioridad @IdTarea

	-- Actualizamos los costes del presupuesto
	IF ISNULL(@IdPresupuesto,0) > 0
		BEGIN
			EXEC dbo.up_bp_Presupuestos_Update_EstudioCostesPorIdPresupuesto @IdPresupuesto
		END


GO

-- Stored Procedure structure for dbo.up_bp_Tareas_Delete
CREATE PROCEDURE dbo.up_bp_Tareas_Delete
(
	@IdTarea INT
)
AS

	DECLARE @IdPresupuesto INT 

	SELECT	@IdPresupuesto = ISNULL( IdPresupuesto ,0)
	FROM	dbo.Tareas
	WHERE	IdTarea = @IdTarea

	IF EXISTS (SELECT * FROM dbo.TareasTiempos WHERE IdTarea = @IdTarea )
		BEGIN
			RAISERROR ('No puede eliminar la tarea seleccionada porque tiene tiempos asignados.', 16, 1) 
			RETURN
		END 
	
	BEGIN TRAN

		EXEC up_bp_Tareas_Update_Prioridad @IdTarea, 0, 0, 1

		DELETE dbo.Documentos  WHERE IdDocumentoTipo = 2 and IdRegistro = @IdTarea

		DELETE dbo.Tareas WHERE	IdTarea = @IdTarea
		
		-- Actualizamos los costes del presupuesto
		IF @IdPresupuesto > 0
			BEGIN
				EXEC dbo.up_bp_Presupuestos_Update_EstudioCostesPorIdPresupuesto @IdPresupuesto
			END

	IF @@ERROR = 0
	BEGIN
		COMMIT TRAN
	END
	ELSE
	BEGIN
		ROLLBACK TRAN
	END
	

GO

-- Stored Procedure structure for dbo.up_bp_TareasTiempos_Insert
CREATE PROCEDURE dbo.up_bp_TareasTiempos_Insert
(
	@IdTareaTiempo INT OUTPUT,
	@IdTarea INT = NULL,
	@Fecha SMALLDATETIME = NULL,
	@Horas DECIMAL(12, 2) = NULL,
	@Comentario VARCHAR(MAX) = NULL,
	@IdIdentidad INT = NULL,
	@IdTiempo INT = NULL OUTPUT	
)
AS
	DECLARE @IdPresupuesto INT 
	DECLARE @PermitirAsignarTiempos TINYINT
	
	DECLARE @IdPersonal INT
	DECLARE @IdSociedad INT
	DECLARE @IdCentroTrabajo INT
	
	EXEC @PermitirAsignarTiempos = dbo.up_bp_Tareas_Select_PermitirAsignarTiempos @IdTarea
	
	SELECT	@IdPresupuesto = ISNULL( IdPresupuesto ,0),@IdPersonal = ISNULL(idPersonal_Asigna,0)
	FROM	dbo.Tareas
	WHERE	IdTarea = @IdTarea

	IF @IdPersonal > 0 
		SELECT @IdSociedad = IdSociedad,@IdCentroTrabajo = NULL--IdCentroTrabajo 
		FROM dbo.gf_Personal_Sociedades_Departamentos 
		 
	    WHERE idpersonal = @IdPersonal
	
	IF @PermitirAsignarTiempos = 1
		BEGIN

			INSERT INTO
				dbo.TareasTiempos
				(
					IdTarea,
					Fecha,
					Horas,
					Comentario,
					IdIdentidad,
					FechaModificacion
				)
			VALUES
				(
					@IdTarea,
					CAST(CONVERT(VARCHAR, @Fecha, 103) AS SMALLDATETIME),
					@Horas,
					@Comentario,
					@IdIdentidad,
					CAST(CONVERT(VARCHAR, GETDATE(), 103) AS SMALLDATETIME)
				)

			SET @IdTareaTiempo = SCOPE_IDENTITY()
			
			-- Actualizamos los costes del presupuesto
			IF @IdPresupuesto > 0
				BEGIN
					EXEC dbo.up_bp_Presupuestos_Update_EstudioCostesPorIdPresupuesto @IdPresupuesto
				END
			
			--insertamos en la tabla de tiempos	
			IF @IdPersonal > 0 
			  BEGIN
			    DECLARE @FechaFin SMALLDATETIME 
			    DECLARE @Duracion INT
			    SET @FechaFin = DATEADD(HOUR,@Horas,@Fecha)
			    SET @Duracion = CONVERT(DECIMAL(10,2),@Horas) * 60
				EXEC dbo.up_Tiempos_Insert   @IdTiempo = @IdTiempo OUTPUT,				 @IdSociedad = @IdSociedad,		@IdCentroTrabajo = @IdCentroTrabajo,
										     @IdPersonal = @IdPersonal,  @FechaInicio =  @Fecha,		@FechaFin = @FechaFin,
											 @TipoMaquinaPersona = 0,    @Duracion = @Duracion	,		@IdTareaGenerico = @IdTarea , @InsertarConProcedimientoTareas = 0, @IdTareaTiempo = @IdTareaTiempo
			 END
		END
	ELSE
		BEGIN
			RAISERROR ('No puede asignar tiempos a una tarea ya albaraneada.',16,1)
		END 


GO

