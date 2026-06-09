const sql = require('mssql');

const config = {
    user: 'AccesoTotal',
    password: 'us_Ilimitado',
    server: 'w2019-sql', 
    options: {
        encrypt: false, // para conexiones locales/internas a menudo es false
        trustServerCertificate: true 
    }
};

async function testConnection() {
    try {
        console.log('Intentando conectar al servidor SQL Server: w2019-sql...');
        let pool = await sql.connect(config);
        console.log('¡Conexión establecida con éxito!');
        
        let result = await pool.request().query('SELECT @@VERSION as version');
        console.log('\nInformación del servidor:');
        console.log(result.recordset[0].version);
        
        let dbs = await pool.request().query('SELECT name FROM master.sys.databases WHERE database_id > 4');
        console.log('\nBases de datos disponibles:');
        dbs.recordset.forEach(db => console.log(' - ' + db.name));

        await sql.close();
    } catch (err) {
        console.error('\nError al conectar a la base de datos:', err.message);
    }
}

testConnection();
