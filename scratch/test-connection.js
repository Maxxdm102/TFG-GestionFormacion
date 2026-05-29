const sql = require('mssql');

async function testConnection(user, password, db) {
  try {
    console.log(`Trying to connect as ${user} to ${db}...`);
    const pool = await sql.connect({
      server: 'w2019-sql',
      port: 1433,
      database: db,
      user: user,
      password: password,
      options: { encrypt: false, trustServerCertificate: true, enableArithAbort: true },
    });
    console.log(`Successfully connected as ${user} to ${db}.`);
    
    // Check if we can query tables
    const tables = await pool.request().query(`
      SELECT TABLE_NAME 
      FROM INFORMATION_SCHEMA.TABLES 
      WHERE TABLE_TYPE = 'BASE TABLE'
      ORDER BY TABLE_NAME
    `);
    console.log('Tables:', tables.recordset.map(t => t.TABLE_NAME));
    
    await pool.close();
    return true;
  } catch (err) {
    console.error(`Connection failed for ${user}:`, err.message);
    return false;
  }
}

async function run() {
  // Let's test combinations
  await testConnection('us_AccesoTotal', 'us_Ilimitado', 'GestionFormacion');
  await testConnection('us_limitado_tareasYpresencia', 'uslimitado', 'GestionFormacion');
  await testConnection('us_AccesoTotal', 'us_Ilimitado', 'TareasGForma');
}

run();
