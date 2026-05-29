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

// Start with the initial set of objects used by the Node.js application
const initialTables = [
  'gf_Clientes',
  'tiposCerrados',
  'Paises',
  'Provincias',
  'Contactos',
  'Presupuestos',
  'Presupuestos_Lineas',
  'UnidadesMedida',
  'gf_Proveedores',
  'Tareas',
  'TareasTiempos'
];

const initialViews = [
  'vw_bp_Presupuestos'
];

const initialProcedures = [
  'SeguridadUnificada_Identidad_Select',
  'up_Contactos_Select_Agrupado',
  'up_bp_Personal_Select_Corto',
  'up_ControlPresencia_Select',
  'up_ControlPresencia_Insert',
  'up_ControlPresencia_Update',
  'up_ControlPresencia_Delete',
  'up_bp_Tareas_Select',
  'up_bp_Tareas_Insert',
  'up_bp_Tareas_Delete',
  'up_bp_TareasTiempos_Insert'
];

async function run() {
  let pool;
  try {
    pool = await sql.connect(config);
    console.log('Connected to SQL Server for full extraction');

    const tablesToExtract = new Set(initialTables);
    const viewsToExtract = new Set(initialViews);
    const proceduresToExtract = new Set(initialProcedures);
    const functionsToExtract = new Set();

    // Set of all objects we started with, plus dependencies we find
    const allObjectsToCheck = [...initialViews, ...initialProcedures];
    const checkedObjects = new Set();

    console.log('Resolving dependencies recursively...');
    while (allObjectsToCheck.length > 0) {
      const obj = allObjectsToCheck.pop();
      if (checkedObjects.has(obj)) continue;
      checkedObjects.add(obj);

      try {
        const res = await pool.request()
          .input('objName', sql.NVarChar(200), obj)
          .query(`
            SELECT DISTINCT 
              d.referenced_entity_name,
              o.type_desc AS referenced_type
            FROM sys.dm_sql_referenced_entities('dbo.' + @objName, 'OBJECT') d
            LEFT JOIN sys.objects o ON o.object_id = d.referenced_id
            WHERE d.referenced_class_desc = 'OBJECT_OR_COLUMN'
              AND d.referenced_entity_name IS NOT NULL
          `);

        for (const row of res.recordset) {
          const refName = row.referenced_entity_name;
          const refType = row.referenced_type ? row.referenced_type.trim() : null;

          if (!refType) {
            // Let's query sys.objects to find the type if not returned by JOIN
            const typeRes = await pool.request()
              .input('refName', sql.NVarChar(200), refName)
              .query(`SELECT type_desc FROM sys.objects WHERE name = @refName`);
            if (typeRes.recordset.length > 0) {
              const type = typeRes.recordset[0].type_desc.trim();
              processDependency(refName, type);
            }
          } else {
            processDependency(refName, refType);
          }
        }
      } catch (e) {
        // Some dependencies might fail if the entity is not fully bound or exists in a different database
      }
    }

    function processDependency(name, type) {
      if (type === 'USER_TABLE') {
        if (!tablesToExtract.has(name)) {
          tablesToExtract.add(name);
        }
      } else if (type === 'VIEW') {
        if (!viewsToExtract.has(name)) {
          viewsToExtract.add(name);
          allObjectsToCheck.push(name);
        }
      } else if (type === 'SQL_STORED_PROCEDURE') {
        if (!proceduresToExtract.has(name)) {
          proceduresToExtract.add(name);
          allObjectsToCheck.push(name);
        }
      } else if (type === 'SQL_SCALAR_FUNCTION' || type === 'SQL_TABLE_VALUED_FUNCTION' || type === 'SQL_INLINE_TABLE_VALUED_FUNCTION') {
        if (!functionsToExtract.has(name)) {
          functionsToExtract.add(name);
          allObjectsToCheck.push(name);
        }
      }
    }

    console.log(`Resolved:`);
    console.log(`- Tables count: ${tablesToExtract.size}`);
    console.log(`- Views count: ${viewsToExtract.size}`);
    console.log(`- Procedures count: ${proceduresToExtract.size}`);
    console.log(`- Functions count: ${functionsToExtract.size}`);

    let output = '';

    // Header
    output += `-- =========================================================================\n`;
    output += `-- DATABASE CREATION SCRIPT FOR TareasGForma\n`;
    output += `-- Generated recursively from w2019-sql / GestionFormacion\n`;
    output += `-- Date: ${new Date().toISOString()}\n`;
    output += `-- =========================================================================\n\n`;
    output += `CREATE DATABASE TareasGForma;\nGO\nUSE TareasGForma;\nGO\n\n`;

    // 1. Extract Tables
    console.log('Extracting tables...');
    for (const table of Array.from(tablesToExtract).sort()) {
      try {
        const colsResult = await pool.request()
          .input('tableName', sql.NVarChar(200), table)
          .query(`
            SELECT 
              c.COLUMN_NAME,
              c.DATA_TYPE,
              c.CHARACTER_MAXIMUM_LENGTH,
              c.NUMERIC_PRECISION,
              c.NUMERIC_SCALE,
              c.IS_NULLABLE,
              c.COLUMN_DEFAULT,
              COLUMNPROPERTY(OBJECT_ID(c.TABLE_SCHEMA + '.' + c.TABLE_NAME), c.COLUMN_NAME, 'IsIdentity') AS IsIdentity
            FROM INFORMATION_SCHEMA.COLUMNS c
            WHERE c.TABLE_NAME = @tableName
            ORDER BY c.ORDINAL_POSITION
          `);

        if (colsResult.recordset.length === 0) continue;

        const pkResult = await pool.request()
          .input('tableName', sql.NVarChar(200), table)
          .query(`
            SELECT ku.COLUMN_NAME
            FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
            JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE ku 
              ON tc.CONSTRAINT_NAME = ku.CONSTRAINT_NAME
            WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY' AND tc.TABLE_NAME = @tableName
          `);
        const pks = pkResult.recordset.map(r => r.COLUMN_NAME);

        let tableSQL = `CREATE TABLE dbo.${table} (\n`;
        const colDefinitions = [];
        
        for (const col of colsResult.recordset) {
          let line = `  [${col.COLUMN_NAME}] ${col.DATA_TYPE.toUpperCase()}`;
          if (col.DATA_TYPE === 'varchar' || col.DATA_TYPE === 'nvarchar' || col.DATA_TYPE === 'char' || col.DATA_TYPE === 'nchar') {
            if (col.CHARACTER_MAXIMUM_LENGTH === -1) {
              line += '(MAX)';
            } else {
              line += `(${col.CHARACTER_MAXIMUM_LENGTH})`;
            }
          } else if (col.DATA_TYPE === 'decimal' || col.DATA_TYPE === 'numeric') {
            line += `(${col.NUMERIC_PRECISION}, ${col.NUMERIC_SCALE})`;
          }
          
          if (col.IsIdentity === 1) {
            line += ' IDENTITY(1,1)';
          }
          
          if (col.IS_NULLABLE === 'NO') {
            line += ' NOT NULL';
          } else {
            line += ' NULL';
          }
          
          if (col.COLUMN_DEFAULT) {
            line += ` DEFAULT ${col.COLUMN_DEFAULT}`;
          }
          
          colDefinitions.push(line);
        }
        
        if (pks.length > 0) {
          colDefinitions.push(`  PRIMARY KEY (${pks.map(pk => `[${pk}]`).join(', ')})`);
        }
        
        tableSQL += colDefinitions.join(',\n') + '\n);\nGO\n\n';
        output += `-- Table structure for dbo.${table}\n` + tableSQL;
      } catch (e) {
        console.error(`Error extracting table ${table}:`, e.message);
      }
    }

    // 2. Extract Functions
    console.log('Extracting functions...');
    for (const fn of Array.from(functionsToExtract).sort()) {
      try {
        const fnResult = await pool.request()
          .input('objectName', sql.NVarChar(200), fn)
          .query(`
            SELECT definition 
            FROM sys.sql_modules 
            WHERE object_id = OBJECT_ID(@objectName)
          `);

        if (fnResult.recordset.length > 0) {
          output += `-- Function structure for dbo.${fn}\n${fnResult.recordset[0].definition}\nGO\n\n`;
        }
      } catch (e) {
        console.error(`Error extracting function ${fn}:`, e.message);
      }
    }

    // 3. Extract Views
    console.log('Extracting views...');
    for (const view of Array.from(viewsToExtract).sort()) {
      try {
        const viewResult = await pool.request()
          .input('objectName', sql.NVarChar(200), view)
          .query(`
            SELECT definition 
            FROM sys.sql_modules 
            WHERE object_id = OBJECT_ID(@objectName)
          `);

        if (viewResult.recordset.length > 0) {
          output += `-- View structure for dbo.${view}\n${viewResult.recordset[0].definition}\nGO\n\n`;
        }
      } catch (e) {
        console.error(`Error extracting view ${view}:`, e.message);
      }
    }

    // 4. Extract Procedures
    console.log('Extracting procedures...');
    for (const sp of Array.from(proceduresToExtract).sort()) {
      try {
        const spResult = await pool.request()
          .input('objectName', sql.NVarChar(200), sp)
          .query(`
            SELECT definition 
            FROM sys.sql_modules 
            WHERE object_id = OBJECT_ID(@objectName)
          `);

        if (spResult.recordset.length > 0) {
          output += `-- Stored Procedure structure for dbo.${sp}\n${spResult.recordset[0].definition}\nGO\n\n`;
        }
      } catch (e) {
        console.error(`Error extracting procedure ${sp}:`, e.message);
      }
    }

    // Write file
    const outputPath = path.join(__dirname, 'database_creation_script_complete.sql');
    fs.writeFileSync(outputPath, output, 'utf-8');
    console.log(`Successfully generated complete database creation script at: ${outputPath}`);

  } catch (err) {
    console.error('Extraction failed:', err);
  } finally {
    if (pool) await pool.close();
  }
}

run();
