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

const tables = [
  'gf_Clientes',
  'tiposCerrados',
  'Paises',
  'Provincias',
  'Contactos',
  'Presupuestos',
  'Presupuestos_Lineas',
  'LineasPresupuesto',
  'UnidadesMedida',
  'gf_Proveedores',
  'Tareas',
  'TareasTiempos'
];

const views = [
  'vw_bp_Presupuestos'
];

const procedures = [
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
    console.log('Connected to SQL Server');

    let output = '';

    // 1. Database Creation Header
    output += `-- =========================================================================\n`;
    output += `-- DATABASE CREATION SCRIPT FOR TareasGForma\n`;
    output += `-- Generated automatically from w2019-sql / GestionFormacion\n`;
    output += `-- =========================================================================\n\n`;
    output += `CREATE DATABASE TareasGForma;\nGO\nUSE TareasGForma;\nGO\n\n`;

    // 2. Tables Schema Extraction
    console.log('Extracting tables...');
    for (const table of tables) {
      try {
        console.log(`- Table: ${table}`);
        
        // Let's get table definition
        // We can query the columns
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

        if (colsResult.recordset.length === 0) {
          console.log(`  Table ${table} not found in database.`);
          output += `-- Table ${table} was not found in the source database.\n\n`;
          continue;
        }

        // Get primary keys
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
        output += `-- Error extracting table ${table}: ${e.message}\n\n`;
      }
    }

    // 3. Views Definition Extraction
    console.log('Extracting views...');
    for (const view of views) {
      try {
        console.log(`- View: ${view}`);
        const viewTextResult = await pool.request()
          .input('objectName', sql.NVarChar(200), view)
          .query(`
            SELECT definition 
            FROM sys.sql_modules 
            WHERE object_id = OBJECT_ID(@objectName)
          `);

        if (viewTextResult.recordset.length > 0) {
          let definition = viewTextResult.recordset[0].definition;
          // Ensure it ends with GO
          output += `-- View structure for dbo.${view}\n${definition}\nGO\n\n`;
        } else {
          console.log(`  View ${view} not found in database.`);
          output += `-- View ${view} was not found in the source database.\n\n`;
        }
      } catch (e) {
        console.error(`Error extracting view ${view}:`, e.message);
        output += `-- Error extracting view ${view}: ${e.message}\n\n`;
      }
    }

    // 4. Procedures Definition Extraction
    console.log('Extracting procedures...');
    for (const sp of procedures) {
      try {
        console.log(`- Stored Procedure: ${sp}`);
        const spTextResult = await pool.request()
          .input('objectName', sql.NVarChar(200), sp)
          .query(`
            SELECT definition 
            FROM sys.sql_modules 
            WHERE object_id = OBJECT_ID(@objectName)
          `);

        if (spTextResult.recordset.length > 0) {
          let definition = spTextResult.recordset[0].definition;
          output += `-- Stored Procedure structure for dbo.${sp}\n${definition}\nGO\n\n`;
        } else {
          console.log(`  Stored Procedure ${sp} not found in database.`);
          output += `-- Stored Procedure ${sp} was not found in the source database.\n\n`;
        }
      } catch (e) {
        console.error(`Error extracting SP ${sp}:`, e.message);
        output += `-- Error extracting SP ${sp}: ${e.message}\n\n`;
      }
    }

    // Write file
    const outputPath = path.join(__dirname, 'database_creation_script.sql');
    fs.writeFileSync(outputPath, output, 'utf-8');
    console.log(`Successfully generated database creation script at: ${outputPath}`);

  } catch (err) {
    console.error('Extraction failed:', err);
  } finally {
    if (pool) await pool.close();
  }
}

run();
