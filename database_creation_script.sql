-- =========================================================================
-- DATABASE CREATION SCRIPT FOR TareasGForma
-- Generated recursively from w2019-sql / GestionFormacion
-- Date: 2026-05-20T12:33:16.380Z
-- =========================================================================

CREATE DATABASE TareasGForma;
GO
USE TareasGForma;
GO

-- Table structure for dbo.Albaranes
CREATE TABLE dbo.Albaranes (
  [idAlbaran] INT IDENTITY(1,1) NOT NULL,
  [NumAlbaran] VARCHAR(50) NULL,
  [FechaEmision] SMALLDATETIME NULL,
  [idCliente] INT NULL,
  [Descripcion] VARCHAR(150) NULL,
  [FechaEntrega] SMALLDATETIME NULL,
  [Importe] MONEY NULL,
  [idSociedad] INT NULL,
  [IdAlmacen] INT NULL,
  [IdDireccionEnvio] INT NULL,
  [TipoOrigenDireccionEnvio] TINYINT NOT NULL DEFAULT ((1)),
  [NombreDireccionEnvio] VARCHAR(200) NULL,
  [Direccion] VARCHAR(100) NULL,
  [Poblacion] VARCHAR(100) NULL,
  [CodigoPostal] VARCHAR(20) NULL,
  [IdProvincia] INT NULL,
  [IdPais] INT NULL,
  [Telefono] VARCHAR(20) NULL,
  [Fax] VARCHAR(20) NULL,
  [Email] VARCHAR(320) NULL,
  [Horario] VARCHAR(MAX) NULL,
  [PersonaContacto] VARCHAR(200) NULL,
  [Observaciones] VARCHAR(MAX) NULL,
  [IdPersonaContacto] INT NULL,
  [IdProveedorPortes] INT NULL,
  [NumBultos] VARCHAR(50) NULL,
  [Latitud] VARCHAR(50) NULL,
  [Longitud] VARCHAR(50) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdMonedaCliente] INT NULL,
  [IdMonedaSociedad] INT NULL,
  [FactorConversionMonedaSociedad] MONEY NULL,
  [FactorConversionMonedaCliente] MONEY NULL,
  [IdIdentidadInsert] INT NULL,
  [FechaInsert] SMALLDATETIME NULL,
  [IdComercial] INT NULL,
  [FechaAFacturar] SMALLDATETIME NULL,
  [FechaFacturadoParcial] SMALLDATETIME NULL,
  [FechaFacturadoTotal] SMALLDATETIME NULL,
  [IdProyecto] INT NULL,
  [IdPresupuesto] INT NULL,
  [IdTipoDocumento] INT NULL,
  [NumeroSeguimiento] VARCHAR(50) NULL,
  [IdMaquina] INT NULL,
  [IdFormaPago] INT NULL,
  [DescPago] FLOAT NULL,
  [DescCantidad] FLOAT NULL,
  [OtrosDesc] FLOAT NULL,
  [NombreFiscalCliente] VARCHAR(150) NULL,
  [NombreComercialCliente] VARCHAR(150) NULL,
  [IdTipoCif] INT NULL,
  [Cif] VARCHAR(20) NULL,
  [ObservacionesDocumentosVenta] VARCHAR(MAX) NULL,
  [IdProyectoTarea] INT NULL,
  [IdTipoTarifa] INT NULL,
  [IdTesoreria] INT NULL,
  [PortesPagados] TINYINT NULL,
  [Referencia] VARCHAR(50) NULL,
  [Referencia2] VARCHAR(50) NULL,
  [DescuentoCascada] TINYINT NULL,
  [IdSerie] INT NULL,
  [NumeroSerie] INT NULL,
  [Puntos] FLOAT NULL,
  [ConRecargoEquivalencia] TINYINT NULL,
  [IdClienteContado] INT NULL,
  [FechaAnulado] SMALLDATETIME NULL,
  [IdCentroTrabajo] INT NULL,
  [IdVendedor] INT NULL,
  [FormaCalculoAlbaran] TINYINT NULL,
  [IdTipoRuta] INT NULL,
  PRIMARY KEY ([idAlbaran])
);
GO

-- Table structure for dbo.Albaranes_Lineas
CREATE TABLE dbo.Albaranes_Lineas (
  [idAlbaranLinea] INT IDENTITY(1,1) NOT NULL,
  [idAlbaran] INT NULL,
  [NumOrden] INT NULL,
  [Descripcion] VARCHAR(2000) NULL,
  [Cantidad] FLOAT NULL,
  [idUnidadMedida] INT NULL,
  [Precio] MONEY NULL,
  [Descuento] FLOAT NULL,
  [idArticulo] INT NULL,
  [idPresupuestoLinea] INT NULL,
  [idTarea] INT NULL,
  [IdLote] INT NULL,
  [IdUnidadMedidaCliente] INT NULL,
  [FactorConversionUnidad] FLOAT NULL,
  [CantidadCliente] FLOAT NULL,
  [PrecioCliente] MONEY NULL,
  [IdArticuloAtributoConjunto] INT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [FactorConversionRespectoPrimeraUnidad] FLOAT NULL DEFAULT ((1)),
  [Importe] MONEY NULL,
  [IdArticuloReferencia] INT NULL,
  [Codigo] VARCHAR(50) NULL,
  [IdTarifaLineaComision] INT NULL,
  [Comision] FLOAT NULL,
  [IdIdentidadInsert] INT NULL,
  [FechaInsert] SMALLDATETIME NULL,
  [IdIva] INT NULL,
  [IdRetencion] INT NULL,
  [Porc_Iva] FLOAT NULL,
  [Porc_Recargo] FLOAT NULL,
  [Porc_Retencion] FLOAT NULL,
  [TipoDescuento1] TINYINT NULL,
  [TipoDescuento2] TINYINT NULL,
  [Porc_Descuento1] FLOAT NULL,
  [Porc_Descuento2] FLOAT NULL,
  [TipoBase] TINYINT NULL,
  [IdDeposito] INT NULL,
  [Coste] FLOAT NULL,
  [CosteModificado] TINYINT NULL,
  [IdAlbaranLineaPadre] INT NULL,
  [Cajas] INT NULL,
  [PesoBruto] FLOAT NULL,
  [CantidadPaquete] FLOAT NULL,
  [PesoPaquete] FLOAT NULL,
  [Puntos] FLOAT NULL,
  [DescuentoPuntos] FLOAT NULL,
  [Oferta] TINYINT NULL,
  PRIMARY KEY ([idAlbaranLinea])
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

-- Table structure for dbo.ContactosClasificaciones
CREATE TABLE dbo.ContactosClasificaciones (
  [IdContactoClasificacion] INT IDENTITY(1,1) NOT NULL,
  [Nombre] VARCHAR(200) NULL,
  [Descripcion] VARCHAR(300) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [ValidoSoloAsociadosIndicados] TINYINT NULL,
  [Activo] TINYINT NULL,
  PRIMARY KEY ([IdContactoClasificacion])
);
GO

-- Table structure for dbo.ContactosTiposPropietarios
CREATE TABLE dbo.ContactosTiposPropietarios (
  [IdTipoPropietario] INT NOT NULL,
  [IdTipo] INT NOT NULL,
  [Nombre] VARCHAR(100) NOT NULL,
  [Tabla] VARCHAR(200) NOT NULL,
  [CampoId] VARCHAR(200) NOT NULL,
  [CampoMostrar] VARCHAR(200) NOT NULL,
  [ProcedimientoSelect] VARCHAR(300) NOT NULL,
  [RegistroId] VARCHAR(150) NOT NULL,
  [RegistroMostrar] VARCHAR(150) NOT NULL,
  [ParametroBuscar] VARCHAR(150) NOT NULL,
  [Formulario] VARCHAR(150) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdTipoPropietarioSubasociado] INT NULL,
  [CampoIdSubasociado] NVARCHAR(200) NULL,
  [CampoTelefono] VARCHAR(200) NULL,
  [RegistroTelefono] VARCHAR(200) NULL,
  [ParametroId] VARCHAR(150) NULL,
  [ProcedimientoSelectWeb] VARCHAR(300) NULL,
  PRIMARY KEY ([IdTipoPropietario])
);
GO

-- Table structure for dbo.Contactos_Propietarios
CREATE TABLE dbo.Contactos_Propietarios (
  [IdContactoPropietario] INT IDENTITY(1,1) NOT NULL,
  [IdContacto] INT NULL,
  [IdPropietario] INT NULL,
  [IdTipoPropietario] INT NULL,
  PRIMARY KEY ([IdContactoPropietario])
);
GO

-- Table structure for dbo.ControlPresencia_Fichajes
CREATE TABLE dbo.ControlPresencia_Fichajes (
  [IdControlPresenciaFichaje] INT IDENTITY(1,1) NOT NULL,
  [IdPersonal] INT NOT NULL,
  [FechaHora] DATETIME NOT NULL DEFAULT (getdate()),
  [IdControlPresenciaTipoEvento] INT NOT NULL,
  [IpDispositivo] VARCHAR(100) NULL,
  [Comentarios] VARCHAR(500) NULL,
  PRIMARY KEY ([IdControlPresenciaFichaje])
);
GO

-- Table structure for dbo.ControlPresencia_TiposEvento
CREATE TABLE dbo.ControlPresencia_TiposEvento (
  [IdControlPresenciaTipoEvento] INT NOT NULL,
  [Descripcion] VARCHAR(50) NOT NULL,
  PRIMARY KEY ([IdControlPresenciaTipoEvento])
);
GO

-- Table structure for dbo.DireccionesEnvio
CREATE TABLE dbo.DireccionesEnvio (
  [IdDireccionEnvio] INT IDENTITY(1,1) NOT NULL,
  [Nombre] VARCHAR(150) NULL,
  [Direccion] VARCHAR(100) NULL,
  [IdPais] INT NULL,
  [IdProvincia] INT NULL,
  [Poblacion] VARCHAR(100) NULL,
  [CP] VARCHAR(10) NULL,
  [Telefono] VARCHAR(20) NULL,
  [Fax] VARCHAR(20) NULL,
  [Email] VARCHAR(100) NULL,
  [Horario] VARCHAR(100) NOT NULL,
  [PersonaContacto] VARCHAR(100) NULL,
  [Observaciones] VARCHAR(250) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] DATETIME NULL,
  [Latitud] VARCHAR(50) NULL,
  [Longitud] VARCHAR(50) NULL,
  [IdTipoRuta] INT NULL,
  PRIMARY KEY ([IdDireccionEnvio])
);
GO

-- Table structure for dbo.Documentos
CREATE TABLE dbo.Documentos (
  [idDocumento] INT IDENTITY(1,1) NOT NULL,
  [idRegistro] INT NULL,
  [idDocumentoTipo] INT NULL,
  [Nombre] VARCHAR(100) NULL,
  [TipoDoc] VARCHAR(10) NULL,
  [Ruta] VARCHAR(300) NULL,
  [PasadoArchivos] TINYINT NULL,
  [IdArchivo] INT NULL,
  PRIMARY KEY ([idDocumento])
);
GO

-- Table structure for dbo.FacturasClientes
CREATE TABLE dbo.FacturasClientes (
  [idFacturaCliente] INT IDENTITY(1,1) NOT NULL,
  [NumFactura] VARCHAR(50) NULL,
  [idSociedad] INT NULL,
  [idMoneda] INT NULL,
  [ConversionMoneda] MONEY NULL,
  [FechaFactura] SMALLDATETIME NULL,
  [idCliente] INT NULL,
  [Concepto] VARCHAR(400) NULL,
  [idFacturaClienteTipo] INT NULL,
  [DescPago] FLOAT NULL,
  [DescCantidad] FLOAT NULL,
  [OtrosDesc] FLOAT NULL,
  [Rectificativa] TINYINT NULL,
  [BaseImponible] MONEY NULL,
  [IVA] MONEY NULL,
  [Total_Con_IVA] MONEY NULL,
  [Retencion] MONEY NULL,
  [Observaciones] VARCHAR(1000) NULL,
  [CondicionesPago] VARCHAR(255) NULL,
  [Validado] TINYINT NOT NULL DEFAULT ((0)),
  [ExportacionExterna] TINYINT NOT NULL DEFAULT ((0)),
  [DireccionEnvioDiferente] TINYINT NOT NULL DEFAULT ((0)),
  [DEDAtencionDe] VARCHAR(100) NULL,
  [DEDDireccion] VARCHAR(255) NULL,
  [DEDPoblacion] VARCHAR(100) NULL,
  [DEDCP] VARCHAR(50) NULL,
  [DEDIdProvincia] INT NULL,
  [DEDIdPais] INT NULL,
  [Exportada] TINYINT NULL DEFAULT ((0)),
  [IdFormaPago] INT NULL,
  [IdDireccionEnvio] INT NULL,
  [NombreDireccionEnvio] VARCHAR(200) NULL,
  [Telefono] VARCHAR(20) NULL,
  [Fax] VARCHAR(20) NULL,
  [Email] VARCHAR(320) NULL,
  [Horario] VARCHAR(MAX) NULL,
  [PersonaContacto] VARCHAR(200) NULL,
  [DEDObservaciones] VARCHAR(MAX) NULL,
  [FechaTipoCambio] SMALLDATETIME NULL,
  [IdPersonaContacto] INT NULL,
  [SerieDelante] VARCHAR(25) NULL,
  [SerieDetras] VARCHAR(25) NULL,
  [DEDLatitud] VARCHAR(50) NULL,
  [DEDLongitud] VARCHAR(50) NULL,
  [IdTipoPeriodoFacturacionPeriodica] INT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdIdentidadInsert] INT NULL,
  [FechaInsert] SMALLDATETIME NULL,
  [IdComercial] INT NULL,
  [ConRecargoEquivalencia] TINYINT NULL,
  [IdProyecto] INT NULL,
  [FormaCalculo] TINYINT NULL,
  [LineaResumen] VARCHAR(2000) NULL,
  [NoVisualizarLineasFactura] TINYINT NULL,
  [NombreFiscalCliente] VARCHAR(150) NULL,
  [NombreComercialCliente] VARCHAR(150) NULL,
  [Cif] VARCHAR(20) NULL,
  [IdTipoCif] INT NULL,
  [ObservacionesDocumentosVenta] VARCHAR(MAX) NULL,
  [IdProyectoTarea] INT NULL,
  [IdTipoTarifa] INT NULL,
  [IdTesoreria] INT NULL,
  [PortesPagados] TINYINT NULL,
  [Referencia] VARCHAR(50) NULL,
  [DescuentoCascada] TINYINT NULL,
  [IdSerie] INT NULL,
  [NumeroSerie] INT NULL,
  [IdClienteContado] INT NULL,
  [Enviada] TINYINT NULL,
  [Puntos] FLOAT NULL,
  [IvaSinRecargo] MONEY NULL,
  [Recargo] MONEY NULL,
  [IdTpv] INT NULL,
  [IdMonedaCliente] INT NULL,
  [ConversionCliente] MONEY NULL,
  [IdCentroTrabajo] INT NULL,
  [IdFacturaClienteOrigen] INT NULL,
  [Abono] TINYINT NULL,
  [IdTipoRuta] INT NULL,
  [IdTipoEntorno] INT NULL,
  [IdTipoFactura] INT NULL,
  [CodigoQR] VARBINARY NULL,
  [Huella] VARCHAR(64) NULL,
  [HuellaAnterior] VARCHAR(64) NULL,
  [FechaHoraHusoGenRegistro] DATETIMEOFFSET NULL,
  PRIMARY KEY ([idFacturaCliente])
);
GO

-- Table structure for dbo.FacturasClientes_Lineas
CREATE TABLE dbo.FacturasClientes_Lineas (
  [idFacturaClienteLinea] INT IDENTITY(1,1) NOT NULL,
  [idFacturaCliente] INT NULL,
  [Cantidad] FLOAT NOT NULL DEFAULT ((0)),
  [idUnidadMedida] INT NULL,
  [Precio] MONEY NOT NULL DEFAULT ((0)),
  [Descuento] FLOAT NOT NULL DEFAULT ((0)),
  [idIVA] INT NULL,
  [idRetencion] INT NULL,
  [NumOrden] INT NULL,
  [Porc_IVA] FLOAT NULL,
  [Porc_Recargo] FLOAT NULL,
  [Porc_Retencion] FLOAT NULL,
  [idArticulo] INT NULL,
  [idAlbaranLinea] INT NULL,
  [idmantenimientocliente] INT NULL,
  [Concepto] VARCHAR(2000) NULL,
  [IdCuentaContable] INT NULL,
  [IdFacturacionPeriodica] INT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [Importe] MONEY NULL,
  [IdArticuloReferencia] INT NULL,
  [Codigo] VARCHAR(50) NULL,
  [IdTarifaLineaComision] INT NULL,
  [Comision] FLOAT NULL,
  [IdIdentidadInsert] INT NULL,
  [FechaInsert] SMALLDATETIME NULL,
  [TipoDescuento1] TINYINT NULL,
  [TipoDescuento2] TINYINT NULL,
  [Porc_Descuento1] FLOAT NULL,
  [Porc_Descuento2] FLOAT NULL,
  [TipoBase] TINYINT NULL,
  [IdUnidadMedidaEmpresa] INT NULL,
  [CantidadEmpresa] FLOAT NULL,
  [IdAlbaranLogisticoLinea] INT NULL,
  [Coste] FLOAT NULL,
  [CosteModificado] TINYINT NULL,
  [Puntos] FLOAT NULL,
  [DescuentoPuntos] FLOAT NULL,
  [IdTpvLinea] INT NULL,
  [IdArticuloAtributoConjunto] INT NULL,
  [PrecioCliente] MONEY NULL,
  [CantidadCliente] FLOAT NULL,
  [IdUnidadMedidaCliente] INT NULL,
  [FactorConversionUnidad] FLOAT NULL,
  PRIMARY KEY ([idFacturaClienteLinea])
);
GO

-- Table structure for dbo.FacturasProveedores_Lineas
CREATE TABLE dbo.FacturasProveedores_Lineas (
  [idFacturaProveedorLinea] INT IDENTITY(1,1) NOT NULL,
  [idFacturaProveedor] INT NULL,
  [Concepto] VARCHAR(1000) NULL,
  [Cantidad] FLOAT NULL,
  [Precio] MONEY NULL,
  [Descuento] FLOAT NULL,
  [idIVA] INT NULL,
  [idRetencion] INT NULL,
  [idProveedorIVA] INT NULL,
  [NumOrden] INT NULL,
  [Porc_IVA] FLOAT NULL,
  [Porc_Recargo] FLOAT NULL,
  [Porc_Retencion] FLOAT NULL,
  [Inmovilizado] TINYINT NOT NULL DEFAULT ((0)),
  [idArticulo] INT NULL,
  [idAmortizacionTipo] INT NULL,
  [idAlbaranProveedorLinea] INT NULL,
  [idUnidadMedida] INT NULL,
  [IdCuentaContable] INT NULL,
  [ValorResidual] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [FechaInicioAmortizacion] SMALLDATETIME NULL,
  [IdIVARepercutido] INT NULL,
  [PorcentajeIVARepercutido] DECIMAL(12, 2) NULL,
  [PorcentajeRecargoRepercutido] DECIMAL(12, 2) NULL,
  [IdArticuloProveedor] INT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdProyecto] INT NULL,
  [IdIdentidadInsert] INT NULL,
  [FechaInsert] SMALLDATETIME NULL,
  [TipoDescuento1] TINYINT NULL,
  [TipoDescuento2] TINYINT NULL,
  [Porc_Descuento1] FLOAT NULL,
  [Porc_Descuento2] FLOAT NULL,
  [TipoBase] TINYINT NULL,
  [IdProyectoTarea] INT NULL,
  [CantidadProveedor] FLOAT NULL,
  [IdUnidadMedidaProveedor] INT NULL,
  [FactorConversionUnidad] FLOAT NULL,
  [PrecioProveedor] MONEY NULL,
  [FactorConversionRespectoPrimeraUnidad] FLOAT NULL,
  [IdArticuloAtributoConjunto] INT NULL,
  [PrecioProveedorCompleto] FLOAT NULL,
  [PrecioCompleto] FLOAT NULL,
  PRIMARY KEY ([idFacturaProveedorLinea])
);
GO

-- Table structure for dbo.Facturasclientes_Vencimientos
CREATE TABLE dbo.Facturasclientes_Vencimientos (
  [idFacturaClienteVencimiento] INT IDENTITY(1,1) NOT NULL,
  [idFacturaCliente] INT NULL,
  [NumVencimiento] INT NULL,
  [Fecha] SMALLDATETIME NULL,
  [Importe] MONEY NOT NULL DEFAULT ((0)),
  [Pagado] TINYINT NOT NULL DEFAULT ((0)),
  [Imp_Pagado] MONEY NOT NULL DEFAULT ((0)),
  [idTesoreria] INT NULL,
  [FechaPagado] SMALLDATETIME NULL,
  [idFormaPago] INT NULL,
  [NumDocumento] VARCHAR(50) NULL,
  [idAnticipo] INT NULL,
  [Pagar] TINYINT NOT NULL DEFAULT ((1)),
  [Exportada] TINYINT NULL,
  [IdCuentaBanco] INT NULL,
  [IdCajaFinDia] INT NULL,
  PRIMARY KEY ([idFacturaClienteVencimiento])
);
GO

-- Table structure for dbo.Maquinas
CREATE TABLE dbo.Maquinas (
  [IdMaquina] INT IDENTITY(1,1) NOT NULL,
  [IdAlmacen] INT NULL,
  [Codigo] VARCHAR(50) NULL,
  [Nombre] VARCHAR(200) NOT NULL,
  [Descripcion] VARCHAR(500) NULL,
  [Fabricante] VARCHAR(100) NULL,
  [Observaciones] VARCHAR(700) NULL,
  [FechaCompra] SMALLDATETIME NULL,
  [PrecioGolpe] DECIMAL(14, 4) NULL,
  [PrecioPlancha] DECIMAL(14, 4) NULL,
  [FechaBaja] SMALLDATETIME NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdArticulo] INT NULL,
  [IdMaquinaTipo] INT NULL,
  [PrecioPlanchaNegro] DECIMAL(14, 4) NULL,
  [SinOperario] TINYINT NULL,
  [CosteHora] DECIMAL(14, 4) NULL,
  [IdSociedad] INT NULL,
  [IdCentroTrabajo] INT NULL,
  [IdMaquinaFamilia] INT NULL,
  [ConCosteHoraTipoMaquina] TINYINT NULL DEFAULT ((0)),
  [IdCliente] INT NULL,
  [IdDireccionEnvio] INT NULL,
  [TipoOrigenDireccionEnvio] TINYINT NULL,
  [NombreDireccionEnvio] VARCHAR(200) NULL,
  [Direccion] VARCHAR(100) NULL,
  [Poblacion] VARCHAR(100) NULL,
  [CodigoPostal] VARCHAR(100) NULL,
  [IdProvincia] INT NULL,
  [IdPais] INT NULL,
  [Telefono] VARCHAR(20) NULL,
  [PersonaContacto] VARCHAR(200) NULL,
  [ObservacionesDireccion] VARCHAR(MAX) NULL,
  [Latitud] VARCHAR(50) NULL,
  [Longitud] VARCHAR(50) NULL,
  [Maquina] TINYINT NULL,
  [Mantenimiento] TINYINT NULL,
  [IdMaquinaPadre] INT NULL,
  [DireccionArbol] VARCHAR(200) NULL,
  [DireccionArbolNombres] VARCHAR(5000) NULL,
  [ActivoMaquina] TINYINT NULL,
  PRIMARY KEY ([IdMaquina])
);
GO

-- Table structure for dbo.Monedas
CREATE TABLE dbo.Monedas (
  [idmoneda] INT IDENTITY(1,1) NOT NULL,
  [nombre] VARCHAR(50) NULL,
  [conversion] MONEY NULL DEFAULT ((1)),
  [fechaconversion] SMALLDATETIME NULL,
  [decimales] TINYINT NULL,
  [posicion] TINYINT NULL DEFAULT ((0)),
  [formato] TINYINT NULL DEFAULT ((0)),
  [simbolo] VARCHAR(4) NULL,
  [nombrecorto] VARCHAR(10) NULL,
  [Codigo] VARCHAR(15) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  PRIMARY KEY ([idmoneda])
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

-- Table structure for dbo.PersonasContacto
CREATE TABLE dbo.PersonasContacto (
  [IdPersonaContacto] INT IDENTITY(1,1) NOT NULL,
  [Nombre] VARCHAR(50) NOT NULL,
  [Apellido1] VARCHAR(50) NULL,
  [Apellido2] VARCHAR(50) NULL,
  [FechaNacimiento] DATETIME NULL,
  [IdTipoSexo] INT NULL,
  [Nuss] VARCHAR(10) NULL,
  [Direccion] VARCHAR(100) NULL,
  [IdPais] INT NULL,
  [IdProvincia] INT NULL,
  [Poblacion] VARCHAR(100) NULL,
  [CP] VARCHAR(10) NULL,
  [Telefono] VARCHAR(20) NULL,
  [TelefonoMovil] VARCHAR(20) NULL,
  [Fax] VARCHAR(20) NULL,
  [Extension] VARCHAR(20) NULL,
  [Email] VARCHAR(100) NULL,
  [Cargo] VARCHAR(50) NULL,
  [Departamento] VARCHAR(50) NULL,
  [Observaciones] VARCHAR(250) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] DATETIME NULL,
  [Latitud] VARCHAR(50) NULL,
  [Longitud] VARCHAR(50) NULL,
  [IdTipoDocumentoIdentificacion] INT NULL,
  [DocumentoIdentificacion] NVARCHAR(20) NULL,
  PRIMARY KEY ([IdPersonaContacto])
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

-- Table structure for dbo.Presupuestos_Tipos
CREATE TABLE dbo.Presupuestos_Tipos (
  [idPresupuestoTipo] INT IDENTITY(1,1) NOT NULL,
  [NombreTipo] VARCHAR(150) NULL,
  [CodigoTipo] VARCHAR(10) NULL,
  [IdTipoNumeracion] INT NULL,
  [Predeterminado] TINYINT NULL,
  PRIMARY KEY ([idPresupuestoTipo])
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

-- Table structure for dbo.Proyectos
CREATE TABLE dbo.Proyectos (
  [IdProyecto] INT IDENTITY(1,1) NOT NULL,
  [IdSociedad] INT NOT NULL,
  [Nombre] VARCHAR(150) NULL,
  [Descripcion] VARCHAR(500) NULL,
  [FechaCreacion] SMALLDATETIME NULL,
  [FechaInicioPrevista] SMALLDATETIME NULL,
  [FechaFinPrevista] SMALLDATETIME NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [Codigo] VARCHAR(250) NULL,
  [FechaInicioReal] SMALLDATETIME NULL,
  [FechaFinReal] SMALLDATETIME NULL,
  [IdTipoUsuarioResponsable] INT NULL,
  [IdUsuarioResponsable] INT NULL,
  [NombreDireccionEnvio] VARCHAR(200) NULL,
  [Direccion] VARCHAR(100) NULL,
  [Poblacion] VARCHAR(100) NULL,
  [CodigoPostal] VARCHAR(20) NULL,
  [IdProvincia] INT NULL,
  [IdPais] INT NULL,
  [Telefono] VARCHAR(20) NULL,
  [Fax] VARCHAR(20) NULL,
  [Email] VARCHAR(3200) NULL,
  [Horario] VARCHAR(MAX) NULL,
  [PersonaContacto] VARCHAR(200) NULL,
  [Observaciones] VARCHAR(MAX) NULL,
  [Latitud] VARCHAR(50) NULL,
  [Longitud] VARCHAR(50) NULL,
  [IdTipoDocumento] INT NULL,
  [IdTipoUsuarioResponsable1] INT NULL,
  [IdUsuarioResponsable1] INT NULL,
  [IdTipoUsuarioResponsable2] INT NULL,
  [IdUsuarioResponsable2] INT NULL,
  [Estado] TINYINT NULL,
  [UsuarioResponsable] VARCHAR(200) NULL,
  [UsuarioResponsable1] VARCHAR(200) NULL,
  [UsuarioResponsable2] VARCHAR(200) NULL,
  [IdEstadoDocumento] INT NULL,
  [IdCliente] INT NULL,
  [Cliente] VARCHAR(250) NULL,
  [Agrupacion] VARCHAR(1000) NULL,
  [Facturable] TINYINT NULL,
  [IdSerie] INT NULL,
  [NumeroSerie] INT NULL,
  [DescripcionCorta] VARCHAR(50) NULL,
  PRIMARY KEY ([IdProyecto])
);
GO

-- Table structure for dbo.SeguridadUnificada_Configuracion
CREATE TABLE dbo.SeguridadUnificada_Configuracion (
  [VersionPrincipal] INT NOT NULL,
  [VersionSecundaria] INT NOT NULL,
  [Fecha] SMALLDATETIME NULL,
  [VersionPrincipalListados] INT NULL,
  [VersionSecundariaListados] INT NULL,
  [FechaListados] SMALLDATETIME NULL,
  [Servidor] VARCHAR(200) NULL,
  [Usuario] VARCHAR(200) NULL,
  [Contrasena] VARCHAR(200) NULL,
  [Origen] VARCHAR(200) NULL,
  [Destino] VARCHAR(200) NULL,
  [ContraseñaAltaSeguridad] TINYINT NOT NULL DEFAULT ((0)),
  [CaducidadContraseña] TINYINT NOT NULL DEFAULT ((0)),
  [NumeroMesesCaducidadContraseña] INT NULL,
  [CambioContraseñaConAutenticacionDobleFactor] TINYINT NOT NULL DEFAULT ((0)),
  [EntradaAplicacionAutenticacionDobleFactor] TINYINT NOT NULL DEFAULT ((0)),
  [AutenticacionPorAzure] TINYINT NOT NULL DEFAULT ((0)),
  [IdIdentidad] INT NULL,
  [FechaModificacion] DATETIME NULL
);
GO

-- Table structure for dbo.SeguridadUnificada_Formulario
CREATE TABLE dbo.SeguridadUnificada_Formulario (
  [IdFormulario] INT IDENTITY(1,1) NOT NULL,
  [IdFormularioPadre] INT NULL,
  [IdAplicacion] INT NOT NULL,
  [Nombre] VARCHAR(200) NOT NULL DEFAULT (''),
  [Menu] VARCHAR(200) NOT NULL DEFAULT (''),
  [DescripcionMenu] VARCHAR(200) NOT NULL DEFAULT (''),
  [EsMenu] TINYINT NOT NULL,
  [Orden] INT NOT NULL DEFAULT ((0)),
  [Habilitado] TINYINT NOT NULL DEFAULT ((1)),
  PRIMARY KEY ([IdFormulario])
);
GO

-- Table structure for dbo.SeguridadUnificada_FormularioEnlace
CREATE TABLE dbo.SeguridadUnificada_FormularioEnlace (
  [IdFormularioEnlace] INT IDENTITY(1,1) NOT NULL,
  [IdIdentidad] INT NULL,
  [IdGrupo] INT NULL,
  [IdFormulario] INT NOT NULL,
  [Valor] TINYINT NOT NULL DEFAULT ((0)),
  [ParaSoloLectura] TINYINT NOT NULL DEFAULT ((0)),
  [PermitirExportar] TINYINT NOT NULL DEFAULT ((1)),
  [PermitirAgrupados] TINYINT NOT NULL DEFAULT ((1)),
  [PermitirInformes] TINYINT NOT NULL DEFAULT ((1)),
  PRIMARY KEY ([IdFormularioEnlace])
);
GO

-- Table structure for dbo.SeguridadUnificada_Grupo
CREATE TABLE dbo.SeguridadUnificada_Grupo (
  [IdGrupo] INT IDENTITY(1,1) NOT NULL,
  [IdAplicacion] INT NOT NULL,
  [Nombre] VARCHAR(200) NOT NULL DEFAULT (''),
  PRIMARY KEY ([IdGrupo])
);
GO

-- Table structure for dbo.SeguridadUnificada_Identidad
CREATE TABLE dbo.SeguridadUnificada_Identidad (
  [IdIdentidad] INT IDENTITY(1,1) NOT NULL,
  [IdUsuario] INT NOT NULL,
  [IdTipoUsuario] INT NOT NULL,
  [Usuario] VARCHAR(100) NOT NULL DEFAULT (''),
  [Contrasena] VARCHAR(200) NULL DEFAULT (''),
  [ContrasenaEnc] VARBINARY NULL,
  [AvisoBackup] TINYINT NOT NULL DEFAULT ((0)),
  [Activo] TINYINT NOT NULL DEFAULT ((1)),
  [IdDominio] INT NULL,
  [FechaCambioContraseña] DATETIME NULL,
  [FechaModificacion] DATETIME NULL,
  [ContraseñaProvisional] TINYINT NULL DEFAULT ((0)),
  [IdTipoValidacionUsuarioDominio] INT NULL,
  PRIMARY KEY ([IdIdentidad])
);
GO

-- Table structure for dbo.SeguridadUnificada_IdentidadGrupo
CREATE TABLE dbo.SeguridadUnificada_IdentidadGrupo (
  [IdIdentidadGrupo] INT IDENTITY(1,1) NOT NULL,
  [IdIdentidad] INT NOT NULL,
  [IdGrupo] INT NOT NULL,
  PRIMARY KEY ([IdIdentidadGrupo])
);
GO

-- Table structure for dbo.SeguridadUnificada_TipoUsuario
CREATE TABLE dbo.SeguridadUnificada_TipoUsuario (
  [IdTipoUsuario] INT IDENTITY(1,1) NOT NULL,
  [Numero] INT NOT NULL,
  [Nombre] VARCHAR(100) NOT NULL DEFAULT (''),
  [ProcedimientoSelect] VARCHAR(100) NULL,
  [Color] INT NULL,
  [Modo] TINYINT NOT NULL DEFAULT ((0)),
  [ProcedimientoSelectCompleto] VARCHAR(100) NULL,
  [ProcedimientoParaDespuesDeInsertar] VARCHAR(200) NULL,
  [NombreTabla] VARCHAR(100) NULL,
  [NombreCampoCorreo] VARCHAR(100) NULL,
  PRIMARY KEY ([IdTipoUsuario])
);
GO

-- Table structure for dbo.SociedadesConfiguracion
CREATE TABLE dbo.SociedadesConfiguracion (
  [IdSociedadConfiguracion] INT NOT NULL,
  [Nombre] VARCHAR(50) NOT NULL,
  [Descripcion] VARCHAR(500) NULL,
  [Configurable] TINYINT NOT NULL DEFAULT ((0)),
  [ExpresionRegular] VARCHAR(500) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  PRIMARY KEY ([IdSociedadConfiguracion])
);
GO

-- Table structure for dbo.SociedadesConfiguracion_Sociedades
CREATE TABLE dbo.SociedadesConfiguracion_Sociedades (
  [IdSociedadConfiguracionSociedad] INT IDENTITY(1,1) NOT NULL,
  [IdSociedadConfiguracion] INT NOT NULL,
  [IdSociedad] INT NOT NULL,
  [Valor] VARCHAR(200) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  PRIMARY KEY ([IdSociedadConfiguracionSociedad])
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

-- Table structure for dbo.TareasOnixMateriales
CREATE TABLE dbo.TareasOnixMateriales (
  [IdTareaOnixMaterial] INT IDENTITY(1,1) NOT NULL,
  [IdTareaOnix] INT NULL,
  [IdTareaOnixMaterialTipo] INT NULL,
  [Planificado] TINYINT NULL,
  [IdArticulo] INT NULL,
  [IdLote] INT NULL,
  [IdArticuloAtributoConjunto] INT NULL,
  [IdUnidadMedida] INT NULL,
  [IdAlmacen] INT NULL,
  [Descripcion] VARCHAR(200) NULL,
  [Cantidad] REAL NULL,
  [Coste] REAL NULL,
  [Importe] REAL NULL,
  [Fecha] SMALLDATETIME NULL,
  [IdPersonal] INT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  PRIMARY KEY ([IdTareaOnixMaterial])
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

-- Table structure for dbo.TareasTipos
CREATE TABLE dbo.TareasTipos (
  [idTareaTipo] INT IDENTITY(1,1) NOT NULL,
  [Nombre] VARCHAR(150) NULL,
  [Descripcion] VARCHAR(500) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  PRIMARY KEY ([idTareaTipo])
);
GO

-- Table structure for dbo.Tiempos
CREATE TABLE dbo.Tiempos (
  [IdTiempo] INT IDENTITY(1,1) NOT NULL,
  [IdSociedad] INT NULL,
  [IdCentroTrabajo] INT NULL,
  [IdOrdenFabricacionTarea] INT NULL,
  [IdTarea] INT NULL,
  [IdPersonal] INT NULL,
  [IdMaquina] INT NULL,
  [FechaInicio] DATETIME NULL,
  [FechaFin] DATETIME NULL,
  [TipoMaquinaPersona] TINYINT NULL,
  [IdPadre] INT NULL,
  [Duracion] FLOAT NULL,
  [IdMantenimientoPlanificacion] INT NULL,
  [InicioFin] TINYINT NULL,
  [IdProyectoTarea] INT NULL,
  [IdTareaGenerico] INT NULL,
  [FechaImputacion] DATETIME NULL,
  [IdTurno] INT NULL,
  [CosteHora] MONEY NOT NULL DEFAULT ((0)),
  [IdTareaTiempo] INT NULL,
  [IdProyecto] INT NULL,
  [IdProyectoRecursoPlanificado] INT NULL,
  [IdTiempoLogistico] INT NULL,
  [IdPack] INT NULL,
  [Observaciones] VARCHAR(2000) NULL,
  [IdTiempoFin] INT NULL,
  [HorasExtra] TINYINT NULL,
  [EstadoOF] TINYINT NULL,
  [IdOrdenFabricacionTareaConjunto] INT NULL,
  [FechaInicioOriginal] DATETIME NULL,
  [FechaFinOriginal] DATETIME NULL,
  [IdCentroTrabajoSeccion] INT NULL,
  [IdTiempoControlPresencia] INT NULL,
  [Latitud] VARCHAR(50) NULL,
  [Longitud] VARCHAR(50) NULL,
  PRIMARY KEY ([IdTiempo])
);
GO

-- Table structure for dbo.Tipos
CREATE TABLE dbo.Tipos (
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

-- Table structure for dbo.TiposCerrados
CREATE TABLE dbo.TiposCerrados (
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

-- Table structure for dbo.bp_PresupuestosEstudioCostesOtros
CREATE TABLE dbo.bp_PresupuestosEstudioCostesOtros (
  [IdPresupuestoEstudioCostesOtros] INT IDENTITY(1,1) NOT NULL,
  [IdPresupuesto] INT NULL,
  [IdTipoEstudioCoste] INT NULL,
  [IdTipoCoste] INT NULL,
  [Descripcion] VARCHAR(MAX) NULL,
  [Cantidad] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [Precio] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [IdEstudioCosteELIMINAR] INT NULL,
  [IdPresupuestoLineaELIMINAR] INT NULL,
  PRIMARY KEY ([IdPresupuestoEstudioCostesOtros])
);
GO

-- Table structure for dbo.bp_PresupuestosEstudioCostesPersonal
CREATE TABLE dbo.bp_PresupuestosEstudioCostesPersonal (
  [IdPresupuestoEstudioCostesPersonal] INT IDENTITY(1,1) NOT NULL,
  [IdPresupuesto] INT NULL,
  [IdTipoEstudioCoste] INT NULL,
  [IdPersonal] INT NULL,
  [Descripcion] VARCHAR(MAX) NULL,
  [Horas] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [CosteHora] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  PRIMARY KEY ([IdPresupuestoEstudioCostesPersonal])
);
GO

-- Table structure for dbo.bp_PresupuestosEstudioCostesProveedores
CREATE TABLE dbo.bp_PresupuestosEstudioCostesProveedores (
  [IdPresupuestoEstudioCostesProveedores] INT IDENTITY(1,1) NOT NULL,
  [IdPresupuesto] INT NULL,
  [IdTipoEstudioCoste] INT NULL,
  [IdProveedor] INT NULL,
  [Descripcion] VARCHAR(MAX) NULL,
  [Cantidad] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [Precio] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [Descuento] DECIMAL(12, 2) NOT NULL DEFAULT ((0)),
  [IdUnidadMedida] INT NULL,
  [IdFacturaProveedorLinea] INT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [idPresupuestoFacturaProvLineaELIMINAR] INT NULL,
  [IdPresupuestoLineaELIMINAR] INT NULL,
  PRIMARY KEY ([IdPresupuestoEstudioCostesProveedores])
);
GO

-- Table structure for dbo.gf_Alumnos
CREATE TABLE dbo.gf_Alumnos (
  [IdAlumno] INT IDENTITY(1,1) NOT NULL,
  [IdTipoDocumento] INT NOT NULL,
  [IdTipoSexo] INT NULL,
  [Documento] VARCHAR(50) NOT NULL,
  [Nombre] VARCHAR(70) NOT NULL,
  [PrimerApellido] VARCHAR(70) NOT NULL,
  [SegundoApellido] VARCHAR(70) NULL,
  [FechaNacimiento] SMALLDATETIME NULL,
  [Nuss] VARCHAR(12) NULL,
  [UsuarioWeb] VARCHAR(50) NULL,
  [ClaveWeb] VARCHAR(50) NULL,
  [IdAlumnoPlataforma] INT NULL,
  [Bloqueado] TINYINT NULL DEFAULT ((0)),
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [Direccion] VARCHAR(100) NULL,
  [Poblacion] VARCHAR(50) NULL,
  [CodigoPostal] VARCHAR(20) NULL,
  [IdPais] INT NULL,
  [IdProvincia] INT NULL,
  [TelefonoFijo] VARCHAR(20) NULL,
  [TelefonoMovil] VARCHAR(20) NULL,
  [Email] VARCHAR(320) NULL,
  [IdCliente] INT NULL,
  [RazonSocialCentroTrabajo] VARCHAR(200) NULL,
  [NussCentroTrabajo] VARCHAR(50) NULL,
  [DireccionCentroTrabajo] VARCHAR(100) NULL,
  [PoblacionCentroTrabajo] VARCHAR(50) NULL,
  [CodigoPostalCentroTrabajo] VARCHAR(20) NULL,
  [IdPaisCentroTrabajo] INT NULL,
  [IdProvinciaCentroTrabajo] INT NULL,
  [TelefonoFijoCentroTrabajo] VARCHAR(20) NULL,
  [TelefonoMovilCentroTrabajo] VARCHAR(20) NULL,
  [FaxCentroTrabajo] VARCHAR(20) NULL,
  [Discapacitado] TINYINT NULL,
  [Cualificado] TINYINT NULL,
  [IdTipoEstudios] INT NULL,
  [IdTipoCategoriaProfesional] INT NULL,
  [IdTipoAreaFuncional] INT NULL,
  [IdTipoGrupoCotizacion] INT NULL,
  [IdTipoColectivo] INT NULL,
  [IdTipoJornada] INT NULL,
  [Victima] TINYINT NULL,
  [AfectadoERE] TINYINT NULL,
  [Inmigrante] TINYINT NULL,
  [TrabajadorSectorCrisis] TINYINT NULL,
  [Desempleado] TINYINT NULL,
  [DemandantePrimerEmpleo] TINYINT NULL,
  [IdTipoGrupo] INT NULL,
  [IdTipoNivel] INT NULL,
  [NRP] VARCHAR(50) NULL,
  [EsDocente] TINYINT NULL,
  [DesempleadoLargaDuracion] TINYINT NULL,
  [ProcedenteSEPE] TINYINT NULL,
  [ProcedentePlanPrepara] TINYINT NULL,
  [CodigoPostalSEPE] VARCHAR(20) NULL,
  [SolicitaBeca] TINYINT NULL,
  [Manutencion] TINYINT NULL,
  [Transporte] TINYINT NULL,
  [Alojamiento] TINYINT NULL,
  [Conciliacion] TINYINT NULL,
  [CertificadoDiscapacidad] TINYINT NULL,
  [NumeroCuentaEntidad] VARCHAR(4) NULL,
  [NumeroCuentaOficina] VARCHAR(4) NULL,
  [NumeroCuentaDC] VARCHAR(2) NULL,
  [NumeroCuentaCCC] VARCHAR(10) NULL,
  [IdOficinaEmpleo] INT NULL,
  [OtrosEstudios] VARCHAR(200) NULL,
  [EncontroEmpleo] TINYINT NULL,
  [DocumentoIdentificacionEmpresaEmpleo] VARCHAR(50) NULL,
  [RazonSocialEmpresaEmpleo] VARCHAR(200) NULL,
  [FechaAltaEmpresaEmpleo] SMALLDATETIME NULL,
  [EconomiaSocial] TINYINT NULL,
  [CodigoPostalEmpresaEmpleo] VARCHAR(20) NULL,
  [Cuerpo] VARCHAR(200) NULL,
  [Categoria] VARCHAR(200) NULL,
  [IdPoblacion] INT NULL,
  [IdPoblacionCentroTrabajo] INT NULL,
  [EmailCentroTrabajo] VARCHAR(320) NULL,
  [FechaInscripcionDemandanteEmpleo] SMALLDATETIME NULL,
  [IdTipoPrestacion] INT NULL,
  [FechaInicioPrestacion] SMALLDATETIME NULL,
  [FechaFinPrestacion] SMALLDATETIME NULL,
  [IdTipoOtroColectivoPrioritario] INT NULL,
  [AsisteSeleccion] TINYINT NULL,
  [IdTipoPermisoConduccion] INT NULL,
  [VehiculoPropio] TINYINT NULL,
  [FormacionComplementaria] VARCHAR(MAX) NULL,
  [ExperienciaLaboral] VARCHAR(MAX) NULL,
  [FormacionSolicitada] VARCHAR(MAX) NULL,
  [IdTipoOcupacion] INT NULL,
  [IdOcupacionPuestoTrabajo] INT NULL,
  [FechaNegativaLOPD] SMALLDATETIME NULL,
  [NoDeseaRecibirInformacionPromocional] TINYINT NULL,
  [NoAutorizaComunicacionDatosEmpresasGrupo] TINYINT NULL,
  [NombreDescriptivoDocumentoNegativa] VARCHAR(250) NULL,
  [Observaciones] VARCHAR(MAX) NULL,
  [IdEntidadColaboradora] INT NULL,
  [IdTipoEstado] INT NULL,
  [IdPaisNacionalidadAlumno] INT NULL,
  [DeseaRecibirInformacionPromocional] TINYINT NULL,
  [IdTipoDocumentoAntiguo] INT NULL,
  [DocumentoAntiguo] VARCHAR(50) NULL,
  [FechaCambioDocumento] SMALLDATETIME NULL,
  [UsuarioSalesManago] VARCHAR(320) NULL,
  [FechaActualizacionSalesManago] SMALLDATETIME NULL,
  [ContactIdSalesManago] VARCHAR(MAX) NULL,
  PRIMARY KEY ([IdAlumno])
);
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

-- Table structure for dbo.gf_Docentes
CREATE TABLE dbo.gf_Docentes (
  [IdDocente] INT IDENTITY(1,1) NOT NULL,
  [IdTipoDocumento] INT NOT NULL,
  [IdTipoSexo] INT NULL,
  [Documento] VARCHAR(50) NOT NULL,
  [Nombre] VARCHAR(70) NOT NULL,
  [PrimerApellido] VARCHAR(70) NOT NULL,
  [SegundoApellido] VARCHAR(70) NULL,
  [FechaNacimiento] SMALLDATETIME NULL,
  [Nuss] VARCHAR(12) NULL,
  [UsuarioWeb] VARCHAR(50) NULL,
  [ClaveWeb] VARCHAR(50) NULL,
  [IdDocentePlataforma] INT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [Titulacion] VARCHAR(MAX) NULL,
  [Experiencia] VARCHAR(MAX) NULL,
  [CertificadoProfesionalidad] VARCHAR(MAX) NULL,
  [Email] VARCHAR(250) NULL,
  [TelefonoMovil] VARCHAR(50) NULL,
  [TelefonoFijo] VARCHAR(50) NULL,
  [IdProvincia] INT NULL,
  [IdPais] INT NULL,
  [Direccion] VARCHAR(150) NULL,
  [Poblacion] VARCHAR(50) NULL,
  [CodigoPostal] VARCHAR(10) NULL,
  [EmailPersonal] VARCHAR(250) NULL,
  [IdTipoEstado] INT NULL,
  [Iban] VARCHAR(34) NULL,
  [IdPaisNacionalidad] INT NULL,
  [Valoracion1a5] TINYINT NULL,
  [HoraMañanaDesde] DATETIME NULL,
  [HoraMañanaHasta] DATETIME NULL,
  [HoraMañanaDesde2] DATETIME NULL,
  [HoraMañanaHasta2] DATETIME NULL,
  [HoraTardeDesde] DATETIME NULL,
  [HoraTardeHasta] DATETIME NULL,
  [HoraTardeDesde2] DATETIME NULL,
  [HoraTardeHasta2] DATETIME NULL,
  [Lunes] TINYINT NULL,
  [Martes] TINYINT NULL,
  [Miercoles] TINYINT NULL,
  [Jueves] TINYINT NULL,
  [Viernes] TINYINT NULL,
  [Sabado] TINYINT NULL,
  [Domingo] TINYINT NULL,
  [CosteHora] FLOAT NULL,
  [IdRetencionIRPF] INT NULL,
  [IdTipoFacturacion] INT NULL,
  PRIMARY KEY ([IdDocente])
);
GO

-- Table structure for dbo.gf_EntidadesColaboradoras
CREATE TABLE dbo.gf_EntidadesColaboradoras (
  [IdEntidadColaboradora] INT IDENTITY(1,1) NOT NULL,
  [IdTipoDocumento] INT NOT NULL,
  [Documento] VARCHAR(50) NOT NULL,
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
  [IdEntidadImpartidora] INT NULL,
  [IdSector] INT NULL,
  [IdTipoCentral] INT NULL,
  [ExisteRLT] TINYINT NOT NULL DEFAULT ((0)),
  [IdTipoDocumentoRepresentante] INT NULL,
  [DocumentoRepresentante] VARCHAR(50) NULL,
  [NombreRepresentante] VARCHAR(100) NULL,
  [PrimerApellidoRepresentante] VARCHAR(100) NULL,
  [SegundoApellidoRepresentante] VARCHAR(100) NULL,
  [CargoRepresentante] VARCHAR(200) NULL,
  [DireccionRepresentante] VARCHAR(100) NULL,
  [CodigoPostalRepresentante] VARCHAR(20) NULL,
  [PoblacionRepresentante] VARCHAR(100) NULL,
  [IdProvinciaRepresentante] INT NULL,
  [IdPaisRepresentante] INT NULL,
  [TelefonoFijoRepresentante] VARCHAR(20) NULL,
  [TelefonoMovilRepresentante] VARCHAR(20) NULL,
  [FaxRepresentante] VARCHAR(20) NULL,
  [EmailRepresentante] VARCHAR(320) NULL,
  [ObservacionesRepresentante] VARCHAR(MAX) NULL,
  [Logo] VARBINARY NULL,
  PRIMARY KEY ([IdEntidadColaboradora])
);
GO

-- Table structure for dbo.gf_EntidadesImpartidoras
CREATE TABLE dbo.gf_EntidadesImpartidoras (
  [IdEntidadImpartidora] INT IDENTITY(1,1) NOT NULL,
  [IdTipoDocumento] INT NOT NULL,
  [Documento] VARCHAR(50) NOT NULL,
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
  [AccionesFormativasFEActivas] TINYINT NULL DEFAULT ((0)),
  [AgrupacionesActivas] TINYINT NULL DEFAULT ((0)),
  [CodigoCenso] VARCHAR(50) NULL,
  [CodigoCensoAlfanumerico] VARCHAR(50) NULL,
  [DenominacionCenso] VARCHAR(500) NULL,
  [UrlSepe] VARCHAR(500) NULL,
  [DocumentoResponsable] VARCHAR(50) NULL,
  [CargoResponsable] VARCHAR(500) NULL,
  [IdTipoDocumentoRepresentante] INT NULL,
  [DocumentoRepresentante] VARCHAR(50) NULL,
  [NombreRepresentante] VARCHAR(100) NULL,
  [PrimerApellidoRepresentante] VARCHAR(100) NULL,
  [SegundoApellidoRepresentante] VARCHAR(100) NULL,
  [CargoRepresentante] VARCHAR(200) NULL,
  [DireccionRepresentante] VARCHAR(100) NULL,
  [CodigoPostalRepresentante] VARCHAR(20) NULL,
  [PoblacionRepresentante] VARCHAR(100) NULL,
  [IdProvinciaRepresentante] INT NULL,
  [IdPaisRepresentante] INT NULL,
  [TelefonoFijoRepresentante] VARCHAR(20) NULL,
  [TelefonoMovilRepresentante] VARCHAR(20) NULL,
  [FaxRepresentante] VARCHAR(20) NULL,
  [EmailRepresentante] VARCHAR(320) NULL,
  [ObservacionesRepresentante] VARCHAR(MAX) NULL,
  [TelefonoContactoAlumnos] VARCHAR(100) NULL,
  [EmailContactoAlumnos] VARCHAR(150) NULL,
  [TelefonoMovilContactoAlumnos] VARCHAR(100) NULL,
  [WhatsAppActivo] TINYINT NULL DEFAULT ((0)),
  [UrlDocumentacionExterna] VARCHAR(500) NULL,
  [EmailRecepcionAvisos] VARCHAR(320) NULL,
  [Origen] VARCHAR(MAX) NULL,
  [IdTipoOrigen] INT NULL,
  [Url] VARCHAR(300) NULL,
  [Facebook] VARCHAR(300) NULL,
  [Twitter] VARCHAR(300) NULL,
  [LinkedIn] VARCHAR(300) NULL,
  [Instagram] VARCHAR(300) NULL,
  [AvisoLegal] VARCHAR(MAX) NULL,
  [PoliticaDePrivacidad] VARCHAR(MAX) NULL,
  [AvisoLegalHTML] VARCHAR(MAX) NULL,
  [PoliticaDePrivacidadHTML] VARCHAR(MAX) NULL,
  [AvisoLegalNombreEmpresa] VARCHAR(300) NULL,
  [UrlLanding] VARCHAR(300) NULL,
  [NombreLanding] VARCHAR(300) NULL,
  PRIMARY KEY ([IdEntidadImpartidora])
);
GO

-- Table structure for dbo.gf_EntidadesSupervisoras
CREATE TABLE dbo.gf_EntidadesSupervisoras (
  [IdEntidadSupervisora] INT IDENTITY(1,1) NOT NULL,
  [IdTipoDocumento] INT NULL,
  [Documento] VARCHAR(50) NULL,
  [RazonSocial] VARCHAR(200) NULL,
  [NombreComercial] VARCHAR(200) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] DATETIME NULL,
  PRIMARY KEY ([IdEntidadSupervisora])
);
GO

-- Table structure for dbo.gf_Personal
CREATE TABLE dbo.gf_Personal (
  [IdPersonal] INT IDENTITY(1,1) NOT NULL,
  [IdTipoDocumento] INT NOT NULL,
  [Documento] VARCHAR(20) NOT NULL,
  [Nombre] VARCHAR(100) NOT NULL,
  [PrimerApellido] VARCHAR(100) NOT NULL,
  [SegundoApellido] VARCHAR(100) NULL,
  [FechaNacimiento] SMALLDATETIME NULL,
  [IdTipoSexo] INT NULL,
  [Nuss] VARCHAR(20) NULL,
  [TelefonoFijo] VARCHAR(20) NULL,
  [TelefonoMovil] VARCHAR(20) NULL,
  [TelefonoTrabajo] VARCHAR(20) NULL,
  [Extension] VARCHAR(10) NULL,
  [Email] VARCHAR(320) NULL,
  [Direccion] VARCHAR(150) NULL,
  [IdPais] INT NULL,
  [CodigoPostal] VARCHAR(10) NULL,
  [IdProvincia] INT NULL,
  [Poblacion] VARCHAR(100) NULL,
  [Activo] TINYINT NOT NULL DEFAULT ((0)),
  [Observaciones] VARCHAR(250) NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [EmailEmpresa] VARCHAR(250) NULL,
  [EmailPersonal] VARCHAR(250) NULL,
  [IdEntidadImpartidora] INT NULL,
  [OcultarDatosEconomicos] TINYINT NULL DEFAULT ((0)),
  [Robot] INT NULL DEFAULT ((0)),
  PRIMARY KEY ([IdPersonal])
);
GO

-- Table structure for dbo.gf_Personal_Sociedades_Departamentos
CREATE TABLE dbo.gf_Personal_Sociedades_Departamentos (
  [IdPersonalSociedadDepartamento] INT IDENTITY(1,1) NOT NULL,
  [IdPersonal] INT NOT NULL,
  [IdSociedad] INT NOT NULL,
  [IdDepartamento] INT NOT NULL,
  [IdIdentidad] INT NULL,
  [FechaModificacion] SMALLDATETIME NULL,
  [Obsoleto] TINYINT NULL DEFAULT ((0)),
  PRIMARY KEY ([IdPersonalSociedadDepartamento])
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

-- Function structure for dbo.uf_ListaATabla
CREATE FUNCTION [dbo].[uf_ListaATabla]
(
	@ListaIds      NTEXT,
	@Delimitador NCHAR(1) = N','
) RETURNS @TempTable TABLE (listpos INT IDENTITY(1, 1) NOT NULL,
							STR     VARCHAR(4000),
							nstr    NVARCHAR(2000)) AS

   BEGIN
      DECLARE @Posicion INT,
              @PosicionTexto INT,
              @LongitudSegmento SMALLINT,
              @CadenaTemp NVARCHAR(4000),
              @IdFinal NVARCHAR(4000),
              @ValorTemp NVARCHAR(4000)

      SET @PosicionTexto = 1
      SET @IdFinal = ''
      
      WHILE @PosicionTexto <= DATALENGTH(@ListaIds) / 2
      BEGIN
      
         SET @LongitudSegmento = 4000 - DATALENGTH(@IdFinal) / 2
         SET @CadenaTemp = @IdFinal + SUBSTRING(@ListaIds, @PosicionTexto, @LongitudSegmento)
         SET @PosicionTexto = @PosicionTexto + @LongitudSegmento

         SET @Posicion = CHARINDEX(@Delimitador, @CadenaTemp)

         WHILE @Posicion > 0
         BEGIN
         
            SET @ValorTemp = LTRIM(RTRIM(LEFT(@CadenaTemp, @Posicion - 1)))
            
            INSERT @TempTable (STR, nstr) VALUES(@ValorTemp, @ValorTemp)
            
            SET @CadenaTemp = SUBSTRING(@CadenaTemp, @Posicion + 1, LEN(@CadenaTemp))
            
            SET @Posicion = CHARINDEX(@Delimitador, @CadenaTemp)
            
         END

         SET @IdFinal = @CadenaTemp
         
      END

      INSERT @TempTable(STR, nstr) VALUES (LTRIM(RTRIM(@IdFinal)), LTRIM(RTRIM(@IdFinal)))
   RETURN
   END
GO

-- Function structure for dbo.uf_bp_Presupuestos_Albaranes
CREATE FUNCTION dbo.uf_bp_Presupuestos_Albaranes 
(
	@IdPresupuesto INT
)  
RETURNS VARCHAR(MAX) AS  
BEGIN 

	-- Devuelve los números de albarán asignados a  un presupuesto, teniendo en cuenta q una linea de presupuesto puede estar en varios albaranes

	DECLARE @Cadena VARCHAR(MAX)

	SET @Cadena = ''

	SELECT  @Cadena = @Cadena +  ' ' + alb.NumAlbaran  +  ' /'  
	FROM dbo.Albaranes alb
	WHERE alb.IdAlbaran  IN (
							SELECT albL.IdAlbaran 
							FROM		dbo.Albaranes_Lineas	albL
							INNER JOIN	dbo.Presupuestos_Lineas preL ON preL.IdPresupuestoLinea = albL.IdPresupuestoLinea
							WHERE preL.IdPresupuesto = @IdPresupuesto
							UNION
							SELECT 
								idAlbaran
							FROM 
								dbo.Albaranes
							WHERE
								Albaranes.IdPresupuesto = @IdPresupuesto					
						)
						
						
	
			
			
	IF @Cadena <> ''
		SET @Cadena = RTRIM(SUBSTRING(@Cadena, 1, LEN(@Cadena) -1))
	ELSE
		SET @Cadena = NULL
	
	RETURN @Cadena 	

END



GO

-- Function structure for dbo.uf_bp_Presupuestos_Facturas
CREATE FUNCTION dbo.uf_bp_Presupuestos_Facturas 
(
	@IdPresupuesto INT
)  
RETURNS VARCHAR(MAX) AS  
BEGIN 

	--Devuelve los números de factura asignados a  un presupuesto, teniendo en cuenta q una linea de presupuesto puede estar en varios albaranes, y una linea de albaran en varias facturas
	
	DECLARE @Cadena VARCHAR(MAX)

	SET @Cadena = ''

	SELECT  @Cadena = @Cadena + ' ' + ISNULL(fc.SerieDelante,'') + 
									CASE WHEN ISNULL(fc.Rectificativa,0) = 1 THEN 'R '
										 ELSE ''
									END  +   fc.numfactura + ISNULL(fc.SerieDetras,'')  +  ' /'   
	FROM	dbo.FacturasClientes fc
	WHERE	fc.IdFacturaCliente IN (
									SELECT  fc_l.IdFacturaCliente 
									FROM		dbo.FacturasClientes_Lineas fc_l
									INNER JOIN	dbo.Albaranes_Lineas		a_l ON a_l.IdAlbaranLinea = fc_l.IdAlbaranLinea
									INNER JOIN	dbo.Presupuestos_Lineas		p_l	ON p_l.IdPresupuestoLinea = a_l.IdPresupuestoLinea
									WHERE	p_l.IdPresupuesto = @IdPresupuesto 
									UNION
									SELECT  fc_l.IdFacturaCliente 
									FROM		dbo.FacturasClientes_Lineas fc_l
									INNER JOIN	dbo.Albaranes_Lineas		a_l ON a_l.IdAlbaranLinea = fc_l.IdAlbaranLinea
									INNER JOIN	dbo.Albaranes		al	ON al.idAlbaran = a_l.idAlbaran
									WHERE	al.IdPresupuesto = @IdPresupuesto
									)
	
	IF @Cadena <> ''
		SET @Cadena = RTRIM(SUBSTRING(@Cadena, 1, LEN(@Cadena) -1))
	ELSE
		SET @Cadena = NULL
	
	RETURN @Cadena 	

END




GO

-- Function structure for dbo.uf_bp_Tareas_Albaranes
-- =====================================================================
-- Author:		Daniel Costas Rodríguez
-- Create date: 26/11/2009
-- Description:	Funcion que devuelve el numero de albaranes de bp_tareas
-- =====================================================================
CREATE FUNCTION dbo.uf_bp_Tareas_Albaranes 
(
	@IdTarea [int]
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @Cadena VARCHAR(MAX)

	SET @Cadena = ''

	SELECT  @Cadena = @Cadena +  ' ' + alb.NumAlbaran  +  ' /'  
	
	FROM dbo.Albaranes alb
	WHERE alb.IdAlbaran  in (
			SELECT albL.IdAlbaran 
			FROM		dbo.Albaranes_Lineas	albL
			INNER JOIN	dbo.Presupuestos_Lineas preL ON preL.IdPresupuestoLinea = albL.IdPresupuestoLinea
			INNER JOIN	dbo.Tareas				tar  ON tar.IdPresupuestoLinea =  albL.IdPresupuestoLinea
			WHERE  tar.IdTarea = @IdTarea
			)
		OR alb.IdAlbaran  IN (
			SELECT albL.IdAlbaran 
			FROM		dbo.Albaranes_Lineas	albL
			INNER JOIN	dbo.Tareas				tar ON tar.IdTarea = albL.IdTarea
			WHERE  tar.IdTarea = @IdTarea
			)

	IF @Cadena <> ''
		SET @Cadena = RTRIM(SUBSTRING(@Cadena, 1, LEN(@Cadena) -1))
	ELSE
		SET @Cadena = NULL
	
	RETURN @Cadena 	

END



GO

-- View structure for dbo.vw_Tareas_Tiempos
CREATE VIEW dbo.vw_Tareas_Tiempos
AS
	SELECT  tart.IdTarea, 
			SUM(ISNULL(tart.Horas,0)) AS Total,
			SUM(ISNULL(tart.Horas,0)* tie.CosteHora ) AS Coste
	FROM	dbo.TareasTiempos tart
	LEFT JOIN dbo.Tiempos tie ON tie.IdTareaTiempo = tart.IdTareaTiempo
	GROUP BY tart.IdTarea
	

GO

-- View structure for dbo.vw_bp_FacturasClientes_Lineas
CREATE VIEW dbo.vw_bp_FacturasClientes_Lineas 
AS

	SELECT
			vw.*,
			CONVERT(DECIMAL(18,2),(vw.Importe * vw.PorcentajeIVA / 100)) AS IVA,
			CONVERT(DECIMAL(18,5),(vw.ImporteSinRedondear * vw.PorcentajeIVA / 100)) AS IVA2,
			CONVERT(DECIMAL(18,2),(vw.Importe * vw.PorcentajeRecargo / 100)) AS Recargo,
			CONVERT(DECIMAL(18,2),(vw.Importe * (vw.PorcentajeIVA + vw.PorcentajeRecargo) / 100)) AS IVAYRecargo,
			CONVERT(DECIMAL(18,2),vw.Importe + (vw.Importe * (vw.PorcentajeIVA + vw.PorcentajeRecargo) / 100)) AS ImporteConIVAYRecargo,
			CONVERT(DECIMAL(18,2),(vw.Importe * vw.PorcentajeRetencion / 100)) AS Retencion
			 
	FROM	(
				SELECT 
					facLin.IdFacturaClienteLinea,
					facLin.IdFacturaCliente,
					facLin.NumOrden AS NumeroOrden,
					facLin.Concepto,
					ISNULL(facLin.Cantidad,0) AS Cantidad,
					ISNULL(facLin.Precio,0) AS Precio,
					ISNULL(facLin.Descuento,0) AS Descuento,
					facLin.IdIVA,
					facLin.IdRetencion,
					ISNULL(facLin.Porc_IVA,0) AS PorcentajeIVA,
					ISNULL(facLin.Porc_Recargo,0) AS PorcentajeRecargo,
					ISNULL(facLin.Porc_Retencion,0) AS PorcentajeRetencion,
					ISNULL(fac.DescCantidad,0) AS DescuentoCantidad,
					ISNULL(fac.DescPago,0) AS DescuentoPago,
					ISNULL(fac.OtrosDesc,0) AS OtrosDescuentos,
					facLin.IdUnidadMedida,
					facLin.IdArticulo,
					facLin.IdAlbaranLinea,
					facLin.IdMantenimientoCliente,
					facLin.IdFacturacionPeriodica,
					facLin.IdCuentaContable,
					----CONVERT(DECIMAL(18,2),
					----				(
					----						CONVERT( DECIMAL(18,6),(	ISNULL(facLin.Cantidad,0) * ISNULL(facLin.Precio,0) ))
					----					-	CONVERT( DECIMAL(18,6),((	ISNULL(facLin.Cantidad,0) * ISNULL(facLin.Precio,0) ) * ISNULL(facLin.Descuento,0) / 100))
					----					-	CONVERT( DECIMAL(18,6),((	ISNULL(facLin.Cantidad,0) * ISNULL(facLin.Precio,0) ) * ( ISNULL(fac.DescCantidad,0) + ISNULL(fac.DescPago,0) + ISNULL(fac.OtrosDesc,0) ) / 100))
					----				)
					----		) AS Importe,
					--CONVERT(DECIMAL(18,2),(ISNULL(facLin.Cantidad,0) * ISNULL(facLin.Precio,0) * (1-(ISNULL(faclin.Descuento,0)/100)) * (1 - (ISNULL(fac.DescCantidad,0)
					--																														  +ISNULL(fac.DescPago,0)
					--																														  +ISNULL(fac.OtrosDesc,0))/100))) AS Importe,
					
					ISNULL(facLin.Importe,CONVERT(DECIMAL(18,2),(ISNULL(facLin.Cantidad,0) * ISNULL(facLin.Precio,0) * (1-(ISNULL(faclin.Descuento,0)/100)) *ISNULL( CASE
																																	      WHEN ISNULL(fac.DescuentoCascada,0)=0 THEN (1-(fac.DescPago+fac.DescCantidad+fac.OtrosDesc)/100)
																																		  ELSE (1-fac.DescPago/100)*(1-fac.DescCantidad/100)*(1-fac.OtrosDesc/100) END,0)))) AS Importe,
					
			
					--CONVERT(DECIMAL(18,5),(ISNULL(facLin.Cantidad,0) * ISNULL(facLin.Precio,0) * (1-(ISNULL(faclin.Descuento,0)/100)) * (1 - (ISNULL(fac.DescCantidad,0)
					--																														  +ISNULL(fac.DescPago,0)
					--																														  +ISNULL(fac.OtrosDesc,0))/100))) AS ImporteSinRedondear,
					
					CONVERT(DECIMAL(18,5),(ISNULL(facLin.Cantidad,0) * ISNULL(facLin.Precio,0) * (1-(ISNULL(faclin.Descuento,0)/100)) * ISNULL( CASE
																																	      WHEN ISNULL(fac.DescuentoCascada,0)=0 THEN (1-(fac.DescPago+fac.DescCantidad+fac.OtrosDesc)/100)
																																		  ELSE (1-fac.DescPago/100)*(1-fac.DescCantidad/100)*(1-fac.OtrosDesc/100) END,0))) AS ImporteSinRedondear,
					
					
					
					
					ISNULL(facLin.Importe,CONVERT(DECIMAL(18,2),
							(
									CONVERT( DECIMAL(18,6),(	ISNULL(facLin.Cantidad,0) * ISNULL(facLin.Precio,0) ))
								-	CONVERT( DECIMAL(18,6),((	ISNULL(facLin.Cantidad,0) * ISNULL(facLin.Precio,0) ) * ISNULL(facLin.Descuento,0) / 100))
							)
							)) AS ImporteSinDescuentoFactura,
						Codigo,
						IdArticuloReferencia,
					facLin.IdTarifaLineaComision,
					facLin.Comision,
					ISNULL(facLin.TipoDescuento1,0) AS TipoDescuento1,
					ISNULL(facLin.TipoDescuento2,0) AS TipoDescuento2,
					facLin.Porc_Descuento1,
					facLin.Porc_Descuento2,
					ISNULL(facLin.TipoBase,0) AS TipoBase,
					facLin.IdUnidadMedidaEmpresa,
					ISNULL(facLin.CantidadEmpresa,0) AS CantidadEmpresa,
					facLin.IdAlbaranLogisticoLinea,
					fac.IdProyecto,
					facLin.Puntos,
					facLin.DescuentoPuntos,
					faclin.IdArticuloAtributoConjunto,
					ISNULL(facLin.PrecioCliente,facLin.Precio) AS PrecioCliente,
					ISNULL(facLin.CantidadCliente,facLin.Cantidad) AS CantidadCliente,
					--CONVERT(DECIMAL(18,2),(ISNULL(facLin.CantidadCliente,0) * ISNULL(facLin.PrecioCliente,facLin.Precio) * (1-(ISNULL(faclin.Descuento,0)/100)) * (1 - (ISNULL(fac.DescCantidad,0)
					--																														  +ISNULL(fac.DescPago,0)
					--																														  +ISNULL(fac.OtrosDesc,0))/100))) AS ImporteCliente,

					CONVERT(DECIMAL(18,2),(ISNULL(facLin.CantidadCliente,0) * ISNULL(facLin.PrecioCliente,facLin.Precio) * (1-(ISNULL(faclin.Descuento,0)/100)) * ISNULL(CASE
																																	      WHEN ISNULL(fac.DescuentoCascada,0)=0 THEN (1-(fac.DescPago+fac.DescCantidad+fac.OtrosDesc)/100)
																																		  ELSE (1-fac.DescPago/100)*(1-fac.DescCantidad/100)*(1-fac.OtrosDesc/100) END,0))) AS ImporteCliente,																																			  
					ISNULL(facLin.IdUnidadMedidaCliente,facLin.idUnidadMedida) AS IdUnidadMedidaCliente	,
					facLin.FactorConversionUnidad																																		  
					
				
					
				
				FROM		dbo.FacturasClientes_Lineas facLin
				INNER JOIN	dbo.FacturasClientes		fac	ON facLin.IdFacturaCliente = fac.IdFacturaCliente
			)vw





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

-- Stored Procedure structure for dbo.up_ControlPresencia_Delete
CREATE PROCEDURE [dbo].[up_ControlPresencia_Delete]
(
	@IdControlPresenciaFichaje INT
)
AS
	DELETE FROM dbo.ControlPresencia_Fichajes
	WHERE IdControlPresenciaFichaje = @IdControlPresenciaFichaje

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

-- Stored Procedure structure for dbo.up_Tiempos_Insert
CREATE PROCEDURE dbo.up_Tiempos_Insert
(
	@IdTiempo INT OUTPUT,
	@IdSociedad INT = NULL,
	@IdCentroTrabajo INT = NULL,
	@IdOrdenFabricacionTarea INT = NULL,
	@IdTarea INT = NULL,
	@IdPersonal INT = NULL,
	@IdMaquina INT = NULL,
	@FechaInicio DATETIME = NULL,
	@FechaFin DATETIME = NULL,
	@TipoMaquinaPersona TINYINT = NULL,
	@IdPadre INT = NULL,
	@Duracion FLOAT = NULL,
	@IdMantenimientoPlanificacion INT = NULL,
	@InicioFin TINYINT = NULL,
	@IdProyectoTarea INT = NULL,
	@IdTareaGenerico INT = NULL,
	@FechaImputacion DATETIME = NULL,
	@IdTurno INT = NULL,
	@Manual INT = 0,
	@InsertarConProcedimientoTareas TINYINT = 1,
	@IdIdentidad INT = NULL,
	@IdTareaTiempo INT = NULL,
	@FinalizarTarea TINYINT = NULL,
	@IdProyectoRecursoPlanificado INT = NULL,
	@IdProyecto INT = NULL,
	@IdOrdenFabricacion INT = NULL,
	@IdTiempoLogistico INT = NULL,
	@IdPack INT = NULL,
	@Observaciones VARCHAR(1000) = NULL,
	@HorasExtra TINYINT = NULL,
	@FicharAutomatico TINYINT = 0,
	@IdCentroTrabajoSeccion INT = NULL,
	@Latitud VARCHAR(50) = NULL,
	@Longitud VARCHAR(50) = NULL
)
AS
	DECLARE @CosteHora AS MONEY
    DECLARE @NombreOrdenFabricacionTarea VARCHAR(4000)
	DECLARE @CerrarTareasDesdeControlPresencia TINYINT
	
	SELECT @CerrarTareasDesdeControlPresencia = Valor FROM  dbo.Configuracion WHERE IdConfiguracion = 100
	
	IF @Manual = 0
	BEGIN
		IF @InicioFin IS NOT NULL AND @FicharAutomatico = 0
			BEGIN
			SET @FechaInicio = GETDATE()
			SET @FechaImputacion = GETDATE()
			END	
	END
	
	IF @InicioFin = 1 AND ISNULL(@HorasExtra,0) = 0
	BEGIN
		DECLARE @MinutosExtra FLOAT
		SELECT 
			@MinutosExtra = 0--DATEPART(HOUR,htd.HoraInicio) *60 + DATEPART(MINUTE,htd.HoraInicio) victor esto no existe 03/03/2026
		FROM
		
		dbo.gf_Personal P 
		--INNER JOIN dbo.Tipos T ON p.IdTurno = T.IdTipo
		--INNER JOIN HorariosTipos_Detalles htd ON htd.IdTipo = T.IdTipo
		WHERE 
			/*htd.IdTipoDetalle = 3
		AND*/	P.idpersonal = @IdPersonal
		/*AND
			CASE DATEPART(weekday,CONVERT(DATETIME,@FechaInicio))
			WHEN 1 THEN Lunes
			WHEN 2 THEN Martes
			WHEN 3 THEN Miercoles
			WHEN 4 THEN Jueves
			WHEN 5 THEN Viernes
			WHEN 6 THEN Sabado
			WHEN 7 THEN Domingo
			ELSE 0
		END = 1*/
		
		SELECT 
			@Duracion = DATEDIFF(MINUTE,FechaInicio,@FechaInicio)
		FROM 
			dbo.Tiempos
		WHERE 
				IdPersonal = @IdPersonal
			AND IdCentroTrabajo = @IdCentroTrabajo
			AND (@IdCentroTrabajoSeccion IS NULL OR IdCentroTrabajoSeccion = @IdCentroTrabajoSeccion)
			AND IdSociedad = @IdSociedad
			AND InicioFin = 0
			AND FechaFin IS NULL
		
		IF @MinutosExtra IS NOT NULL AND @Duracion  > ISNULL(@MinutosExtra,0)
		 BEGIN
			 DECLARE @DuracionRestante FLOAT
			 DECLARE @FechaInicioHoraExtra DATETIME
			 DECLARE @FechaFinHoraExtra DATETIME
			 SET @DuracionRestante = @Duracion - @MinutosExtra
			 SET @Duracion = @MinutosExtra
			 SELECT @FechaInicio =	 DATEADD(MINUTE,@Duracion,FechaInicio) FROM dbo.Tiempos   WHERE
																									IdPersonal = @IdPersonal
																								AND IdCentroTrabajo = @IdCentroTrabajo
																								AND (@IdCentroTrabajoSeccion IS NULL OR IdCentroTrabajoSeccion = @IdCentroTrabajoSeccion)
																								AND IdSociedad = @IdSociedad
																								AND InicioFin = 0
																								AND FechaFin IS NULL
			 
			 SET @FechaInicioHoraExtra = @FechaInicio
			 SET @FechaFinHoraExtra = DATEADD(MINUTE,@DuracionRestante,@FechaInicioHoraExtra)
			 DECLARE @IdTiempoInicioHoraExtra INT
			 DECLARE @IdTiempoFinHoraExtra INT
			--Insertamos inicio hora extra
			 EXEC dbo.up_Tiempos_Insert  @IdTiempo = @IdTiempoInicioHoraExtra OUTPUT,	@IdSociedad = @IdSociedad,				@IdCentroTrabajo = @IdCentroTrabajo,
										 @IdPersonal = @IdPersonal,						@FechaInicio = @FechaInicioHoraExtra ,  @FechaFin = @FechaFinHoraExtra,						       
										 @TipoMaquinaPersona = 0,						@Duracion = @DuracionRestante,  		@InicioFin = 0, 
										 @Manual = 1,									@IdIdentidad = @IdIdentidad,			@HorasExtra = 1, 
										 @IdCentroTrabajoSeccion = @IdCentroTrabajoSeccion,@FechaImputacion = @FechaInicioHoraExtra, @Latitud = @Latitud, @Longitud = @Longitud
			--Insertamos fin hora extra
			 EXEC dbo.up_Tiempos_Insert  @IdTiempo = @IdTiempoFinHoraExtra OUTPUT,		@IdSociedad = @IdSociedad,				@IdCentroTrabajo = @IdCentroTrabajo,
										 @IdPersonal = @IdPersonal,						@FechaInicio = @FechaFinHoraExtra ,		@FechaFin = null,						       
										 @TipoMaquinaPersona = 0,						@Duracion = NULL,  						@InicioFin = 1, 
										 @Manual = 1,									@IdIdentidad = @IdIdentidad,			@HorasExtra = 1, 
										 @IdCentroTrabajoSeccion = @IdCentroTrabajoSeccion, @Latitud = @Latitud, @Longitud = @Longitud
			
			IF ISNULL(@IdTiempoInicioHoraExtra,0) <> 0 AND  ISNULL(@IdTiempoFinHoraExtra,0) <> 0
				UPDATE
					dbo.Tiempos
				SET
					IdTiempoFin = @IdTiempoFinHoraExtra
				WHERE	
					IdTiempo = @IdTiempoInicioHoraExtra
		 END			
		
	END
	--IF @Manual = 0
	--BEGIN
	--	IF @InicioFin IS NOT NULL
	--		BEGIN
	--			SET @FechaInicio = GETDATE()
	--		END
		
	--	IF @InicioFin = 1
	--		BEGIN 
	--			UPDATE 
	--				 dbo.Tiempos
	--			SET 
	--				 FechaFin = @FechaInicio,
	--				 Duracion = DATEDIFF(MINUTE,FechaInicio,@FechaInicio)
	--			WHERE 
	--					IdPersonal = @IdPersonal
	--				AND IdCentroTrabajo = @IdCentroTrabajo
	--				AND IdSociedad = @IdSociedad
	--				AND InicioFin = 0
	--				AND FechaFin IS NULL
	--		END		
	--	IF @InicioFin = 3
	--		BEGIN 
	--			UPDATE 
	--				 dbo.Tiempos
	--			SET 
	--				 FechaFin = @FechaInicio,
	--				 Duracion = DATEDIFF(MINUTE,FechaInicio,@FechaInicio)
	--			WHERE 
	--					IdPersonal = @IdPersonal
	--				AND IdCentroTrabajo = @IdCentroTrabajo
	--				AND IdSociedad = @IdSociedad
	--				AND InicioFin = 2
	--				AND FechaFin IS NULL
	--		END							
	--END	
	
	--DECLARE @Contador AS INT
	--SELECT @Contador = COUNT(IdTiempo) FROM dbo.Tiempos WHERE IdOrdenFabricacionTarea = @IdOrdenFabricacionTarea
	
	IF @IdOrdenFabricacionTarea IS NOT NULL
	BEGIN
			
		UPDATE 
			dbo.OrdenesFabricacionTareas
		SET
			Estado= 2,
			FechaInicioReal = @FechaInicio,
			IdPersonalInicio = @IdPersonal
		WHERE 
				dbo.OrdenesFabricacionTareas.IdOrdenFabricacionTarea = @IdOrdenFabricacionTarea AND Estado = 1
				   		
		IF @FinalizarTarea = 1
			EXEC dbo.up_OrdenesFabricacionTareas_Update_SiguienteEstado @IdOrdenFabricacionTarea = @IdOrdenFabricacionTarea, @OrdenFabricacionTareaActual = @NombreOrdenFabricacionTarea OUTPUT, @FechaFinReal = @FechaFin, @IdPersonal = @IdPersonal
		
		DECLARE @IdProyectoTareaOF INT
		
		SELECT @IdProyectoTareaOF = IdProyectoTarea
		FROM dbo.OrdenesFabricacionTareas oft 
				INNER JOIN dbo.OrdenesFabricacion ofa ON ofa.IdOrdenFabricacion = oft.IdOrdenFabricacion
		WHERE oft.IdOrdenFabricacionTarea = @IdOrdenFabricacionTarea
		
		IF ISNULL(@IdProyectoTareaOF,0)>0
		BEGIN
			DECLARE @AbrirProyectoTarea AS INTEGER	
			SELECT 
				@AbrirProyectoTarea = ISNULL(valor,-1)
			FROM
				dbo.Configuracion c
			WHERE
				c.Nombre = 'AbrirFaseProyectoConTiempos'

			IF @AbrirProyectoTarea = 1
			BEGIN
				DECLARE @EstadoFase AS INTEGER	
				SELECT @EstadoFase= pt.Estado FROM dbo.ProyectosTareas pt WHERE pt.IdProyectoTarea = @IdProyectoTareaOF
				IF ISNULL(@EstadoFase,-1) = -1
				BEGIN
					UPDATE dbo.ProyectosTareas
					SET Estado = 0
					WHERE 
					IdProyectoTarea = @IdProyectoTareaOF
				END
			END
		END
	   IF ISNULL(@IdOrdenFabricacion,0) = 0
	   BEGIN
		 SELECT @IdOrdenFabricacion = IdOrdenFabricacion FROM OrdenesFabricacionTareas  WHERE IdOrdenFabricacionTarea = @IdOrdenFabricacionTarea
	   END	
	   UPDATE dbo.OrdenesFabricacion SET FechaInicio = @FechaInicio WHERE (FechaInicio IS NULL OR FechaInicio > @FechaInicio) AND IdOrdenFabricacion = @IdOrdenFabricacion
	END
	
	IF @IdProyectoRecursoPlanificado IS NOT NULL
	BEGIN
		UPDATE
			dbo.ProyectosRecursosPlanificados
		SET
			FechaInicio = CASE WHEN FechaInicio IS NULL THEN @FechaInicio ELSE FechaInicio END,
			FechaFin = CASE	WHEN @FinalizarTarea = 1 AND FechaFin IS NULL THEN @FechaFin ELSE FechaFin END
		WHERE
			IdProyectoRecursoPlanificado = @IdProyectoRecursoPlanificado
	END

	IF @IdMantenimientoPlanificacion IS NOT NULL 
		BEGIN
				UPDATE
					dbo.Mantenimientos_Planificaciones
				SET
					FechaInicio = CASE WHEN FechaInicio IS NULL THEN @FechaInicio ELSE FechaInicio END,
					FechaFin = CASE	WHEN @FinalizarTarea = 1 AND FechaFin IS NULL THEN @FechaFin ELSE FechaFin END
				WHERE
					IdMantenimientoPlanificacion = @IdMantenimientoPlanificacion
		END	

	IF @IdMaquina IS NOT NULL
	BEGIN
		SELECT @CosteHora = ISNULL(CosteHora,0) FROM dbo.Maquinas WHERE IdMaquina = @IdMaquina
    END
    ELSE
	BEGIN
		IF @IdPersonal IS NOT NULL
		BEGIN
			--SELECT @CosteHora = ISNULL(CosteHora,0) FROM dbo.gf_Personal WHERE idpersonal = @IdPersonal
			SELECT @CosteHora = 0
		END
	END

	IF (@IdOrdenFabricacion IS NOT NULL) AND @IdTarea IS NOT NULL
		BEGIN
		
			EXEC dbo.up_OrdenesFabricacion_Select_IdOrdenFabricacionTarea @IdOrdenFabricacionTarea = @IdOrdenFabricacionTarea OUTPUT, -- int
			    @IdTarea = @IdTarea, -- int
			    @IdOrdenFabricacion = @IdOrdenFabricacion
			  
			 IF @IdOrdenFabricacionTarea IS NOT NULL  
				SET  @IdTarea = NULL  

			 UPDATE dbo.OrdenesFabricacion SET FechaInicio = @FechaInicio WHERE (FechaInicio IS NULL OR FechaInicio > @FechaInicio) AND IdOrdenFabricacion = @IdOrdenFabricacion
		END	
	

	IF @InsertarConProcedimientoTareas = 1  AND @IdTareaGenerico IS NOT NULL
		BEGIN
			DECLARE @Horas DECIMAL(12, 2) 
			SET @Horas = @Duracion / 60
		
			EXEC dbo.up_bp_TareasTiempos_Insert @IdTareaTiempo = 0, 
			    @IdTarea = @IdTareaGenerico, -- int
			    @Fecha = @FechaInicio, -- smalldatetime
			    @Horas = @Horas, -- decimal
			    @Comentario = '', -- varchar(max)
			    @IdIdentidad = @IdIdentidad, -- int
				@IdTiempo = @IdTiempo OUTPUT 
			  
					
		END
   ELSE
	BEGIN	
	
		SET @TipoMaquinaPersona =  CASE WHEN @IdMaquina IS NULL  THEN 0 ELSE 1 enD
		 INSERT INTO
				dbo.Tiempos
				(
					IdSociedad,
					IdCentroTrabajo,
					IdOrdenFabricacionTarea,
					IdTarea,
					IdPersonal,
					IdMaquina,
					FechaInicio,
					FechaFin,
					TipoMaquinaPersona,
					IdPadre,
					Duracion,
					IdMantenimientoPlanificacion,
					InicioFin,
					IdProyectoTarea,
					IdTareaGenerico,
					FechaImputacion,
					IdTurno,
					CosteHora,
					IdTareaTiempo,
					IdProyectoRecursoPlanificado,
					IdProyecto,
					IdTiempoLogistico,
					IdPack,
					Observaciones,
					HorasExtra,
					IdCentroTrabajoSeccion,
					Latitud,
					Longitud
				)
			VALUES
				(
					@IdSociedad,
					@IdCentroTrabajo,
					@IdOrdenFabricacionTarea,
					@IdTarea,
					@IdPersonal,
					@IdMaquina,
					@FechaInicio,
					@FechaFin,
					@TipoMaquinaPersona,
					@IdPadre,
					@Duracion,
					@IdMantenimientoPlanificacion,
					@InicioFin,
					@IdProyectoTarea,
					@IdTareaGenerico,
					CAST(CONVERT(VARCHAR, @FechaImputacion, 103) AS DATETIME),
					@IdTurno,
					@CosteHora,
					@IdTareaTiempo,
					@IdProyectoRecursoPlanificado,
					@IdProyecto,
					@IdTiempoLogistico,
					@IdPack,
					@Observaciones,
					@HorasExtra,
					@IdCentroTrabajoSeccion,
					@Latitud,
					@Longitud
				)

			SET @IdTiempo = SCOPE_IDENTITY()
			
			--IF @IdProyecto IS NOT NULL
			IF ISNULL(@IdProyecto ,0) <>0
			BEGIN
				--DECLARE @InsertarMaterialAutomatico AS TINYINT
				--SET @InsertarMaterialAutomatico = 0
				--SELECT 
				--	@InsertarMaterialAutomatico = ISNULL(Valor,0) 
				--FROM 	
				--	dbo.Configuracion 
				--WHERE 
				--	Nombre = 'LineasFacturasAProyectosMateriales'
				--IF @InsertarMaterialAutomatico = 1 
				--BEGIN 
					INSERT INTO	dbo.ProyectosRecursos
					        (
					         IdProyecto,
					         IdPersonal,
					         IdMaquina,
					         IdProyectoTarea,
					         Descripcion,
					         Duracion,
					         Coste,
					         Precio,
					         Importe,
					         Beneficio,
					         IdTipoHora,
					         IdIdentidad,
					         FechaModificacion,
					         Fecha,
					         Numero,
					         IdProduccionTipoTarea,
					         Encargado,
					         IdSociedad,
					         IdTiempo
					        )
					SELECT
					         @IdProyecto, -- IdProyecto - int
					         @IdPersonal, -- IdPersonal - int
					         @IdMaquina, -- IdMaquina - int
					         @IdProyectoTarea, -- IdProyectoTarea - int
					         'Tiempo de proyecto', -- Descripcion - varchar(500)
					         @Duracion/60, -- Duracion - real
					         @CosteHora, -- Coste - real
					         0.0, -- Precio - real
					         (@Duracion/60) * @CosteHora, -- Importe - real
					         0.0, -- Beneficio - real
					         NULL, -- IdTipoHora - int
					         @IdIdentidad, -- IdIdentidad - int
					         GETDATE(), -- FechaModificacion - smalldatetime
					         @FechaInicio, -- Fecha - smalldatetime
					         NULL, -- Numero - varchar(50)
					         NULL, -- IdProduccionTipoTarea - int
					         0, -- Encargado - tinyint
					         @IdSociedad, -- IdSociedad - int
					         @IdTiempo  -- IdTiempo - int

				--END
			END
	END

--IF @Manual = 0
--	BEGIN
		--IF @InicioFin IS NOT NULL
		--	BEGIN
		--		SET @FechaInicio = GETDATE()
		--	END
		
		IF @InicioFin = 1
			BEGIN 
				UPDATE 
					 dbo.Tiempos
				SET 
					 FechaFin = CASE WHEN @Manual = 0 THEN @FechaInicio ELSE FechaFin END,
					 Duracion = CASE WHEN @Manual = 0 THEN DATEDIFF(MINUTE,FechaInicio,@FechaInicio) ELSE Duracion END,
					 IdTiempoFin = @IdTiempo
				WHERE 
						IdPersonal = @IdPersonal
					AND IdCentroTrabajo = @IdCentroTrabajo
					--AND (@IdCentroTrabajoSeccion IS NULL OR IdCentroTrabajoSeccion = @IdCentroTrabajoSeccion)
					AND IdSociedad = @IdSociedad
					AND InicioFin = 0
					AND FechaFin IS NULL
					AND FechaInicio < @FechaInicio
				
			END		
		IF @InicioFin = 3
			BEGIN 
				UPDATE 
					 dbo.Tiempos
				SET 
					 FechaFin = CASE WHEN @Manual = 0 THEN  @FechaInicio ELSE FechaFin END	,
					 Duracion = CASE WHEN @Manual = 0 THEN DATEDIFF(MINUTE,FechaInicio,@FechaInicio) ELSE Duracion END,
					 IdTiempoFin = @IdTiempo
				WHERE 
						IdPersonal = @IdPersonal
					AND IdCentroTrabajo = @IdCentroTrabajo
					--AND (@IdCentroTrabajoSeccion IS NULL OR IdCentroTrabajoSeccion = @IdCentroTrabajoSeccion)
					AND IdSociedad = @IdSociedad
					AND InicioFin = 2
					AND FechaFin IS NULL
					AND FechaInicio < @FechaInicio
					
			
			END		
		-- Si el personal esta introduciendo una salida se cierran las tareas que tiene abiertas( si corresponde)
		IF (@InicioFin = 1 OR @InicioFin = 3) AND ISNULL(@CerrarTareasDesdeControlPresencia,0) = 1
			EXEC up_Tiempos_Update_FechaFin @CadenaIdsPersonal = @IdPersonal
					
	--END	




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

-- Stored Procedure structure for dbo.up_bp_Presupuestos_Lineas_Select_PermitirCrearTareas


CREATE PROCEDURE dbo.up_bp_Presupuestos_Lineas_Select_PermitirCrearTareas
(
	@IdPresupuestoLinea INT
)
AS
	-- 1º Comprobamos si la línea de presupuesto está albaraneada
	-- 2º Si está albaraneada comprobamos si para esa sociedad está permitido crear tareas en lineas de presupuesto albaraneadas

	DECLARE @LineaPresupuestoAlbaraneada TINYINT
	DECLARE @IdSociedad INT
	DECLARE @PresupuestosLineasPermitirTareasSiAlbaraneado VARCHAR(50)

	-- 1º Comprobamos si la línea de presupuesto está albaraneada
	IF EXISTS (SELECT a_l.IdAlbaranLinea FROM dbo.Albaranes_Lineas a_l WHERE a_l.IdPresupuestoLinea = @IdPresupuestoLinea)
		BEGIN
			
			SET @LineaPresupuestoAlbaraneada = 1
			
			SELECT 	@IdSociedad = a.IdSociedad 		
			FROM		dbo.Albaranes			a
			INNER JOIN	dbo.Albaranes_Lineas	a_l ON a.IdAlbaran = a_l.IdAlbaran
			WHERE a_l.IdPresupuestoLinea = @IdPresupuestoLinea

		END
	ELSE
		BEGIN
			SET @LineaPresupuestoAlbaraneada = 0
			SET @IdSociedad = 0
		END 

	-- 2º Si está albaraneada comprobamos si para esa sociedad está permitido asignar tiempos a tareas albaraneadas

	SELECT @PresupuestosLineasPermitirTareasSiAlbaraneado = soc.Valor
	FROM		dbo.SociedadesConfiguracion	con
	INNER JOIN	dbo.SociedadesConfiguracion_Sociedades	soc ON con.IdSociedadConfiguracion = soc.IdSociedadConfiguracion
	WHERE	con.Nombre LIKE '%PresupuestosLineasPermitirTareasSiAlbaraneado%'
		AND soc.IdSociedad = @IdSociedad

	IF @LineaPresupuestoAlbaraneada = 0 
		BEGIN
			RETURN 1
		END
	ELSE IF @LineaPresupuestoAlbaraneada = 1 AND ( @PresupuestosLineasPermitirTareasSiAlbaraneado LIKE '%1%' OR UPPER(@PresupuestosLineasPermitirTareasSiAlbaraneado) LIKE '%S%')
		BEGIN
			RETURN 1
		END
	ELSE
		BEGIN
			RETURN 0
		END 



GO

-- Stored Procedure structure for dbo.up_bp_Presupuestos_Update_EstudioCostesPorIdPresupuesto
CREATE PROCEDURE dbo.up_bp_Presupuestos_Update_EstudioCostesPorIdPresupuesto
(
	@IdPresupuesto INT,
	@IdIdentidad INT = NULL
)
AS
	
	DECLARE @ImporteCostesPrevistosPersonalTareas DECIMAL(12, 2) 
	DECLARE @ImporteCostesPrevistosPersonalOtros DECIMAL(12, 2) 
	DECLARE @ImporteCostesPrevistosPersonal DECIMAL(12, 2) 
	DECLARE @TotalCostesPrevistosPersonal DECIMAL(12, 2)
	DECLARE @TotalCostesPrevistosProveedores DECIMAL(12, 2) 
	DECLARE @TotalCostesPrevistosOtrosCostes DECIMAL(12, 2) 

	DECLARE @ImporteCostesRealesPersonalTareas DECIMAL(12, 2) 
	DECLARE @ImporteCostesRealesPersonalOtros DECIMAL(12, 2) 
	DECLARE @ImporteCostesRealesPersonal DECIMAL(12, 2) 
	DECLARE @TotalCostesRealesPersonal DECIMAL(12, 2)
	DECLARE @TotalCostesRealesProveedores DECIMAL(12, 2) 
	DECLARE @TotalCostesRealesOtrosCostes DECIMAL(12, 2) 

	DECLARE @PorcentajeCosteEstructural DECIMAL(10, 2) 
	DECLARE @MostrarTareasCostesPrevistosPersonal TINYINT 

	-- Valores de configuración
	DECLARE @IdSociedad INT
	DECLARE @Conf_TareasCostesPrevistosPersonal VARCHAR(200)
	DECLARE @Conf_PorcentajeCosteEstructural  VARCHAR(200)

	SELECT @IdSociedad = pre.IdSociedad FROM dbo.Presupuestos pre WHERE pre.IdPresupuesto = @IdPresupuesto
	
	SELECT
		@Conf_TareasCostesPrevistosPersonal = soc.Valor
	FROM
				dbo.SociedadesConfiguracion				con
	INNER JOIN	dbo.SociedadesConfiguracion_Sociedades	soc ON con.IdSociedadConfiguracion = soc.IdSociedadConfiguracion
	WHERE
			con.Nombre LIKE 'TareasCostesPrevistosPersonal'
		AND soc.IdSociedad = @IdSociedad

	SELECT
		@Conf_PorcentajeCosteEstructural = soc.Valor
	FROM
				dbo.SociedadesConfiguracion				con
	INNER JOIN	dbo.SociedadesConfiguracion_Sociedades	soc ON con.IdSociedadConfiguracion = soc.IdSociedadConfiguracion
	WHERE
			con.Nombre LIKE 'PorcentajeCosteEstructural'
		AND soc.IdSociedad = @IdSociedad

	SELECT	/*Si no está guardado el estudio de coste (Nuevo), se coge el valor de configuración, sino (Modificar), se coge el valor guardado en el presupuesto*/	
		@PorcentajeCosteEstructural = ISNULL(pre.PorcentajeCosteEstructural, CONVERT(DECIMAL(10,2),ISNULL(@Conf_PorcentajeCosteEstructural,0))),
		@MostrarTareasCostesPrevistosPersonal = ISNULL(pre.MostrarTareasCostesPrevistosPersonal, ISNULL( @Conf_TareasCostesPrevistosPersonal,1)) 

	FROM
			dbo.Presupuestos pre
	WHERE	pre.IdPresupuesto = @IdPresupuesto


	-- COSTES PREVISTOS

	 -- Personal tareas
	SET @ImporteCostesPrevistosPersonalTareas = 0

	IF @MostrarTareasCostesPrevistosPersonal = 1 
		BEGIN

			SELECT	@ImporteCostesPrevistosPersonalTareas = ISNULL(SUM(CONVERT(DECIMAL(12,2),ISNULL(Tar.HorasEstimadas,0) * ISNULL(tar.Coste,0))),0)
			FROM	dbo.Tareas tar
			WHERE	tar.IdPresupuesto = @IdPresupuesto
			
		END

	-- Personal otros
	SET @ImporteCostesPrevistosPersonalOtros = 0
	
	SELECT	@ImporteCostesPrevistosPersonalOtros = ISNULL(SUM(CONVERT(DECIMAL(12,2),ISNULL(pre.Horas,0) * ISNULL(pre.CosteHora,0))),0)
	FROM	dbo.bp_PresupuestosEstudioCostesPersonal	pre
	WHERE	pre.IdPresupuesto = @IdPresupuesto
		AND pre.IdTipoEstudioCoste = 5

    SET @ImporteCostesPrevistosPersonal = @ImporteCostesPrevistosPersonalTareas + @ImporteCostesPrevistosPersonalOtros
    SET @TotalCostesPrevistosPersonal = @ImporteCostesPrevistosPersonal + (@ImporteCostesPrevistosPersonal * @PorcentajeCosteEstructural / 100)

	-- Proveedores
	SET @TotalCostesPrevistosProveedores = 0

	SELECT	@TotalCostesPrevistosProveedores = ISNULL(SUM(
													CONVERT(DECIMAL(12,2),  
														(pre.Cantidad * pre.Precio)
														-
														(pre.Cantidad * pre.Precio * pre.Descuento / 100)
													)
												   ),0)
	FROM	dbo.bp_PresupuestosEstudioCostesProveedores		pre
	WHERE	pre.IdPresupuesto = @IdPresupuesto
		AND pre.IdTipoEstudioCoste = 5
				
    -- Otros
	SET @TotalCostesPrevistosOtrosCostes = 0

	SELECT	@TotalCostesPrevistosOtrosCostes = ISNULL(SUM(CONVERT(DECIMAL(12,2),ISNULL(pre.Cantidad,0) * ISNULL(pre.Precio,0))),0)
	FROM	dbo.bp_PresupuestosEstudioCostesOtros pre
	WHERE	pre.IdPresupuesto = @IdPresupuesto
		AND pre.IdTipoEstudioCoste = 5


	-- COSTES REALES

	-- Personal tareas
	SET @ImporteCostesRealesPersonalTareas = 0

	SELECT	@ImporteCostesRealesPersonalTareas = ISNULL(SUM(CONVERT(DECIMAL(12,2),ISNULL(Tiem.Total,0) * ISNULL(tar.Coste,0))),0)
	FROM		dbo.Tareas tar
	LEFT  JOIN  dbo.vw_Tareas_Tiempos		Tiem	ON Tiem.IdTarea = Tar.IdTarea
	WHERE	tar.IdPresupuesto = @IdPresupuesto

	-- Personal otros
	SET @ImporteCostesRealesPersonalOtros = 0

	SELECT	@ImporteCostesRealesPersonalOtros = ISNULL(SUM(CONVERT(DECIMAL(12,2),ISNULL(pre.Horas,0) * ISNULL(pre.CosteHora,0))),0)
	FROM	dbo.bp_PresupuestosEstudioCostesPersonal	pre
	WHERE	pre.IdPresupuesto = @IdPresupuesto
		AND pre.IdTipoEstudioCoste = 4

    SET @ImporteCostesRealesPersonal = @ImporteCostesRealesPersonalTareas + @ImporteCostesRealesPersonalOtros
    SET @TotalCostesRealesPersonal = @ImporteCostesRealesPersonal + (@ImporteCostesRealesPersonal * @PorcentajeCosteEstructural / 100)

	-- Proveedores
	SET @TotalCostesRealesProveedores = 0

	SELECT	@TotalCostesRealesProveedores = ISNULL(SUM(
													CASE WHEN pre.IdFacturaProveedorLinea IS NOT NULL THEN 
																CONVERT(DECIMAL(12,2),  
																		(pre.Cantidad * fpl.Precio)
																		-
																		(pre.Cantidad * fpl.Precio * fpl.Descuento / 100)
																	)
														 ELSE
																CONVERT(DECIMAL(12,2),  
																		(pre.Cantidad * pre.Precio)
																		-
																		(pre.Cantidad * pre.Precio * pre.Descuento / 100)
																	)
													END
												   ),0)
	FROM		dbo.bp_PresupuestosEstudioCostesProveedores		pre
	LEFT  JOIN	dbo.FacturasProveedores_Lineas					fpl		ON fpl.IdFacturaProveedorLinea = pre.IdFacturaProveedorLinea
	WHERE	pre.IdPresupuesto = @IdPresupuesto
		AND pre.IdTipoEstudioCoste = 4

	-- Otros
	SET @TotalCostesRealesOtrosCostes = 0

	SELECT	@TotalCostesRealesOtrosCostes = ISNULL(SUM(CONVERT(DECIMAL(12,2),ISNULL(pre.Cantidad,0) * ISNULL(pre.Precio,0))),0)
	FROM	dbo.bp_PresupuestosEstudioCostesOtros pre
	WHERE	pre.IdPresupuesto = @IdPresupuesto
		AND pre.IdTipoEstudioCoste = 4


	-- ACTUALIZAR
	UPDATE
		dbo.Presupuestos
	SET
		ImporteCostesPrevistosPersonal = @ImporteCostesPrevistosPersonal,
		TotalCostesPrevistosPersonal = @TotalCostesPrevistosPersonal,
		TotalCostesPrevistosProveedores = @TotalCostesPrevistosProveedores,
		TotalCostesPrevistosOtrosCostes = @TotalCostesPrevistosOtrosCostes,

		ImporteCostesRealesPersonal = @ImporteCostesRealesPersonal,
		TotalCostesRealesPersonal = @TotalCostesRealesPersonal,
		TotalCostesRealesProveedores = @TotalCostesRealesProveedores,
		TotalCostesRealesOtrosCostes = @TotalCostesRealesOtrosCostes,

		PorcentajeCosteEstructural = @PorcentajeCosteEstructural,
		MostrarTareasCostesPrevistosPersonal = @MostrarTareasCostesPrevistosPersonal,

		IdIdentidad = @IdIdentidad,
		FechaModificacion = CAST(CONVERT(VARCHAR, GETDATE(), 103) AS SMALLDATETIME)

	WHERE
		(IdPresupuesto = @IdPresupuesto)
	



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

-- Stored Procedure structure for dbo.up_bp_Tareas_EnviarEmail
CREATE PROCEDURE dbo.up_bp_Tareas_EnviarEmail
(
	@InicioFin INT, --0 - inicio, 1 - fin
	@Descripcion VARCHAR(2000),
	@Email VARCHAR(350),
	@Cliente VARCHAR(150),
	@NumeroTarea VARCHAR(15)
)
AS 
DECLARE @Asunto AS VARCHAR(50)
   
	DECLARE @Inicio AS VARCHAR(MAX) = '<!DOCTYPE html>
											<html lang="es"><head><meta charset="UTF-8">
											<title>Tareas finalizadas</title>
											<style type="text/css">
											<!--
											* {
												font-family:  Verdana, Arial, Helvetica, sans-serif;
											}
											.Estilo1 {
												font-family:  Verdana, Arial, Helvetica, sans-serif;
												font-size: 13px;
											}
											.Estilo2 {
												font-family:  Verdana, Arial, Helvetica, sans-serif;
												font-size: 9px;
											}
											.Estilo3 {
												font-family:  Verdana, Arial, Helvetica, sans-serif;
												font-size: 11px;
												color: #003399;
											}
											.Estilo4 {font-family:  Verdana, Arial, Helvetica, sans-serif;color: #000000}
											.Estilo5 {
												font-family:  Verdana, Arial, Helvetica, sans-serif;
												font-size: 9px;
											}
											-->
											</style>
											</head>
											<body>
											<table width="740" border="0" cellpadding="7" cellspacing="0"><tr><td colspan="2"><span>
											<img width=740 height=90 src="Onix.png" alt="Onix"></span></td>
											  </tr><tr><td colspan="2" valign="top">'
	DECLARE @Fin AS VARCHAR(MAX) = '<div class="Estilo1">Un saludo.</div>
									</tr><tr>
										<td class="Estilo3"><strong>INTECO<sup>©</sup> Ingenier&iacute;a avanzada</strong><br>
										  Calle Marín 30, Oficina 8<br>
										  36211 Vigo (Espa&ntilde;a) </td>
										<td align="right"><span class="Estilo3"><a href="mailto:soporte@intecoingenieria.es">soporte@intecoingenieria.es</a><br>
										  telf. +34 986 493 459<br>
										  fax. +34 986 493 296</span></td>
									  </tr>
									  <tr>
										<td colspan="2"><div align="justify"><span class="Estilo2">La informaci&oacute;n contenida en este documento y los archivos adjuntos es privada y confidencial, y est&aacute; destinada al uso exclusivo de su destinatario. Queda prohibida la reproducci&oacute;n, publicaci&oacute;n o divulgaci&oacute;n, total o parcial del mensaje, as&iacute; como el uso no autorizado por el emisor. En caso de recibir el mensaje por error rogamos proceda a su eliminaci&oacute;n as&iacute; como la de todas sus copias, y comunique inmediatamente esta circunstancia al remitente.</span></div></td>
									  </tr>
									</table>
									</body></html>'
	DECLARE @ContenidoOnix AS VARCHAR(MAX) = ''
	IF @InicioFin = 0
	BEGIN
		SET @Asunto = 'Tarea de Onix nº ' + @NumeroTarea  + ' registrada. '+ @Cliente
		 SET @ContenidoOnix = '<div class="Estilo1">Estimado ' + @Cliente + ', le informamos que acabamos de registrar con el nº <b>' + @NumeroTarea + '</b>  la siguiente tarea:</div><br/>' + 
							'<div class="Estilo1">' + @Descripcion + '</div><br/>' + 
							'<div class="Estilo1">Próximamente recibirá comunicación de la realización de su tarea.</div><br/>' 
	END
	ELSE 
	BEGIN
		 SET @Asunto = 'Tarea de Onix nº ' + @NumeroTarea  + ' finalizada. ' + @Cliente--  FORMAT(GETDATE(), 'dd/MM/yyyy HH:mm') 
		 SET @ContenidoOnix ='<div class="Estilo1">Estimado ' + @Cliente + ', nos es grato comunicarle que se acaba de finalizar la tarea con el nº <b>' + @NumeroTarea + '</b>:</div><br/>' + 
							'<div class="Estilo1"><div class="Estilo1">' + @Descripcion + '</div><br/>' + 
							'<div class="Estilo1">Será incluida esta acción en la próxima actualización. Si no la encuentra póngase en contacto con nosotros.</div><br/>' 
	END
	DECLARE @Body VARCHAR(MAX)
	SELECT
				@Body = @Inicio
				+ ISNULL(@ContenidoOnix,'')
				+ @Fin

				--SELECT @email, @body,@Asunto

			EXEC msdb.dbo.sp_send_dbmail
					@profile_name = 'IntecoDistribucion.Soporte',
					@recipients = @Email, --'moises@intecoingenieria.com;jlago@intecoingenieria.com;marta@intecoingenieria.com;rcastro@intecoingenieria.com;alejandro@esquio.es;informatica@gruporg.eu',
					@blind_copy_recipients= 'tareas@intecoingenieria.com',
					@body = @Body,
					@subject = @Asunto,
					@file_attachments = 'C:\Onix.png',
					@body_format = 'HTML'; 

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

-- Stored Procedure structure for dbo.up_bp_Tareas_Select_PermitirAsignarTiempos

CREATE PROCEDURE dbo.up_bp_Tareas_Select_PermitirAsignarTiempos
(
	@IdTarea INT 
)
AS
	-- 1º Comprobamos si la tarea está albaraneada por si sola
	-- 2º Comprobamos si la tarea viene de una línea de presupuesto y está albaraneada
	-- 3º Si está albaraneada comprobamos si para esa sociedad está permitido asignar tiempos a tareas albaraneadas

	DECLARE @TareaAlbaraneada TINYINT
	DECLARE @IdSociedad INT
	DECLARE @TareasPermitirTiemposSiAlbaraneada VARCHAR(50)

	-- 1º Comprobamos si la tarea está albaraneada por si sola
	IF EXISTS (SELECT a_l.IdAlbaranLinea FROM dbo.Albaranes_Lineas a_l WHERE a_l.IdTarea = @IdTarea)
		BEGIN
			
			SET @TareaAlbaraneada = 1
			
			SELECT 	@IdSociedad = a.IdSociedad 		
			FROM		dbo.Albaranes			a
			INNER JOIN	dbo.Albaranes_Lineas	a_l ON a.IdAlbaran = a_l.IdAlbaran
			WHERE a_l.IdTarea = @IdTarea

		END
	-- 2º Comprobamos si la tarea viene de una línea de presupuesto y está albaraneada
	ELSE IF EXISTS (SELECT a_l.IdAlbaranLinea 
					FROM		dbo.Albaranes_Lineas	a_l
					INNER JOIN	dbo.Tareas				tar ON a_l.IdPresupuestoLinea = tar.IdPresupuestoLinea
					WHERE tar.IdTarea = @IdTarea ) 
		BEGIN
			
			SET @TareaAlbaraneada = 1

			SELECT 	@IdSociedad = a.IdSociedad 		
			FROM		dbo.Albaranes			a
			INNER JOIN	dbo.Albaranes_Lineas	a_l ON a.IdAlbaran = a_l.IdAlbaran
			INNER JOIN	dbo.Tareas				tar ON a_l.IdPresupuestoLinea = tar.IdPresupuestoLinea
			WHERE tar.IdTarea = @IdTarea

		END
	ELSE
		BEGIN
			SET @TareaAlbaraneada = 0
			SET @IdSociedad = 0
		END 

	-- 3º Si está albaraneada comprobamos si para esa sociedad está permitido asignar tiempos a tareas albaraneadas

	SELECT @TareasPermitirTiemposSiAlbaraneada = soc.Valor
	FROM		dbo.SociedadesConfiguracion	con
	INNER JOIN	dbo.SociedadesConfiguracion_Sociedades	soc ON con.IdSociedadConfiguracion = soc.IdSociedadConfiguracion
	WHERE	con.Nombre LIKE '%TareasPermitirTiemposSiAlbaraneada%'
		AND soc.IdSociedad = @IdSociedad

	IF @TareaAlbaraneada = 0 
		BEGIN
			RETURN 1
		END
	ELSE IF @TareaAlbaraneada = 1 AND ( @TareasPermitirTiemposSiAlbaraneada LIKE '%1%' OR UPPER(@TareasPermitirTiemposSiAlbaraneada) LIKE '%S%')
		BEGIN
			RETURN 1
		END
	ELSE
		BEGIN
			RETURN 0
		END 



GO

-- Stored Procedure structure for dbo.up_bp_Tareas_Update_Prioridad

CREATE PROCEDURE dbo.up_bp_Tareas_Update_Prioridad
(
	@IdTarea INT,
	@AumentarPrioridad TINYINT = 0,
	@DisminuirPrioridad TINYINT = 0,
	@EliminarTarea TINYINT = 0 
)
AS
	/*
	Este procedimiento actualiza las prioridades de TODAS LAS TAREAS del personal asignado a la tarea que nos pasan en el parámetro @IdTarea.
	Si le pasamos los parametros @AumentarPrioridad o @DisminuirPrioridad, aumenta o disminuye la prioridad de la tarea que nos pasan en el parámetro @IdTarea.
	Con el parámetro @EliminarTarea, recalcula las prioridades de TODAS LAS TAREAS del personal asignado a la tarea excluyendo
	la tarea que nos pasan en el parámetro @IdTarea. (Esto se utiliza al eliminar una tarea, o al cambiar el personal asignado.)
	*/

	-- La prioridad empieza en 1

	DECLARE @PrioridadTareaActual INT 
	DECLARE @IdPersonalAsignado INT
	DECLARE @IdTareaAnteriorSiguiente INT
	DECLARE @PrioridadTareaAnteriorSiguiente INT 

	-- Cogemos la prioridad de la tarea y el personal asignado
	SELECT	@PrioridadTareaActual = ISNULL(t.Prioridad, 1),  
			@IdPersonalAsignado = t.IdPersonal_Asigna 
	FROM dbo.Tareas t 
	WHERE t.IdTarea = @IdTarea

	-- Primero Recalculamos la prioridad de todas las tareas del personal asignado, por si había algún error
	UPDATE dbo.Tareas SET Prioridad = PrioridadRecalculada
	FROM	
		dbo.Tareas t
	INNER JOIN  
		(	SELECT	ta.Idtarea,
					ROW_NUMBER() OVER (ORDER BY ta.Prioridad) AS PrioridadRecalculada
			FROM	dbo.Tareas ta
			WHERE	ta.IdPersonal_Asigna = @IdPersonalAsignado
				AND ta.FRealizada IS NULL
		) vw ON vw.Idtarea = t.Idtarea

	-- Ponemos la prioridad a NULL en todas las tareas ya finalizadas del personal asignado
	UPDATE dbo.Tareas SET Prioridad = NULL
	WHERE	Prioridad IS NOT NULL 
		AND FRealizada IS NOT NULL 
		AND IdPersonal_Asigna = @IdPersonalAsignado

	IF @AumentarPrioridad = 1 AND @PrioridadTareaActual > 1 -- Aumentar prioridad, sólo cuando la tarea no es la primera
		BEGIN
			
			SELECT TOP 1 @IdTareaAnteriorSiguiente = t.IdTarea,
					@PrioridadTareaAnteriorSiguiente = ISNULL(t.Prioridad, 1)
			FROM	dbo.Tareas t
			WHERE	t.IdPersonal_Asigna = @IdPersonalAsignado 
				AND t.Prioridad < @PrioridadTareaActual 
				AND t.FRealizada IS NULL
			ORDER BY t.Prioridad DESC
	
			UPDATE
				dbo.Tareas
			SET
				Prioridad = @PrioridadTareaAnteriorSiguiente
			WHERE
				IdTarea = @IdTarea

			UPDATE
				dbo.Tareas
			SET
				Prioridad = @PrioridadTareaActual
			WHERE
				IdTarea = @IdTareaAnteriorSiguiente	

		END
	ELSE IF @DisminuirPrioridad = 1 -- Disminuir la prioridad
		BEGIN

			SELECT TOP 1 @IdTareaAnteriorSiguiente = t.IdTarea,
					@PrioridadTareaAnteriorSiguiente = ISNULL(t.Prioridad, -1)
			FROM	dbo.Tareas t
			WHERE	t.IdPersonal_Asigna = @IdPersonalAsignado 
				AND t.Prioridad > @PrioridadTareaActual 
				AND t.FRealizada IS NULL
			ORDER BY t.Prioridad 

			IF  @PrioridadTareaAnteriorSiguiente <> -1 
				BEGIN
					 UPDATE
						dbo.Tareas
					SET
						Prioridad = @PrioridadTareaAnteriorSiguiente
					WHERE
						IdTarea = @IdTarea

					UPDATE
						dbo.Tareas
					SET
						Prioridad = @PrioridadTareaActual
					WHERE
						IdTarea = @IdTareaAnteriorSiguiente	
				END
		END
	ELSE IF @EliminarTarea = 1  -- Se utiliza esta opción desde el procedimiento up_bp_Tareas_Delete y up_bp_Tareas_Update
		BEGIN
			
			UPDATE dbo.Tareas SET Prioridad = PrioridadRecalculada
			FROM	
				dbo.Tareas t
			INNER JOIN  
				(	SELECT	ta.Idtarea,
							ROW_NUMBER() OVER (ORDER BY ta.Prioridad) AS PrioridadRecalculada
					FROM	dbo.Tareas ta
					WHERE	ta.IdPersonal_Asigna = @IdPersonalAsignado
						AND ta.FRealizada IS NULL
						AND tA.IdTarea <> @IdTarea
				) vw ON vw.Idtarea = t.Idtarea

		END

GO



-- =========================================================================
-- SEED DATA FOR LOOKUP TABLES AND USER IDENTITY
-- =========================================================================

-- Data for dbo.SeguridadUnificada_TipoUsuario
SET IDENTITY_INSERT dbo.SeguridadUnificada_TipoUsuario ON;
INSERT INTO dbo.SeguridadUnificada_TipoUsuario ([IdTipoUsuario], [Numero], [Nombre], [ProcedimientoSelect], [Color], [Modo], [ProcedimientoSelectCompleto], [ProcedimientoParaDespuesDeInsertar], [NombreTabla], [NombreCampoCorreo]) VALUES (1, 1, 'Personal', 'SeguridadUnificada_TipoUsuario_Personal_Select_NoAsignado', -983056, 1, 'SeguridadUnificada_Personal_Select', NULL, 'dbo.gf_Personal', 'Email');
INSERT INTO dbo.SeguridadUnificada_TipoUsuario ([IdTipoUsuario], [Numero], [Nombre], [ProcedimientoSelect], [Color], [Modo], [ProcedimientoSelectCompleto], [ProcedimientoParaDespuesDeInsertar], [NombreTabla], [NombreCampoCorreo]) VALUES (2, 2, 'Alumnos', 'SeguridadUnificada_TipoUsuario_Alumnos_Select_NoAsignado', -983056, 1, 'SeguridadUnificada_Alumnos_Select', NULL, NULL, NULL);
INSERT INTO dbo.SeguridadUnificada_TipoUsuario ([IdTipoUsuario], [Numero], [Nombre], [ProcedimientoSelect], [Color], [Modo], [ProcedimientoSelectCompleto], [ProcedimientoParaDespuesDeInsertar], [NombreTabla], [NombreCampoCorreo]) VALUES (3, 3, 'Clientes', 'SeguridadUnificada_TipoUsuario_Clientes_Select_NoAsignado', -983056, 1, 'SeguridadUnificada_Clientes_Select', NULL, NULL, NULL);
INSERT INTO dbo.SeguridadUnificada_TipoUsuario ([IdTipoUsuario], [Numero], [Nombre], [ProcedimientoSelect], [Color], [Modo], [ProcedimientoSelectCompleto], [ProcedimientoParaDespuesDeInsertar], [NombreTabla], [NombreCampoCorreo]) VALUES (4, 4, 'Entidades impartidoras', 'SeguridadUnificada_TipoUsuario_EntidadesImpartidoras_Select_NoAsignado', -983056, 1, 'SeguridadUnificada_EntidadesImpartidoras_Select', NULL, NULL, NULL);
INSERT INTO dbo.SeguridadUnificada_TipoUsuario ([IdTipoUsuario], [Numero], [Nombre], [ProcedimientoSelect], [Color], [Modo], [ProcedimientoSelectCompleto], [ProcedimientoParaDespuesDeInsertar], [NombreTabla], [NombreCampoCorreo]) VALUES (5, 5, 'Entidades colaboradoras', 'SeguridadUnificada_TipoUsuario_EntidadesColaboradoras_Select_NoAsignado', -983056, 1, 'SeguridadUnificada_EntidadesColaboradoras_Select', NULL, NULL, NULL);
INSERT INTO dbo.SeguridadUnificada_TipoUsuario ([IdTipoUsuario], [Numero], [Nombre], [ProcedimientoSelect], [Color], [Modo], [ProcedimientoSelectCompleto], [ProcedimientoParaDespuesDeInsertar], [NombreTabla], [NombreCampoCorreo]) VALUES (6, 6, 'Docentes', 'SeguridadUnificada_TipoUsuario_Docentes_Select_NoAsignado', -983056, 1, 'SeguridadUnificada_Docentes_Select', NULL, NULL, NULL);
INSERT INTO dbo.SeguridadUnificada_TipoUsuario ([IdTipoUsuario], [Numero], [Nombre], [ProcedimientoSelect], [Color], [Modo], [ProcedimientoSelectCompleto], [ProcedimientoParaDespuesDeInsertar], [NombreTabla], [NombreCampoCorreo]) VALUES (7, 7, 'Entidades supervisoras', 'SeguridadUnificada_TipoUsuario_EntidadesSupervisoras_Select_NoAsignado', -983056, 1, 'SeguridadUnificada_EntidadesSupervisoras_Select', NULL, 'gf_EntidadesSupervisoras', NULL);
INSERT INTO dbo.SeguridadUnificada_TipoUsuario ([IdTipoUsuario], [Numero], [Nombre], [ProcedimientoSelect], [Color], [Modo], [ProcedimientoSelectCompleto], [ProcedimientoParaDespuesDeInsertar], [NombreTabla], [NombreCampoCorreo]) VALUES (8, 8, 'Personal de Entidad Impartidora', 'SeguridadUnificada_TipoUsuario_PersonalEntidadImpartidora_Select_NoAsignado', -983056, 1, 'SeguridadUnificada_PersonalEntidadImpartidora_Select', NULL, 'dbo.gf_Personal', 'Email');
SET IDENTITY_INSERT dbo.SeguridadUnificada_TipoUsuario OFF;
GO

-- Data for dbo.SeguridadUnificada_Configuracion
INSERT INTO dbo.SeguridadUnificada_Configuracion ([VersionPrincipal], [VersionSecundaria], [Fecha], [VersionPrincipalListados], [VersionSecundariaListados], [FechaListados], [Servidor], [Usuario], [Contrasena], [Origen], [Destino], [ContraseñaAltaSeguridad], [CaducidadContraseña], [NumeroMesesCaducidadContraseña], [CambioContraseñaConAutenticacionDobleFactor], [EntradaAplicacionAutenticacionDobleFactor], [AutenticacionPorAzure], [IdIdentidad], [FechaModificacion]) VALUES (0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 2, 0, 0, 0, 1, '2023-05-18T14:54:56.183Z');
GO

-- Data for dbo.ControlPresencia_TiposEvento
INSERT INTO dbo.ControlPresencia_TiposEvento ([IdControlPresenciaTipoEvento], [Descripcion]) VALUES (1, 'Entrada');
INSERT INTO dbo.ControlPresencia_TiposEvento ([IdControlPresenciaTipoEvento], [Descripcion]) VALUES (2, 'Salida');
INSERT INTO dbo.ControlPresencia_TiposEvento ([IdControlPresenciaTipoEvento], [Descripcion]) VALUES (3, 'Inicio Pausa');
INSERT INTO dbo.ControlPresencia_TiposEvento ([IdControlPresenciaTipoEvento], [Descripcion]) VALUES (4, 'Fin Pausa');
GO

-- Data for dbo.Paises
SET IDENTITY_INSERT dbo.Paises ON;
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (145, 'Mayotte', NULL, '175', NULL, 'YT', 'MYT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (146, 'México', NULL, '484', NULL, 'MX', 'MEX', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (147, 'Micronesia', NULL, '583', NULL, 'FM', 'FSM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (148, 'Moldavia', NULL, '498', NULL, 'MD', 'MDA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (149, 'Mónaco', NULL, '492', NULL, 'MC', 'MCO', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (150, 'Mongolia', NULL, '496', NULL, 'MN', 'MNG', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (151, 'Montserrat', NULL, '500', NULL, 'MS', 'MSR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (152, 'Mozambique', NULL, '508', NULL, 'MZ', 'MOZ', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (153, 'Myanmar', NULL, '104', NULL, 'MM', 'MMR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (154, 'Namibia', NULL, '516', NULL, 'NA', 'NAM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (155, 'Nauru', NULL, '520', NULL, 'NR', 'NRU', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (156, 'Nepal', NULL, '524', NULL, 'NP', 'NPL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (157, 'Nicaragua', NULL, '558', NULL, 'NI', 'NIC', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (158, 'Níger', NULL, '562', NULL, 'NE', 'NER', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (159, 'Nigeria', NULL, '566', NULL, 'NG', 'NGA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (160, 'Niue', NULL, '570', NULL, 'NU', 'NIU', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (161, 'Isla Norfolk', NULL, '574', NULL, 'NF', 'NFK', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (162, 'Noruega', NULL, '578', NULL, 'NO', 'NOR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (163, 'Nueva Caledonia', NULL, '540', NULL, 'NC', 'NCL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (164, 'Nueva Zelanda', NULL, '554', NULL, 'NZ', 'NZL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (165, 'Omán', NULL, '512', NULL, 'OM', 'OMN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (166, 'Países Bajos', NULL, '528', NULL, 'NL', 'NLD', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (167, 'Pakistán', NULL, '586', NULL, 'PK', 'PAK', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (168, 'Palau', NULL, '585', NULL, 'PW', 'PLW', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (169, 'Palestina', NULL, '275', NULL, 'PS', 'PSE', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (170, 'Panamá', NULL, '591', NULL, 'PA', 'PAN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (171, 'Papúa Nueva Guinea', NULL, '598', NULL, 'PG', 'PNG', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (172, 'Paraguay', NULL, '600', NULL, 'PY', 'PRY', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (173, 'Perú', NULL, '604', NULL, 'PE', 'PER', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (174, 'Islas Pitcairn', NULL, '612', NULL, 'PN', 'PCN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (175, 'Polinesia Francesa', NULL, '258', NULL, 'PF', 'PYF', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (176, 'Polonia', NULL, '616', NULL, 'PL', 'POL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (177, 'Portugal', NULL, '620', NULL, 'PT', 'PRT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (178, 'Puerto Rico', NULL, '630', NULL, 'PR', 'PRI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (179, 'Qatar', NULL, '634', NULL, 'QA', 'QAT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (180, 'Reino Unido', NULL, '826', NULL, 'GB', 'GBR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (181, 'Reunión', NULL, '638', NULL, 'RE', 'REU', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (182, 'Ruanda', NULL, '646', NULL, 'RW', 'RWA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (183, 'Rumania', NULL, '642', NULL, 'RO', 'ROU', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (184, 'Rusia', NULL, '643', NULL, 'RU', 'RUS', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (185, 'Sahara Occidental', NULL, '732', NULL, 'EH', 'ESH', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (186, 'Islas Salomón', NULL, '090', NULL, 'SB', 'SLB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (187, 'Samoa', NULL, '882', NULL, 'WS', 'WSM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (188, 'Samoa Americana', NULL, '016', NULL, 'AS', 'ASM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (189, 'San Cristóbal y Nevis', NULL, '659', NULL, 'KN', 'KNA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (190, 'San Marino', NULL, '674', NULL, 'SM', 'SMR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (191, 'San Pedro y Miquelón', NULL, '666', NULL, 'PM', 'SPM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (192, 'San Vicente y las Granadinas', NULL, '670', NULL, 'VC', 'VCT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (193, 'Santa Helena', NULL, '654', NULL, 'SH', 'SHN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (194, 'Santa Lucía', NULL, '662', NULL, 'LC', 'LCA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (195, 'Santo Tomé y Príncipe', NULL, '678', NULL, 'ST', 'STP', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (196, 'Senegal', NULL, '686', NULL, 'SN', 'SEN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (197, 'Serbia y Montenegro', NULL, '891', NULL, 'CS', 'SCG', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (198, 'Seychelles', NULL, '690', NULL, 'SC', 'SYC', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (199, 'Sierra Leona', NULL, '694', NULL, 'SL', 'SLE', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (200, 'Singapur', NULL, '702', NULL, 'SG', 'SGP', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (201, 'Siria', NULL, '760', NULL, 'SY', 'SYR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (202, 'Somalia', NULL, '706', NULL, 'SO', 'SOM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (203, 'Sri Lanka', NULL, '144', NULL, 'LK', 'LKA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (204, 'Suazilandia', NULL, '748', NULL, 'SZ', 'SWZ', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (205, 'Sudáfrica', NULL, '710', NULL, 'ZA', 'ZAF', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (206, 'Sudán', NULL, '736', NULL, 'SD', 'SDN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (207, 'Suecia', NULL, '752', NULL, 'SE', 'SWE', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (208, 'Suiza', NULL, '756', NULL, 'CH', 'CHE', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (209, 'Surinam', NULL, '740', NULL, 'SR', 'SUR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (210, 'Svalbard y Jan Mayen', NULL, '744', NULL, 'SJ', 'SJM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (211, 'Tailandia', NULL, '764', NULL, 'TH', 'THA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (212, 'Taiwán', NULL, '158', NULL, 'TW', 'TWN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (213, 'Tanzania', NULL, '834', NULL, 'TZ', 'TZA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (214, 'Tayikistán', NULL, '762', NULL, 'TJ', 'TJK', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (215, 'Territorio Británico del Océano Índico', NULL, '086', NULL, 'IO', 'IOT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (216, 'Territorios Australes Franceses', NULL, '260', NULL, 'TF', 'ATF', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (217, 'Timor Oriental', NULL, '626', NULL, 'TL', 'TLS', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (218, 'Togo', NULL, '768', NULL, 'TG', 'TGO', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (219, 'Tokelau', NULL, '772', NULL, 'TK', 'TKL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (220, 'Tonga', NULL, '776', NULL, 'TO', 'TON', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (221, 'Trinidad y Tobago', NULL, '780', NULL, 'TT', 'TTO', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (222, 'Túnez', NULL, '788', NULL, 'TN', 'TUN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (223, 'Islas Turcas y Caicos', NULL, '796', NULL, 'TC', 'TCA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (224, 'Turkmenistán', NULL, '795', NULL, 'TM', 'TKM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (225, 'Turquía', NULL, '792', NULL, 'TR', 'TUR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (226, 'Tuvalu', NULL, '798', NULL, 'TV', 'TUV', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (227, 'Ucrania', NULL, '804', NULL, 'UA', 'UKR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (228, 'Uganda', NULL, '800', NULL, 'UG', 'UGA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (229, 'Uruguay', NULL, '858', NULL, 'UY', 'URY', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (230, 'Uzbekistán', NULL, '860', NULL, 'UZ', 'UZB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (231, 'Vanuatu', NULL, '548', NULL, 'VU', 'VUT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (232, 'Venezuela', NULL, '862', NULL, 'VE', 'VEN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (233, 'Vietnam', NULL, '704', NULL, 'VN', 'VNM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (234, 'Islas Vírgenes Británicas', NULL, '092', NULL, 'VG', 'VGB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (235, 'Islas Vírgenes de los Estados Unidos', NULL, '850', NULL, 'VI', 'VIR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (236, 'Wallis y Futuna', NULL, '876', NULL, 'WF', 'WLF', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (237, 'Yemen', NULL, '887', NULL, 'YE', 'YEM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (238, 'Yibuti', NULL, '262', NULL, 'DJ', 'DJI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (239, 'Zambia', NULL, '894', NULL, 'ZM', 'ZMB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (240, 'Zimbabue', NULL, '716', NULL, 'ZW', 'ZWE', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (1, 'Afganistán', NULL, '004', NULL, 'AF', 'AFG', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (2, 'Islas Gland', NULL, '248', NULL, 'AX', 'ALA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (3, 'Albania', NULL, '008', NULL, 'AL', 'ALB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (4, 'Alemania', NULL, '276', NULL, 'DE', 'DEU', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (5, 'Andorra', NULL, '020', NULL, 'AD', 'AND', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (6, 'Angola', NULL, '024', NULL, 'AO', 'AGO', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (7, 'Anguilla', NULL, '660', NULL, 'AI', 'AIA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (8, 'Antártida', NULL, '010', NULL, 'AQ', 'ATA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (9, 'Antigua y Barbuda', NULL, '028', NULL, 'AG', 'ATG', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (10, 'Antillas Holandesas', NULL, '530', NULL, 'AN', 'ANT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (11, 'Arabia Saudí', NULL, '682', NULL, 'SA', 'SAU', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (12, 'Argelia', NULL, '012', NULL, 'DZ', 'DZA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (13, 'Argentina', NULL, '032', NULL, 'AR', 'ARG', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (14, 'Armenia', NULL, '051', NULL, 'AM', 'ARM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (15, 'Aruba', NULL, '533', NULL, 'AW', 'ABW', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (16, 'Australia', NULL, '036', NULL, 'AU', 'AUS', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (17, 'Austria', NULL, '040', NULL, 'AT', 'AUT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (18, 'Azerbaiyán', NULL, '031', NULL, 'AZ', 'AZE', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (19, 'Bahamas', NULL, '044', NULL, 'BS', 'BHS', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (20, 'Bahréin', NULL, '048', NULL, 'BH', 'BHR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (21, 'Bangladesh', NULL, '050', NULL, 'BD', 'BGD', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (22, 'Barbados', NULL, '052', NULL, 'BB', 'BRB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (23, 'Bielorrusia', NULL, '112', NULL, 'BY', 'BLR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (24, 'Bélgica', NULL, '056', NULL, 'BE', 'BEL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (25, 'Belice', NULL, '084', NULL, 'BZ', 'BLZ', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (26, 'Benin', NULL, '204', NULL, 'BJ', 'BEN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (27, 'Bermudas', NULL, '060', NULL, 'BM', 'BMU', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (28, 'Bhután', NULL, '064', NULL, 'BT', 'BTN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (29, 'Bolivia', NULL, '068', NULL, 'BO', 'BOL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (30, 'Bosnia y Herzegovina', NULL, '070', NULL, 'BA', 'BIH', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (31, 'Botsuana', NULL, '072', NULL, 'BW', 'BWA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (32, 'Isla Bouvet', NULL, '074', NULL, 'BV', 'BVT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (33, 'Brasil', NULL, '076', NULL, 'BR', 'BRA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (34, 'Brunéi', NULL, '096', NULL, 'BN', 'BRN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (35, 'Bulgaria', NULL, '100', NULL, 'BG', 'BGR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (36, 'Burkina Faso', NULL, '854', NULL, 'BF', 'BFA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (37, 'Burundi', NULL, '108', NULL, 'BI', 'BDI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (38, 'Cabo Verde', NULL, '132', NULL, 'CV', 'CPV', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (39, 'Islas Caimán', NULL, '136', NULL, 'KY', 'CYM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (40, 'Camboya', NULL, '116', NULL, 'KH', 'KHM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (41, 'Camerún', NULL, '120', NULL, 'CM', 'CMR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (42, 'Canadá', NULL, '124', NULL, 'CA', 'CAN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (43, 'República Centroafricana', NULL, '140', NULL, 'CF', 'CAF', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (44, 'Chad', NULL, '148', NULL, 'TD', 'TCD', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (45, 'República Checa', NULL, '203', NULL, 'CZ', 'CZE', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (46, 'Chile', NULL, '152', NULL, 'CL', 'CHL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (47, 'China', NULL, '156', NULL, 'CN', 'CHN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (48, 'Chipre', NULL, '196', NULL, 'CY', 'CYP', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (49, 'Isla de Navidad', NULL, '162', NULL, 'CX', 'CXR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (50, 'Ciudad del Vaticano', NULL, '336', NULL, 'VA', 'VAT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (51, 'Islas Cocos', NULL, '166', NULL, 'CC', 'CCK', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (52, 'Colombia', NULL, '170', NULL, 'CO', 'COL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (53, 'Comoras', NULL, '174', NULL, 'KM', 'COM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (54, 'República Democrática del Congo', NULL, '180', NULL, 'CD', 'COD', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (55, 'Congo', NULL, '178', NULL, 'CG', 'COG', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (56, 'Islas Cook', NULL, '184', NULL, 'CK', 'COK', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (57, 'Corea del Norte', NULL, '408', NULL, 'KP', 'PRK', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (58, 'Corea del Sur', NULL, '410', NULL, 'KR', 'KOR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (59, 'Costa de Marfil', NULL, '384', NULL, 'CI', 'CIV', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (60, 'Costa Rica', NULL, '188', NULL, 'CR', 'CRI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (61, 'Croacia', NULL, '191', NULL, 'HR', 'HRV', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (62, 'Cuba', NULL, '192', NULL, 'CU', 'CUB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (63, 'Dinamarca', NULL, '208', NULL, 'DK', 'DNK', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (64, 'Dominica', NULL, '212', NULL, 'DM', 'DMA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (65, 'República Dominicana', NULL, '214', NULL, 'DO', 'DOM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (66, 'Ecuador', NULL, '218', NULL, 'EC', 'ECU', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (67, 'Egipto', NULL, '818', NULL, 'EG', 'EGY', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (68, 'El Salvador', NULL, '222', NULL, 'SV', 'SLV', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (69, 'Emiratos Árabes Unidos', NULL, '784', NULL, 'AE', 'ARE', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (70, 'Eritrea', NULL, '232', NULL, 'ER', 'ERI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (71, 'Eslovaquia', NULL, '703', NULL, 'SK', 'SVK', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (72, 'Eslovenia', NULL, '705', NULL, 'SI', 'SVN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (73, 'España', NULL, '724', NULL, 'ES', 'ESP', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (74, 'Islas ultramarinas de Estados Unidos', NULL, '581', NULL, 'UM', 'UMI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (75, 'Estados Unidos', NULL, '840', NULL, 'US', 'USA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (76, 'Estonia', NULL, '233', NULL, 'EE', 'EST', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (77, 'Etiopía', NULL, '231', NULL, 'ET', 'ETH', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (78, 'Islas Feroe', NULL, '234', NULL, 'FO', 'FRO', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (79, 'Filipinas', NULL, '608', NULL, 'PH', 'PHL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (80, 'Finlandia', NULL, '246', NULL, 'FI', 'FIN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (81, 'Fiyi', NULL, '242', NULL, 'FJ', 'FJI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (82, 'Francia', NULL, '250', NULL, 'FR', 'FRA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (83, 'Gabón', NULL, '266', NULL, 'GA', 'GAB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (84, 'Gambia', NULL, '270', NULL, 'GM', 'GMB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (85, 'Georgia', NULL, '268', NULL, 'GE', 'GEO', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (86, 'Islas Georgias del Sur y Sandwich del Sur', NULL, '239', NULL, 'GS', 'SGS', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (87, 'Ghana', NULL, '288', NULL, 'GH', 'GHA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (88, 'Gibraltar', NULL, '292', NULL, 'GI', 'GIB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (89, 'Granada', NULL, '308', NULL, 'GD', 'GRD', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (90, 'Grecia', NULL, '300', NULL, 'GR', 'GRC', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (91, 'Groenlandia', NULL, '304', NULL, 'GL', 'GRL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (92, 'Guadalupe', NULL, '312', NULL, 'GP', 'GLP', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (93, 'Guam', NULL, '316', NULL, 'GU', 'GUM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (94, 'Guatemala', NULL, '320', NULL, 'GT', 'GTM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (95, 'Guayana Francesa', NULL, '254', NULL, 'GF', 'GUF', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (96, 'Guinea', NULL, '324', NULL, 'GN', 'GIN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (97, 'Guinea Ecuatorial', NULL, '226', NULL, 'GQ', 'GNQ', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (98, 'Guinea-Bissau', NULL, '624', NULL, 'GW', 'GNB', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (99, 'Guyana', NULL, '328', NULL, 'GY', 'GUY', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (100, 'Haití', NULL, '332', NULL, 'HT', 'HTI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (101, 'Islas Heard y McDonald', NULL, '334', NULL, 'HM', 'HMD', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (102, 'Honduras', NULL, '340', NULL, 'HN', 'HND', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (103, 'Hong Kong', NULL, '344', NULL, 'HK', 'HKG', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (104, 'Hungría', NULL, '348', NULL, 'HU', 'HUN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (105, 'India', NULL, '356', NULL, 'IN', 'IND', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (106, 'Indonesia', NULL, '360', NULL, 'ID', 'IDN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (107, 'Irán', NULL, '364', NULL, 'IR', 'IRN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (108, 'Iraq', NULL, '368', NULL, 'IQ', 'IRQ', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (109, 'Irlanda', NULL, '372', NULL, 'IE', 'IRL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (110, 'Islandia', NULL, '352', NULL, 'IS', 'ISL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (111, 'Israel', NULL, '376', NULL, 'IL', 'ISR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (112, 'Italia', NULL, '380', NULL, 'IT', 'ITA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (113, 'Jamaica', NULL, '388', NULL, 'JM', 'JAM', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (114, 'Japón', NULL, '392', NULL, 'JP', 'JPN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (115, 'Jordania', NULL, '400', NULL, 'JO', 'JOR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (116, 'Kazajstán', NULL, '398', NULL, 'KZ', 'KAZ', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (117, 'Kenia', NULL, '404', NULL, 'KE', 'KEN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (118, 'Kirguistán', NULL, '417', NULL, 'KG', 'KGZ', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (119, 'Kiribati', NULL, '296', NULL, 'KI', 'KIR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (120, 'Kuwait', NULL, '414', NULL, 'KW', 'KWT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (121, 'Laos', NULL, '418', NULL, 'LA', 'LAO', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (122, 'Lesotho', NULL, '426', NULL, 'LS', 'LSO', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (123, 'Letonia', NULL, '428', NULL, 'LV', 'LVA', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (124, 'Líbano', NULL, '422', NULL, 'LB', 'LBN', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (125, 'Liberia', NULL, '430', NULL, 'LR', 'LBR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (126, 'Libia', NULL, '434', NULL, 'LY', 'LBY', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (127, 'Liechtenstein', NULL, '438', NULL, 'LI', 'LIE', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (128, 'Lituania', NULL, '440', NULL, 'LT', 'LTU', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (129, 'Luxemburgo', NULL, '442', NULL, 'LU', 'LUX', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (130, 'Macao', NULL, '446', NULL, 'MO', 'MAC', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (131, 'ARY Macedonia', NULL, '807', NULL, 'MK', 'MKD', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (132, 'Madagascar', NULL, '450', NULL, 'MG', 'MDG', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (133, 'Malasia', NULL, '458', NULL, 'MY', 'MYS', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (134, 'Malawi', NULL, '454', NULL, 'MW', 'MWI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (135, 'Maldivas', NULL, '462', NULL, 'MV', 'MDV', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (136, 'Malí', NULL, '466', NULL, 'ML', 'MLI', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (137, 'Malta', NULL, '470', NULL, 'MT', 'MLT', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (138, 'Islas Malvinas', NULL, '238', NULL, 'FK', 'FLK', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (139, 'Islas Marianas del Norte', NULL, '580', NULL, 'MP', 'MNP', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (140, 'Marruecos', NULL, '504', NULL, 'MA', 'MAR', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (141, 'Islas Marshall', NULL, '584', NULL, 'MH', 'MHL', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (142, 'Martinica', NULL, '474', NULL, 'MQ', 'MTQ', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (143, 'Mauricio', NULL, '480', NULL, 'MU', 'MUS', NULL, NULL, 1, NULL, NULL);
INSERT INTO dbo.Paises ([IdPais], [Nombre], [Prefijo], [Codigo], [Observaciones], [ISO2], [ISO3], [IdIdentidad], [FechaModificacion], [Activo], [IdMaestro], [CodigoFOCVSValencia]) VALUES (144, 'Mauritania', NULL, '478', NULL, 'MR', 'MRT', NULL, NULL, 1, NULL, NULL);
SET IDENTITY_INSERT dbo.Paises OFF;
GO

-- Data for dbo.Provincias
SET IDENTITY_INSERT dbo.Provincias ON;
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (1, 'Álava', '', '1', '', 17, 73, 1, '2010-04-30T09:35:00.000Z', 'ARABA/ÁLAVA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (2, 'Albacete', NULL, '2', NULL, 5, 73, NULL, NULL, 'ALBACETE', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (3, 'Alicante', NULL, '3', NULL, 12, 73, NULL, NULL, 'ALICANTE', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (4, 'Almería', '', '4', '', 1, 73, 1, '2010-04-30T09:35:00.000Z', 'ALMERIA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (5, 'Ávila', '', '5', '', 6, 73, 1, '2010-04-30T09:35:00.000Z', 'AVILA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (6, 'Badajoz', NULL, '6', NULL, 13, 73, NULL, NULL, 'BADAJOZ', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (7, 'Islas Baleares', NULL, '7', NULL, 15, 73, NULL, NULL, 'BALEARES', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (8, 'Barcelona', NULL, '8', NULL, 7, 73, NULL, NULL, 'BARCELONA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (9, 'Burgos', NULL, '9', NULL, 6, 73, NULL, NULL, 'BURGOS', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (10, 'Cáceres', '', '10', '', 13, 73, 1, '2010-04-30T09:36:00.000Z', 'CACERES', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (11, 'Cádiz', '', '11', '', 1, 73, 1, '2010-04-30T09:36:00.000Z', 'CADIZ', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (12, 'Castellón', '', '12', '', 12, 73, 1, '2010-04-30T09:36:00.000Z', 'CASTELLON', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (13, 'Ciudad Real', NULL, '13', NULL, 5, 73, NULL, NULL, 'CIUDAD REAL', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (14, 'Córdoba', '', '14', '', 1, 73, 1, '2010-04-30T09:36:00.000Z', 'CORDOBA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (15, 'A Coruña', NULL, '15', NULL, 14, 73, NULL, NULL, 'CORUÑA (LA)', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (16, 'Cuenca', NULL, '16', NULL, 5, 73, NULL, NULL, 'CUENCA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (17, 'Girona', '', '17', '', 7, 73, 1, '2010-04-30T09:37:00.000Z', 'GERONA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (18, 'Granada', NULL, '18', NULL, 1, 73, NULL, NULL, 'GRANADA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (19, 'Guadalajara', NULL, '19', NULL, 5, 73, NULL, NULL, 'GUADALAJARA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (20, 'Guipúzcoa', '', '20', '', 17, 73, 1, '2010-04-30T09:37:00.000Z', 'GIPUZKOA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (21, 'Huelva', NULL, '21', NULL, 1, 73, NULL, NULL, 'HUELVA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (22, 'Huesca', NULL, '22', NULL, 2, 73, NULL, NULL, 'HUESCA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (23, 'Jaén', '', '23', '', 1, 73, 1, '2010-04-30T09:37:00.000Z', 'JAEN', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (24, 'León', '', '24', '', 6, 73, 1, '2010-04-30T09:41:00.000Z', 'LEON', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (25, 'Lleida', '', '25', '', 7, 73, 1, '2010-04-30T09:42:00.000Z', 'LERIDA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (26, 'La Rioja', NULL, '26', NULL, 16, 73, NULL, NULL, 'RIOJA (LA)', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (27, 'Lugo', NULL, '27', NULL, 14, 73, NULL, NULL, 'LUGO', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (28, 'Madrid', NULL, '28', NULL, 10, 73, NULL, NULL, 'MADRID', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (29, 'Málaga', '', '29', '', 1, 73, 1, '2010-04-30T09:42:00.000Z', 'MALAGA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (30, 'Murcia', NULL, '30', NULL, 19, 73, NULL, NULL, 'MURCIA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (31, 'Navarra', NULL, '31', NULL, 11, 73, NULL, NULL, 'NAVARRA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (32, 'Ourense', NULL, '32', NULL, 14, 73, NULL, NULL, 'ORENSE', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (33, 'Asturias', NULL, '33', NULL, 18, 73, NULL, NULL, 'ASTURIAS', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (34, 'Palencia', NULL, '34', NULL, 6, 73, NULL, NULL, 'PALENCIA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (35, 'Las Palmas de Gran Canaria', '', '35', '', 3, 73, 1, '2010-04-30T09:50:00.000Z', 'PALMAS (LAS)', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (36, 'Pontevedra', NULL, '36', NULL, 14, 73, NULL, NULL, 'PONTEVEDRA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (37, 'Salamanca', NULL, '37', NULL, 6, 73, NULL, NULL, 'SALAMANCA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (38, 'Sta. Cruz de Tenerife', '', '38', '', 3, 73, 1, '2010-04-30T09:50:00.000Z', 'S/C TENERIFE', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (39, 'Cantabria', NULL, '39', NULL, 4, 73, NULL, NULL, 'CANTABRIA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (40, 'Segovia', NULL, '40', NULL, 6, 73, NULL, NULL, 'SEGOVIA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (41, 'Sevilla', NULL, '41', NULL, 1, 73, NULL, NULL, 'SEVILLA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (42, 'Soria', NULL, '42', NULL, 6, 73, NULL, NULL, 'SORIA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (43, 'Tarragona', NULL, '43', NULL, 7, 73, NULL, NULL, 'TARRAGONA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (44, 'Teruel', NULL, '44', NULL, 2, 73, NULL, NULL, 'TERUEL', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (45, 'Toledo', NULL, '45', NULL, 5, 73, NULL, NULL, 'TOLEDO', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (46, 'Valencia', NULL, '46', NULL, 12, 73, NULL, NULL, 'VALENCIA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (47, 'Valladolid', NULL, '47', NULL, 6, 73, NULL, NULL, 'VALLADOLID', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (48, 'Vizcaya', NULL, '48', NULL, 17, 73, NULL, NULL, 'BIZKAIA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (49, 'Zamora', NULL, '49', NULL, 6, 73, NULL, NULL, 'ZAMORA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (50, 'Zaragoza', NULL, '50', NULL, 2, 73, NULL, NULL, 'ZARAGOZA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (51, 'Ceuta', NULL, '51', NULL, 8, 73, NULL, NULL, 'CEUTA', NULL);
INSERT INTO dbo.Provincias ([IdProvincia], [Nombre], [Prefijo], [Codigo], [Observaciones], [IdComunidad], [IdPais], [IdIdentidad], [FechaModificacion], [NombreProvincia_XML_FTFE], [IdMaestro]) VALUES (52, 'Melilla', NULL, '52', NULL, 9, 73, NULL, NULL, 'MELILLA', NULL);
SET IDENTITY_INSERT dbo.Provincias OFF;
GO

-- Data for dbo.TiposCerrados
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (1, 1, 'B', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (2, 1, 'A', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (3, 1, 'C', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (4, 1, 'D', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (5, 1, 'E', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (6, 1, 'Licencia (LCC)', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (7, 1, 'A1', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (8, 1, 'B + E', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (9, 1, 'C1', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (10, 1, 'C1 + E', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (11, 1, 'C + E', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (12, 1, 'D1', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (13, 1, 'D1 + E', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (14, 1, 'D + E', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (15, 1, 'Autorización BTP', NULL, 1, 1, 0, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (22, 3, 'Contaplus', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (23, 3, 'CAIconta', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (24, 4, 'Mensual', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (25, 4, 'Trimestral', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (26, 5, 'Mensual', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (27, 5, 'Trimestral', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (28, 6, 'DNI', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (29, 6, 'CIF', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (30, 6, 'Pasaporte', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (31, 6, 'NIE', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (32, 7, 'Hombre', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (33, 7, 'Mujer', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (34, 8, 'Enero', NULL, 1, 1, 1, NULL, 0, '1', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (35, 8, 'Febrero', NULL, 1, 1, 2, NULL, 0, '2', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (36, 8, 'Marzo', NULL, 1, 1, 3, NULL, 0, '3', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (37, 8, 'Abril', NULL, 1, 1, 4, NULL, 0, '4', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (38, 8, 'Mayo', NULL, 1, 1, 5, NULL, 0, '5', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (39, 8, 'Junio', NULL, 1, 1, 6, NULL, 0, '6', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (40, 8, 'Julio', NULL, 1, 1, 7, NULL, 0, '7', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (41, 8, 'Agosto', NULL, 1, 1, 8, NULL, 0, '8', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (42, 8, 'Septiembre', NULL, 1, 1, 9, NULL, 0, '9', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (43, 8, 'Octubre', NULL, 1, 1, 10, NULL, 0, '10', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (44, 8, 'Noviembre', NULL, 1, 1, 11, NULL, 0, '11', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (45, 8, 'Diciembre', NULL, 1, 1, 12, NULL, 0, '12', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (46, 9, '1º trimestre', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (47, 9, '2º trimestre', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (48, 9, '3º trimestre', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (49, 9, '4º trimestre', NULL, 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (50, 10, 'Sociedades', 'Tabla de Sociedades', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (51, 10, 'Clientes', 'Tabla de Clientes', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (52, 10, 'Proveedores', 'Tabla de Proveedores', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (53, 10, 'Artículos', 'Tabla de articulos', 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (54, 11, 'Texto', 'Campo de texto', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (55, 11, 'Numérico ', 'Campo numérico', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (56, 11, 'Valores ', 'Campo con valores posibles (combo)', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (57, 11, 'Fecha ', 'Campo de fecha', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (58, 6, 'Otros', 'Otros documentos', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (59, 6, 'Sin asignar', 'Documento sin asignar', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (60, 12, 'Facturas clientes', 'Facturas clientes', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (61, 12, 'Albaranes clientes', 'Albaranes clientes', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (62, 13, 'Presupuesto', 'Columna con importe presupuestado', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (63, 13, 'Real', 'Columna con importe real', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (64, 13, 'Difer. P-R', 'Columna con diferencia entre importe presupuestado y real', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (65, 13, 'Difer. R-P', 'Columna con diferencia entre importe real y presupuestado', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (66, 12, 'Pedidos proveedores', 'Pedidos proveedores', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (67, 12, 'Lotes', 'Lotes', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (68, 12, 'Proyectos', 'Proyectos', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (69, 14, 'Normal', 'Tipo de epígrafe normal en presupuestos comerciales', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (70, 14, 'Suma Epigrafes', 'Tipo de epígrafe suma en presupuestos comerciales', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (71, 14, 'Fórmula Epigrafes', 'Tipo de epígrafe fórmula en presupuestos comerciales', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (72, 15, 'Suma', 'Tipo de fórmula en epígrafes de presupuestos comerciales', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (73, 15, 'Diferencia', 'Tipo de fórmula en epígrafes de presupuestos comerciales', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (74, 15, 'Producto', 'Tipo de fórmula en epígrafes de presupuestos comerciales', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (75, 12, 'Albaranes proveedores', 'albaranes proveedores', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (76, 12, 'Clientes', 'Clientes', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (77, 12, 'Proveedores', 'Proveedores', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (78, 16, 'Sí', 'utilizado en maestros check list', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (79, 16, 'No', 'utilizado en maestros de checklist', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (80, 16, 'No aplica', 'utilizado en maestros de checklists', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (81, 12, 'Propuestas de compra', 'Propuestas de compra', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (82, 12, 'Ordenes de fabricacion', 'Ordenes de fabricacion', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (83, 12, 'Presupuestos', 'Presupuestos', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (84, 12, 'Pedidos de cliente', 'Pedidos de cliente', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (85, 12, 'Facturas proveedor', 'Facturas proveedor', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (87, 11, 'Arbol', 'Campo con valores posibles en arbol', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (88, 12, 'Partes de consumo', 'Partes de consumo', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (89, 12, 'Depositos', 'Depositos', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (90, 12, 'Inventario', 'Inventario', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (100, 12, 'Traslados', 'Traslados', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (101, 12, 'Consumos', 'Consumos', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (102, 17, 'Nacional', 'Tipo de festividad nacional', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (103, 17, 'Autonómica', 'Tipo de festividad autonómica', 1, 1, 1, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (104, 17, 'Local', 'Tipo de festividad local', 1, 1, 2, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (105, 21, 'No revisado', 'Estado de archivo no revisado', 1, 1, 0, NULL, 0, NULL, NULL, '2015-03-02T17:08:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (106, 21, 'No requerido', 'Estado de archivo no requerido', 1, 1, 1, NULL, 0, NULL, NULL, '2015-03-02T17:08:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (107, 21, 'No válido', 'Estado de archivo no válido', 1, 1, 2, NULL, 0, NULL, NULL, '2015-03-02T17:08:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (108, 21, 'Válido', 'Estado de archivo válido', 1, 1, 3, NULL, 0, NULL, NULL, '2015-03-02T17:08:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (109, 18, 'Pendiente', 'Estado de incidencia', 1, 1, 0, NULL, 0, NULL, NULL, '2015-08-07T11:12:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (110, 18, 'En resolución', 'Estado de incidencia', 1, 1, 1, NULL, 0, NULL, NULL, '2015-08-07T11:12:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (111, 18, 'Cerrada', 'Estado de incidencia', 1, 1, 2, NULL, 0, NULL, NULL, '2015-08-07T11:12:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (112, 19, 'Satisfactoriamente', 'Estado de cierre de incidencia', 1, 1, 0, NULL, 0, NULL, NULL, '2015-08-07T11:12:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (113, 19, 'No satisfactoria', 'Estado de cierre de incidencia', 1, 1, 1, NULL, 0, NULL, NULL, '2015-08-07T11:12:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (114, 19, 'Imposible solución', 'Estado de cierre de incidencia', 1, 1, 2, NULL, 0, NULL, NULL, '2015-08-07T11:12:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (115, 22, 'SELF', '', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (116, 22, 'Moodle', '', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (117, 21, 'Pte. revisión centro', 'Estado de archivo pendiente revisión centro', 1, 1, 4, NULL, 0, NULL, NULL, '2016-07-18T11:32:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (118, 22, 'Moodle Iomad (Multitenant)', '', 1, 1, 0, NULL, 0, NULL, NULL, '2016-12-22T14:50:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (119, 23, 'FiltroText', '', 1, 1, 0, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (120, 23, 'FiltroNumeric', '', 1, 1, 1, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (121, 23, 'FiltroDate', '', 1, 1, 2, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (122, 23, 'FiltroCombo', '', 1, 1, 3, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (123, 23, 'FiltroBuscar', '', 1, 1, 4, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (124, 23, 'FiltroDateDesdeHasta', '', 1, 1, 5, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (125, 24, 'Nómina', '', 1, 1, 1, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (126, 24, 'Paga extra', '', 1, 1, 2, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (127, 24, 'Atrasos', '', 1, 1, 3, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (128, 25, 'Mensual', '', 1, 1, 1, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (129, 25, 'Anual', '', 1, 1, 2, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (130, 25, 'Trimestral', '', 1, 1, 3, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (131, 26, 'Anual', '', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (132, 26, 'Contrato', '', 1, 1, 0, NULL, 0, '', NULL, NULL, NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (133, 21, 'Revisado centro', '', 1, 1, 5, NULL, 0, NULL, NULL, '2021-03-18T16:08:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (134, 27, 'Creada', '', 1, 1, 1, NULL, 0, '', NULL, '2021-05-11T12:52:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (135, 27, 'Activa, Enviada, o En proceso de firma', '', 1, 1, 2, NULL, 0, '', NULL, '2021-05-11T12:52:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (136, 27, 'Cerrada o Finalizada', '', 1, 1, 3, NULL, 0, '', NULL, '2021-05-11T12:52:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (137, 28, 'Pendiente', '', 1, 1, 1, NULL, 0, '', NULL, '2021-05-11T12:52:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (138, 28, 'Firmado', '', 1, 1, 2, NULL, 0, '', NULL, '2021-05-11T12:52:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (139, 28, 'Rechazado Firmante', '', 1, 1, 3, NULL, 0, '', NULL, '2021-05-11T12:52:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (140, 28, 'Rechazado Cliente', '', 1, 1, 4, NULL, 0, '', NULL, '2021-05-11T12:52:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (141, 7, 'No binario', NULL, 1, 1, 0, NULL, 0, NULL, NULL, '2022-01-27T11:31:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (142, 29, 'Sí', '', 1, 1, 1, NULL, 0, '', NULL, '2022-05-12T09:53:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (143, 29, 'No', '', 1, 1, 2, NULL, 0, '', NULL, '2022-05-12T09:53:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (144, 29, 'Posible', '', 1, 1, 3, NULL, 0, '', NULL, '2022-05-12T09:53:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (145, 12, 'Centros datos convocatoria', 'Datos por CIF participante en ocnvocatoria', 1, 1, 0, NULL, 0, '', NULL, '2022-07-08T11:08:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (146, 30, 'Profesionales', '', 1, 1, 1, NULL, 0, '', NULL, '2022-07-26T15:32:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (147, 30, 'Arrendamientos', '', 1, 1, 1, NULL, 0, '', NULL, '2022-07-26T15:32:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (148, 30, 'Trabajadores', '', 1, 1, 1, NULL, 0, '', NULL, '2022-07-26T15:32:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (149, 31, 'Igual a', '', 1, 1, 1, NULL, 0, '', NULL, '2022-11-08T11:08:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (150, 31, 'Igual a fin de mes', '', 1, 1, 2, NULL, 0, '', NULL, '2022-11-08T11:08:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (151, 32, 'Fecha próxima renovación', '', 1, 1, 1, 149, 0, '', NULL, '2022-11-08T11:11:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (152, 32, 'Periodo de liquidación', '', 1, 1, 2, 150, 0, '', NULL, '2022-11-08T11:11:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (153, 33, 'Fecha preinscripción', '', 1, 1, 1, NULL, 0, '', NULL, '2023-01-13T13:10:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (154, 33, 'Fecha inicio curso', '', 1, 1, 1, NULL, 0, '', NULL, '2023-01-13T13:11:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (155, 34, 'Modelo oficial', '', 1, 1, 0, NULL, 0, '', NULL, '2023-05-09T14:42:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (156, 34, 'Modelo no oficial', '', 1, 1, 1, NULL, 0, '', NULL, '2023-05-09T14:42:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (157, 35, 'Fecha resolución definitiva', '', 1, 1, 1, NULL, 0, NULL, NULL, '2023-06-08T14:28:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (158, 35, 'Fecha solicitud anticipo', '', 1, 1, 2, NULL, 0, NULL, NULL, '2023-06-08T14:28:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (159, 35, 'Fecha límite ejecución', '', 1, 1, 3, NULL, 0, NULL, NULL, '2023-06-08T14:28:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (160, 36, 'Sin firmar', '', 1, 1, 1, NULL, 0, NULL, NULL, '2023-11-27T11:46:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (161, 36, 'Firmado', '', 1, 1, 2, NULL, 0, NULL, NULL, '2023-11-27T11:46:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (162, 36, 'Erróneo', '', 1, 1, 3, NULL, 0, NULL, NULL, '2023-11-27T11:46:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (163, 37, 'Diploma', '', 1, 1, 1, NULL, 0, NULL, NULL, '2023-11-27T11:57:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (164, 38, 'No enviado', '', 1, 1, 1, NULL, 0, '', NULL, '2023-12-05T12:16:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (165, 38, 'Enviado', '', 1, 1, 2, NULL, 0, '', NULL, '2023-12-05T12:18:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (166, 38, 'Erróneo', '', 1, 1, 3, NULL, 0, '', NULL, '2023-12-05T12:19:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (167, 36, 'Firmado y enviado a blockchain', '', 1, 1, 4, NULL, 0, '', NULL, '2023-12-14T12:14:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (168, 39, 'Propia', '', 1, 1, 1, NULL, 0, '', NULL, NULL, 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (169, 39, 'Ajena', '', 1, 1, 2, NULL, 0, '', NULL, '2023-12-19T17:19:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (170, 40, 'Manuscrito', NULL, 1, 1, 1, NULL, 0, '', NULL, '2024-10-21T14:04:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (171, 40, 'Certificado', NULL, 1, 1, 2, NULL, 0, '', NULL, '2024-10-21T14:05:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (172, 37, 'Acta de evaluación', '', 1, 1, 2, NULL, 0, NULL, NULL, '2024-11-07T13:21:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (173, 41, 'Red local', '', 1, 1, 0, NULL, 0, '', NULL, '2024-12-16T10:53:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (174, 41, 'Servicio web', '', 1, 1, 1, NULL, 0, '', NULL, '2024-12-16T10:53:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (175, 42, 'Asistencia obligatoria', '', 1, 1, 1, NULL, 0, '', NULL, '2025-04-23T11:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (176, 42, 'Refuerzo', '', 1, 1, 2, NULL, 0, '', NULL, '2025-04-23T11:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (177, 42, 'Tutoría', '', 1, 1, 3, NULL, 0, '', NULL, '2025-04-23T11:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (178, 43, 'Presente', '', 1, 1, 1, NULL, 0, '', NULL, '2025-05-06T11:28:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (179, 43, 'Retraso', '', 1, 1, 2, NULL, 0, '', NULL, '2025-05-06T11:28:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (180, 43, 'Falta justificada', '', 1, 1, 3, NULL, 0, '', NULL, '2025-05-06T11:28:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (181, 43, 'Falta injustificada', '', 1, 1, 4, NULL, 0, '', NULL, '2025-05-06T11:28:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (182, 44, 'Parte teórica', '', 1, 1, 1, NULL, 0, '', NULL, '2025-05-06T11:30:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (183, 44, 'Parte práctica', '', 1, 1, 2, NULL, 0, '', NULL, '2025-05-06T11:30:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (184, 45, 'Separado', '', 1, 1, 1, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (185, 45, 'Junto', '', 1, 1, 2, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (186, 46, 'Ingenieros y Licenciados.Personal de alta dirección no incluido en el artículo 1.3.c) del Estatuto', 'Grupo de cotización Colaborem', 1, 1, 1, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (187, 46, 'Ingenieros Técnicos, Peritos y Ayudantes Titulados', 'Grupo de cotización Colaborem', 1, 1, 2, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (188, 46, 'Jefes Administrativos y de Taller', 'Grupo de cotización Colaborem', 1, 1, 3, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (189, 46, 'Ayudantes no Titulados', 'Grupo de cotización Colaborem', 1, 1, 4, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (190, 46, 'Oficiales Administrativos', 'Grupo de cotización Colaborem', 1, 1, 5, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (191, 46, 'Subalternos', 'Grupo de cotización Colaborem', 1, 1, 6, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (192, 46, 'Auxiliares Administrativos', 'Grupo de cotización Colaborem', 1, 1, 7, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (193, 46, 'Oficiales de primera y segunda', 'Grupo de cotización Colaborem', 1, 1, 8, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (194, 46, 'Oficiales de tercera y Especialistas', 'Grupo de cotización Colaborem', 1, 1, 9, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (195, 46, 'Peones', 'Grupo de cotización Colaborem', 1, 1, 10, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (196, 46, 'Trabajadores menores de dieciocho años, cualquiera que sea su categoría profesional', 'Grupo de cotización Colaborem', 1, 1, 11, NULL, 0, '', NULL, '2025-05-30T13:47:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (197, 47, 'Desempleo Contr. duración determinada Tpo. Parcial', 'Cotización Colaborem', 1, 1, 1, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (198, 47, 'Desempleo Contr. duración determinada Tpo. Completo', 'Cotización Colaborem', 1, 1, 2, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (199, 47, 'Desempleo General/Prácticas/Discapacitados', 'Cotización Colaborem', 1, 1, 3, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (200, 47, 'Sin desempleo', 'Cotización Colaborem', 1, 1, 4, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (201, 47, 'Desempleo Contr. duración determinada E.T.T.', 'Cotización Colaborem', 1, 1, 5, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (202, 48, 'Categoria 1', 'Categoría Colaborem', 1, 1, 1, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (203, 48, 'Categoria 10', 'Categoría Colaborem', 1, 1, 2, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (204, 48, 'Categoria 11', 'Categoría Colaborem', 1, 1, 3, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (205, 48, 'Categoria 2', 'Categoría Colaborem', 1, 1, 4, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (206, 48, 'Categoria 3', 'Categoría Colaborem', 1, 1, 5, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (207, 48, 'Categoria 4', 'Categoría Colaborem', 1, 1, 6, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (208, 48, 'Categoria 5', 'Categoría Colaborem', 1, 1, 7, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (209, 48, 'Categoria 6', 'Categoría Colaborem', 1, 1, 8, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (210, 48, 'Categoria 7', 'Categoría Colaborem', 1, 1, 9, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (211, 48, 'Categoria 8', 'Categoría Colaborem', 1, 1, 10, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (212, 48, 'Categoria 9', 'Categoría Colaborem', 1, 1, 11, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (213, 48, 'Gerente', 'Categoría Colaborem', 1, 1, 12, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (214, 48, 'Personal de apoyo', 'Categoría Colaborem', 1, 1, 13, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (215, 48, 'Personal Responsable', 'Categoría Colaborem', 1, 1, 14, NULL, 0, '', NULL, '2025-05-30T13:48:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (216, 49, 'Gastos de asistencia del alumnado', 'Concepto becas Colaborem', 1, 1, 1, NULL, 0, '', NULL, '2025-05-30T14:16:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (217, 50, 'Aula', 'Tipo de aula', 1, 1, 1, NULL, 0, '', NULL, '2025-06-03T12:51:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (218, 50, 'Aula práctica', 'Tipo de aula', 1, 1, 2, NULL, 0, '', NULL, '2025-06-03T12:51:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (219, 50, 'Aula complementaria', 'Tipo de aula', 1, 1, 3, NULL, 0, '', NULL, '2025-06-03T12:51:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (220, 51, 'Exento', 'Tipos de estado realización PNL', 1, 1, 3, NULL, 0, '', NULL, '2025-06-03T14:42:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (221, 51, 'Renuncia', 'Tipos de estado realización PNL', 1, 1, 4, NULL, 0, '', NULL, '2025-06-03T14:42:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (222, 52, 'Teleformación', 'Tipo de modalidad', 1, 1, 1, NULL, 0, '', NULL, '2025-06-05T11:22:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (223, 52, 'Aula virtual', 'Tipo de modalidad', 1, 1, 2, NULL, 0, '', NULL, '2025-06-05T11:22:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (224, 37, 'Certificado representante entidad y alumno curso', '', 1, 1, 3, NULL, 0, '', NULL, '2025-06-17T14:19:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (225, 53, 'Actividades Físicas y Deportivas', 'Tipos de familia profesional ministerio', 1, 1, 1, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (226, 53, 'Administración y Gestión', 'Tipos de familia profesional ministerio', 1, 1, 2, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (227, 53, 'Agraria', 'Tipos de familia profesional ministerio', 1, 1, 3, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (228, 53, 'Artes Gráficas', 'Tipos de familia profesional ministerio', 1, 1, 4, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (229, 53, 'Artes y Artesanías', 'Tipos de familia profesional ministerio', 1, 1, 5, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (230, 53, 'Comercio y Marketing', 'Tipos de familia profesional ministerio', 1, 1, 6, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (231, 53, 'Edificación y Obra Civil', 'Tipos de familia profesional ministerio', 1, 1, 7, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (232, 53, 'Electricidad y Electrónica', 'Tipos de familia profesional ministerio', 1, 1, 8, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (233, 53, 'Energía y Agua', 'Tipos de familia profesional ministerio', 1, 1, 9, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (234, 53, 'Fabricación Mecánica', 'Tipos de familia profesional ministerio', 1, 1, 10, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (235, 53, 'Hostelería y Turismo', 'Tipos de familia profesional ministerio', 1, 1, 11, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (236, 53, 'Imagen Personal', 'Tipos de familia profesional ministerio', 1, 1, 12, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (237, 53, 'Imagen y Sonido', 'Tipos de familia profesional ministerio', 1, 1, 13, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (238, 53, 'Industrias Alimentarias', 'Tipos de familia profesional ministerio', 1, 1, 14, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (239, 53, 'Industrias Extractivas', 'Tipos de familia profesional ministerio', 1, 1, 15, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (240, 53, 'Informática y Comunicaciones', 'Tipos de familia profesional ministerio', 1, 1, 16, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (241, 53, 'Instalación y Mantenimiento', 'Tipos de familia profesional ministerio', 1, 1, 17, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (242, 53, 'Madera, Mueble y Corcho', 'Tipos de familia profesional ministerio', 1, 1, 18, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (243, 53, 'Marítimo - Pesquera', 'Tipos de familia profesional ministerio', 1, 1, 19, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (244, 53, 'Química', 'Tipos de familia profesional ministerio', 1, 1, 20, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (245, 53, 'Sanidad', 'Tipos de familia profesional ministerio', 1, 1, 21, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (246, 53, 'Servicios Socioculturales y a la Comunidad', 'Tipos de familia profesional ministerio', 1, 1, 23, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (247, 53, 'Textil, Confección y Piel', 'Tipos de familia profesional ministerio', 1, 1, 24, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (248, 53, 'Transporte y Mantenimiento de Vehículos', 'Tipos de familia profesional ministerio', 1, 1, 25, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (249, 53, 'Vidrio y Cerámica', 'Tipos de familia profesional ministerio', 1, 1, 26, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (250, 53, 'Seguridad y Medio Ambiente', 'Tipos de familia profesional ministerio', 1, 1, 22, NULL, 0, '', NULL, '2025-07-16T10:58:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (251, 54, '1. Nueva tecnología avanzada de la información.', 'Tipos de sector estratégico ministerio', 1, 1, 1, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (252, 54, '2. Fabricación mecánica automatizada y robótica.', 'Tipos de sector estratégico ministerio', 1, 1, 2, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (253, 54, '3. Equipos aeronáuticos.', 'Tipos de sector estratégico ministerio', 1, 1, 3, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (254, 54, '4. Equipo de transporte ferroviario moderno.', 'Tipos de sector estratégico ministerio', 1, 1, 4, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (255, 54, '5. Vehículos basados en energía y equipos nuevos.', 'Tipos de sector estratégico ministerio', 1, 1, 5, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (256, 54, '6. Maquinaria agrícola.', 'Tipos de sector estratégico ministerio', 1, 1, 6, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (257, 54, '7. Nuevos materiales.', 'Tipos de sector estratégico ministerio', 1, 1, 7, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (258, 54, '8. Biofarmacia y productos médicos avanzados.', 'Tipos de sector estratégico ministerio', 1, 1, 8, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (259, 54, '9. Cadena de consumo: Fabricantes y distribuidores.', 'Tipos de sector estratégico ministerio', 1, 1, 9, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (260, 54, '10. Hostelería y turismo.', 'Tipos de sector estratégico ministerio', 1, 1, 10, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (261, 54, '11. Servicios de atención a personas.', 'Tipos de sector estratégico ministerio', 1, 1, 11, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (262, 54, '12. Construcción y rehabilitación de edificios.', 'Tipos de sector estratégico ministerio', 1, 1, 12, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (263, 54, '13. Otros sectores de interés debidamente caracterizados.', 'Tipos de sector estratégico ministerio', 1, 1, 13, NULL, 0, '', NULL, '2025-07-16T11:03:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (264, 51, 'Pendiente de empresa', 'Tipos de estado realización PNL', 1, 1, 0, NULL, 0, '', NULL, '2025-09-09T14:37:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (265, 51, 'No supera formación', 'Tipos de estado realización PNL', 1, 1, 1, NULL, 0, '', NULL, '2025-09-09T14:37:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (266, 51, 'Pendientes exención', 'Tipos de estado realización PNL', 1, 1, 2, NULL, 0, '', NULL, '2025-09-09T14:37:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (267, 51, 'Con empresa', 'Tipos de estado realización PNL', 1, 1, 5, NULL, 0, '', NULL, '2025-09-09T14:37:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (268, 21, 'Referencia F.', 'Estado de archivo referencia F.', 1, 1, 6, NULL, 0, NULL, NULL, '2025-10-07T09:20:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (269, 55, 'Causa Justificada: Hospitalización/Enfermedad/Accidentes o lesiones', 'Tipos causa de modificación en contratos docentes', 1, 1, 0, NULL, 0, NULL, NULL, '2025-10-16T13:06:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (270, 55, 'Causa Justificada: Permisos Familiares', 'Tipos causa de modificación en contratos docentes', 1, 1, 1, NULL, 0, NULL, NULL, '2025-10-16T13:06:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (271, 55, 'Causa Justificada: Deberes ineludibles', 'Tipos causa de modificación en contratos docentes', 1, 1, 2, NULL, 0, NULL, NULL, '2025-10-16T13:06:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (272, 55, 'Causa Justificada: Situaciones imprevistas por fuerza mayor', 'Tipos causa de modificación en contratos docentes', 1, 1, 3, NULL, 0, NULL, NULL, '2025-10-16T13:06:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (273, 55, 'Causa no Justificada: Desmotivación, descontento, poco interés', 'Tipos causa de modificación en contratos docentes', 1, 1, 4, NULL, 0, NULL, NULL, '2025-10-16T13:06:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (274, 55, 'Causa no Justificada: Problemas personales o familiares', 'Tipos causa de modificación en contratos docentes', 1, 1, 5, NULL, 0, NULL, NULL, '2025-10-16T13:06:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (275, 56, 'Cancelar', 'Tipos de RRHH Acciones', 1, 1, 1, NULL, 0, NULL, NULL, '2025-11-05T11:02:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (276, 56, 'Abrir', 'Tipos de RRHH Acciones', 1, 1, 2, NULL, 0, NULL, NULL, '2025-11-05T11:02:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (277, 56, 'Cliente 2025', 'Tipos de RRHH Acciones', 1, 1, 3, NULL, 0, NULL, NULL, '2025-11-05T11:02:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (278, 57, 'Pruebas', 'Tipos de entornos', 1, 1, 1, NULL, 0, NULL, NULL, '2025-11-11T13:10:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (279, 58, 'Verificables', 'Tipos de facturas', 1, 1, 1, NULL, 0, NULL, NULL, '2025-11-11T13:10:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (280, 58, 'No verificables', 'Tipos de facturas', 1, 1, 2, NULL, 0, NULL, NULL, '2025-11-11T13:10:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (281, 57, 'Producción', 'Tipos de entornos', 1, 1, 2, NULL, 0, NULL, NULL, '2025-11-12T08:12:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (282, 59, 'Primera', 'Orden de PNL en el curso', 1, 1, 0, NULL, 0, NULL, NULL, '2025-12-01T15:00:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (283, 59, 'Intermedia', 'Orden de PNL en el curso', 1, 1, 1, NULL, 0, NULL, NULL, '2025-12-01T15:00:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (284, 59, 'Última', 'Orden de PNL en el curso', 1, 1, 2, NULL, 0, NULL, NULL, '2025-12-01T15:00:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (285, 37, 'Módulo de informes', '', 1, 1, 4, NULL, 0, '', NULL, '2025-12-18T08:11:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (286, 60, 'Revisada', '', 1, 1, 1, NULL, 0, NULL, NULL, '2025-12-18T11:31:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (287, 60, 'Calculada', '', 1, 1, 2, NULL, 0, NULL, NULL, '2025-12-18T11:31:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (289, 61, 'Certificado de equipo', '', 1, 1, 0, NULL, 0, '', 0, '2025-12-18T13:53:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (290, 61, 'Proveedor de firma', '', 1, 1, 1, NULL, 0, '', 0, '2025-12-18T13:53:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (291, 62, 'Manual', 'Tipos de cálculo', 1, 1, 0, NULL, 0, NULL, NULL, '2026-02-05T14:27:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (292, 24, 'Paga vacaciones finiquito', '', 1, 1, 4, NULL, 0, NULL, NULL, '2026-03-25T13:57:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (293, 63, 'Personal de estructura', 'Tipos de personal', 1, 1, 0, NULL, 0, NULL, NULL, '2026-03-26T15:21:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (294, 63, 'Docente de estructura', 'Tipos de personal', 1, 1, 1, NULL, 0, NULL, NULL, '2026-03-26T15:21:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (295, 63, 'Docente', 'Tipos de personal', 1, 1, 2, NULL, 0, NULL, NULL, '2026-03-26T15:21:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (296, 63, 'Docente de escuelas profesionales', 'Tipos de personal', 1, 1, 3, NULL, 0, NULL, NULL, '2026-03-26T15:21:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (297, 24, 'Paga finiquito', '', 1, 1, 5, NULL, 0, NULL, NULL, '2026-03-30T10:57:00.000Z', NULL);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (298, 64, 'Propietario', '', 1, 1, 0, NULL, 0, '', NULL, '2026-05-07T15:28:00.000Z', 0);
INSERT INTO dbo.TiposCerrados ([IdTipo], [IdTipoDefinicion], [Nombre], [Descripcion], [Bloqueado], [Visible], [Orden], [IdTipoPadre], [PermiteSubtipo], [Tag], [IdIdentidad], [FechaModificacion], [PorDefecto]) VALUES (299, 64, 'Archivo', '', 1, 1, 1, NULL, 0, '', NULL, '2026-05-07T15:28:00.000Z', 0);
GO

-- Data for dbo.UnidadesMedida
SET IDENTITY_INSERT dbo.UnidadesMedida ON;
INSERT INTO dbo.UnidadesMedida ([IdUnidadMedida], [Nombre], [Simbolo], [IdTipo], [IdIdentidad], [FechaModificacion], [IdUnidadMedidaFranquicia], [PorDefecto]) VALUES (1, 'Metro', 'm', 1, NULL, NULL, NULL, NULL);
INSERT INTO dbo.UnidadesMedida ([IdUnidadMedida], [Nombre], [Simbolo], [IdTipo], [IdIdentidad], [FechaModificacion], [IdUnidadMedidaFranquicia], [PorDefecto]) VALUES (2, 'Kilo', 'kg', 2, 1, '2009-09-02T17:29:43.203Z', NULL, NULL);
INSERT INTO dbo.UnidadesMedida ([IdUnidadMedida], [Nombre], [Simbolo], [IdTipo], [IdIdentidad], [FechaModificacion], [IdUnidadMedidaFranquicia], [PorDefecto]) VALUES (3, 'Centímetro', 'cm', 1, 1, '2009-09-02T17:25:32.033Z', NULL, NULL);
INSERT INTO dbo.UnidadesMedida ([IdUnidadMedida], [Nombre], [Simbolo], [IdTipo], [IdIdentidad], [FechaModificacion], [IdUnidadMedidaFranquicia], [PorDefecto]) VALUES (4, 'Milímetro', 'ml', 1, 1, '2009-09-02T17:25:43.657Z', NULL, NULL);
INSERT INTO dbo.UnidadesMedida ([IdUnidadMedida], [Nombre], [Simbolo], [IdTipo], [IdIdentidad], [FechaModificacion], [IdUnidadMedidaFranquicia], [PorDefecto]) VALUES (7, 'Unidad', 'UD', 5, 1, '2009-09-02T17:30:09.877Z', NULL, NULL);
INSERT INTO dbo.UnidadesMedida ([IdUnidadMedida], [Nombre], [Simbolo], [IdTipo], [IdIdentidad], [FechaModificacion], [IdUnidadMedidaFranquicia], [PorDefecto]) VALUES (8, 'Hora', 'h', 4, 1, '2009-09-02T17:38:27.657Z', NULL, NULL);
INSERT INTO dbo.UnidadesMedida ([IdUnidadMedida], [Nombre], [Simbolo], [IdTipo], [IdIdentidad], [FechaModificacion], [IdUnidadMedidaFranquicia], [PorDefecto]) VALUES (9, 'Gramo', 'gr', 2, 1, '2009-09-02T17:38:21.593Z', NULL, NULL);
INSERT INTO dbo.UnidadesMedida ([IdUnidadMedida], [Nombre], [Simbolo], [IdTipo], [IdIdentidad], [FechaModificacion], [IdUnidadMedidaFranquicia], [PorDefecto]) VALUES (10, 'Mes', 'mes', 4, 1, '2009-09-02T17:25:22.627Z', NULL, NULL);
INSERT INTO dbo.UnidadesMedida ([IdUnidadMedida], [Nombre], [Simbolo], [IdTipo], [IdIdentidad], [FechaModificacion], [IdUnidadMedidaFranquicia], [PorDefecto]) VALUES (16, 'Milla', 'M', 1, 1, '2009-09-02T17:29:59.720Z', NULL, NULL);
SET IDENTITY_INSERT dbo.UnidadesMedida OFF;
GO

-- User Identity: mdbarca
-- Data for dbo.gf_Personal (User profile)
SET IDENTITY_INSERT dbo.gf_Personal ON;
INSERT INTO dbo.gf_Personal ([IdPersonal], [IdTipoDocumento], [Documento], [Nombre], [PrimerApellido], [SegundoApellido], [FechaNacimiento], [IdTipoSexo], [Nuss], [TelefonoFijo], [TelefonoMovil], [TelefonoTrabajo], [Extension], [Email], [Direccion], [IdPais], [CodigoPostal], [IdProvincia], [Poblacion], [Activo], [Observaciones], [IdIdentidad], [FechaModificacion], [EmailEmpresa], [EmailPersonal], [IdEntidadImpartidora], [OcultarDatosEconomicos], [Robot]) VALUES (36, 28, '54381862H', 'Máximo', 'Dabarca', 'Maniero', '2006-10-21T00:00:00.000Z', 32, '', '', '640577288', '640577288', '', 'maxdm102@gmail.com', 'Camiño da torre 27', 73, '36330', 36, 'Vigo', 1, '', 1, '2026-03-05T12:50:00.000Z', NULL, 'maxdm102@gmail.com', 48, 1, 0);
SET IDENTITY_INSERT dbo.gf_Personal OFF;
GO

-- Data for dbo.SeguridadUnificada_Identidad (Login record)
SET IDENTITY_INSERT dbo.SeguridadUnificada_Identidad ON;
INSERT INTO dbo.SeguridadUnificada_Identidad ([IdIdentidad], [IdUsuario], [IdTipoUsuario], [Usuario], [Contrasena], [ContrasenaEnc], [AvisoBackup], [Activo], [IdDominio], [FechaCambioContraseña], [FechaModificacion], [ContraseñaProvisional], [IdTipoValidacionUsuarioDominio]) VALUES (94, 36, 1, 'mdbarca', NULL, 0x020083c034707f27919388f6a29e08d4feb014dfafa31ebf57a81bcf82ac0d1920ef10485e0cff72eeb555cf0a9f1f807d13509851d8b5434a5c0a45d42433d230524bc6a74e, 0, 1, NULL, '2026-03-05T13:08:46.543Z', '2026-03-05T13:08:46.543Z', 0, NULL);
SET IDENTITY_INSERT dbo.SeguridadUnificada_Identidad OFF;
GO

-- Data for dbo.SeguridadUnificada_IdentidadGrupo (User groups)
SET IDENTITY_INSERT dbo.SeguridadUnificada_IdentidadGrupo ON;
INSERT INTO dbo.SeguridadUnificada_IdentidadGrupo ([IdIdentidadGrupo], [IdIdentidad], [IdGrupo]) VALUES (46, 94, 1);
INSERT INTO dbo.SeguridadUnificada_IdentidadGrupo ([IdIdentidadGrupo], [IdIdentidad], [IdGrupo]) VALUES (50, 94, 13);
INSERT INTO dbo.SeguridadUnificada_IdentidadGrupo ([IdIdentidadGrupo], [IdIdentidad], [IdGrupo]) VALUES (51, 94, 5);
SET IDENTITY_INSERT dbo.SeguridadUnificada_IdentidadGrupo OFF;
GO

