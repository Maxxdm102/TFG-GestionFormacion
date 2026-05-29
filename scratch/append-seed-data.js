const sql = require('mssql');
const fs = require('fs');
const path = require('path');

const config = {
  server: 'w2019-sql',
  port: 1433,
  database: 'GestionFormacion',
  user: 'us_AccesoTotal',
  password: 'us_Ilimitado',
  options: { encrypt: false, trustServerCertificate: true, enableArithAbort: true },
};

const tablesToExportData = [
  'SeguridadUnificada_TipoUsuario',
  'SeguridadUnificada_Configuracion',
  'ControlPresencia_TiposEvento',
  'Paises',
  'Provincias',
  'TiposCerrados',
  'UnidadesMedida'
];

async function run() {
  let pool;
  try {
    pool = await sql.connect(config);
    console.log('Connected to SQL Server for data seeding...');

    let sqlStatements = '\n\n-- =========================================================================\n';
    sqlStatements += '-- SEED DATA FOR LOOKUP TABLES AND USER IDENTITY\n';
    sqlStatements += '-- =========================================================================\n\n';

    // 1. Export standard lookup tables
    for (const table of tablesToExportData) {
      console.log(`Exporting data for ${table}...`);
      sqlStatements += `-- Data for dbo.${table}\n`;

      // Check if table has identity
      const identityRes = await pool.request()
        .input('tableName', sql.NVarChar(200), table)
        .query(`
          SELECT c.name AS col_name
          FROM sys.columns c
          JOIN sys.tables t ON c.object_id = t.object_id
          WHERE t.name = @tableName AND c.is_identity = 1
        `);
      
      const hasIdentity = identityRes.recordset.length > 0;
      const identityCol = hasIdentity ? identityRes.recordset[0].col_name : null;

      // Get columns
      const colsRes = await pool.request()
        .input('tableName', sql.NVarChar(200), table)
        .query(`
          SELECT COLUMN_NAME, DATA_TYPE
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE TABLE_NAME = @tableName
          ORDER BY ORDINAL_POSITION
        `);
      const cols = colsRes.recordset;
      const colNames = cols.map(c => `[${c.COLUMN_NAME}]`).join(', ');

      // Query data
      const dataRes = await pool.request().query(`SELECT * FROM dbo.${table}`);
      const rows = dataRes.recordset;

      if (rows.length === 0) {
        sqlStatements += `-- (No rows found for ${table})\n\n`;
        continue;
      }

      if (hasIdentity) {
        sqlStatements += `SET IDENTITY_INSERT dbo.${table} ON;\n`;
      }

      for (const row of rows) {
        const values = cols.map(c => {
          const val = row[c.COLUMN_NAME];
          if (val === null || val === undefined) return 'NULL';
          
          if (val instanceof Date) {
            return `'${val.toISOString()}'`;
          }
          if (Buffer.isBuffer(val)) {
            return `0x${val.toString('hex')}`;
          }
          if (typeof val === 'string') {
            // Escape single quotes
            return `'${val.replace(/'/g, "''")}'`;
          }
          if (typeof val === 'boolean') {
            return val ? '1' : '0';
          }
          return val;
        });

        sqlStatements += `INSERT INTO dbo.${table} (${colNames}) VALUES (${values.join(', ')});\n`;
      }

      if (hasIdentity) {
        sqlStatements += `SET IDENTITY_INSERT dbo.${table} OFF;\n`;
      }
      sqlStatements += 'GO\n\n';
    }

    // 2. Export User Identity & Personal records
    console.log('Exporting user mdbarca records...');
    const winUser = 'mdbarca';

    const identityRes = await pool.request()
      .input('winUser', sql.VarChar(200), winUser)
      .query(`SELECT * FROM SeguridadUnificada_Identidad WHERE Usuario = @winUser`);

    if (identityRes.recordset.length > 0) {
      const identity = identityRes.recordset[0];
      const idUsuario = identity.IdUsuario;
      const idIdentidad = identity.IdIdentidad;

      sqlStatements += `-- User Identity: mdbarca\n`;

      // Export gf_Personal record
      const personalRes = await pool.request()
        .input('idPersonal', sql.Int, idUsuario)
        .query(`SELECT * FROM gf_Personal WHERE IdPersonal = @idPersonal`);

      if (personalRes.recordset.length > 0) {
        const personal = personalRes.recordset[0];
        sqlStatements += `-- Data for dbo.gf_Personal (User profile)\n`;
        sqlStatements += `SET IDENTITY_INSERT dbo.gf_Personal ON;\n`;

        const pColsRes = await pool.request()
          .query(`SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'gf_Personal' ORDER BY ORDINAL_POSITION`);
        const pCols = pColsRes.recordset;
        const pColNames = pCols.map(c => `[${c.COLUMN_NAME}]`).join(', ');

        const pValues = pCols.map(c => {
          const val = personal[c.COLUMN_NAME];
          if (val === null || val === undefined) return 'NULL';
          if (val instanceof Date) return `'${val.toISOString()}'`;
          if (Buffer.isBuffer(val)) return `0x${val.toString('hex')}`;
          if (typeof val === 'string') return `'${val.replace(/'/g, "''")}'`;
          if (typeof val === 'boolean') return val ? '1' : '0';
          return val;
        });

        sqlStatements += `INSERT INTO dbo.gf_Personal (${pColNames}) VALUES (${pValues.join(', ')});\n`;
        sqlStatements += `SET IDENTITY_INSERT dbo.gf_Personal OFF;\nGO\n\n`;
      }

      // Export SeguridadUnificada_Identidad record
      sqlStatements += `-- Data for dbo.SeguridadUnificada_Identidad (Login record)\n`;
      sqlStatements += `SET IDENTITY_INSERT dbo.SeguridadUnificada_Identidad ON;\n`;

      const idColsRes = await pool.request()
        .query(`SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SeguridadUnificada_Identidad' ORDER BY ORDINAL_POSITION`);
      const idCols = idColsRes.recordset;
      const idColNames = idCols.map(c => `[${c.COLUMN_NAME}]`).join(', ');

      const idValues = idCols.map(c => {
        const val = identity[c.COLUMN_NAME];
        if (val === null || val === undefined) return 'NULL';
        if (val instanceof Date) return `'${val.toISOString()}'`;
        if (Buffer.isBuffer(val)) return `0x${val.toString('hex')}`;
        if (typeof val === 'string') return `'${val.replace(/'/g, "''")}'`;
        if (typeof val === 'boolean') return val ? '1' : '0';
        return val;
      });

      sqlStatements += `INSERT INTO dbo.SeguridadUnificada_Identidad (${idColNames}) VALUES (${idValues.join(', ')});\n`;
      sqlStatements += `SET IDENTITY_INSERT dbo.SeguridadUnificada_Identidad OFF;\nGO\n\n`;

      // Export SeguridadUnificada_IdentidadGrupo relations for this identity
      const groupRes = await pool.request()
        .input('idIdentidad', sql.Int, idIdentidad)
        .query(`SELECT * FROM SeguridadUnificada_IdentidadGrupo WHERE IdIdentidad = @idIdentidad`);
      
      if (groupRes.recordset.length > 0) {
        sqlStatements += `-- Data for dbo.SeguridadUnificada_IdentidadGrupo (User groups)\n`;
        sqlStatements += `SET IDENTITY_INSERT dbo.SeguridadUnificada_IdentidadGrupo ON;\n`;

        const igColsRes = await pool.request()
          .query(`SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SeguridadUnificada_IdentidadGrupo' ORDER BY ORDINAL_POSITION`);
        const igCols = igColsRes.recordset;
        const igColNames = igCols.map(c => `[${c.COLUMN_NAME}]`).join(', ');

        for (const igRow of groupRes.recordset) {
          const igValues = igCols.map(c => {
            const val = igRow[c.COLUMN_NAME];
            if (val === null || val === undefined) return 'NULL';
            if (val instanceof Date) return `'${val.toISOString()}'`;
            if (Buffer.isBuffer(val)) return `0x${val.toString('hex')}`;
            if (typeof val === 'string') return `'${val.replace(/'/g, "''")}'`;
            if (typeof val === 'boolean') return val ? '1' : '0';
            return val;
          });
          sqlStatements += `INSERT INTO dbo.SeguridadUnificada_IdentidadGrupo (${igColNames}) VALUES (${igValues.join(', ')});\n`;
        }
        sqlStatements += `SET IDENTITY_INSERT dbo.SeguridadUnificada_IdentidadGrupo OFF;\nGO\n\n`;
      }
    }

    // Append to file
    const sqlFilePath = path.join(__dirname, '..', 'database_creation_script.sql');
    fs.appendFileSync(sqlFilePath, sqlStatements, 'utf-8');
    console.log(`Successfully appended seed data to: ${sqlFilePath}`);

  } catch (e) {
    console.error('Failed to append seed data:', e);
  } finally {
    if (pool) await pool.close();
  }
}

run();
