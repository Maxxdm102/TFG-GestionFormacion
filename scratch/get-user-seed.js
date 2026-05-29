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
    
    // Query identities
    const winUser = 'mdbarca';
    
    const identityRes = await pool.request()
      .input('winUser', sql.VarChar(200), winUser)
      .query(`
        SELECT * 
        FROM SeguridadUnificada_Identidad 
        WHERE Usuario = @winUser
      `);

    if (identityRes.recordset.length > 0) {
      const identity = identityRes.recordset[0];
      console.log('--- IDENTITY RECORD ---');
      console.log(JSON.stringify(identity, null, 2));

      // Query Personal matching IdUsuario if type is 1
      if (identity.IdTipoUsuario === 1) {
        const personalRes = await pool.request()
          .input('idPersonal', sql.Int, identity.IdUsuario)
          .query(`SELECT * FROM gf_Personal WHERE IdPersonal = @idPersonal`);
        
        if (personalRes.recordset.length > 0) {
          console.log('--- PERSONAL RECORD ---');
          console.log(JSON.stringify(personalRes.recordset[0], null, 2));
        }
      }
    } else {
      console.log(`User ${winUser} not found in SeguridadUnificada_Identidad.`);
    }

  } catch (e) {
    console.error(e);
  } finally {
    if (pool) await pool.close();
  }
}

run();
