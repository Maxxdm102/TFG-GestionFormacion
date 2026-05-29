const sql = require('mssql');

const config = {
  server: 'w2019-sql',
  port: 1433,
  database: 'GestionFormacion',
  user: 'us_AccesoTotal',
  password: 'us_Ilimitado',
  options: { encrypt: false, trustServerCertificate: true, enableArithAbort: true },
};

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
  'up_bp_TareasTiempos_Insert',
  'vw_bp_Presupuestos'
];

async function run() {
  let pool;
  try {
    pool = await sql.connect(config);
    const referencedTables = new Set();

    for (const obj of procedures) {
      try {
        const res = await pool.request()
          .input('objName', sql.NVarChar(200), obj)
          .query(`
            SELECT DISTINCT referenced_entity_name 
            FROM sys.dm_sql_referenced_entities('dbo.' + @objName, 'OBJECT')
          `);
        
        for (const row of res.recordset) {
          referencedTables.add(row.referenced_entity_name);
        }
      } catch (innerErr) {
        console.warn(`Could not get dependencies for ${obj}:`, innerErr.message);
      }
    }

    console.log('Referenced tables/views/functions in the procedures and views:');
    console.log(JSON.stringify(Array.from(referencedTables).sort(), null, 2));

  } catch (e) {
    console.error(e);
  } finally {
    if (pool) await pool.close();
  }
}

run();
