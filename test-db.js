const sql = require('mssql');

async function testConnection() {
  try {
    const pool = await sql.connect({
      server: 'w2019-sql',
      port: 1433,
      database: 'TareasGForma',
      user: 'us_AccesoTotal',
      password: 'us_Ilimitado',
      options: { encrypt: false, trustServerCertificate: true, enableArithAbort: true },
    });
    console.log('Successfully connected to the database.');
    
    // Quick query
    const result = await pool.request().query('SELECT @@SERVERNAME AS servidor, DB_NAME() AS baseDatos');
    console.log('Result:', result.recordset);
    
    await pool.close();
  } catch (err) {
    console.error('Connection failed:', err);
  }
}

testConnection();
