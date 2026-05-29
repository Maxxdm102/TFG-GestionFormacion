const sql = require('mssql');

const config = {
  server: 'w2019-sql',
  port: 1433,
  database: 'GestionFormacion',
  user: 'us_AccesoTotal',
  password: 'us_Ilimitado',
  options: { encrypt: false, trustServerCertificate: true, enableArithAbort: true },
};

async function run() {
  let pool;
  try {
    pool = await sql.connect(config);
    const tables = [
      'SeguridadUnificada_TipoUsuario',
      'SeguridadUnificada_Configuracion',
      'ControlPresencia_TiposEvento',
      'Paises',
      'Provincias',
      'TiposCerrados',
      'UnidadesMedida'
    ];
    
    for (const t of tables) {
      const res = await pool.request().query(`SELECT COUNT(*) AS c FROM dbo.${t}`);
      console.log(`${t}: ${res.recordset[0].c} rows`);
    }
  } catch (e) {
    console.error(e);
  } finally {
    if (pool) await pool.close();
  }
}

run();
