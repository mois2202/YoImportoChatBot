import ConnectionPostgre from '../DB/ConnectionPostgre';

function comprobarConexionDB(): boolean {
    const pool = ConnectionPostgre.getPool();
    const client = pool.connect();
    let conexionExitosa = true;
    try {
        client.query('SELECT 1');
        console.log('Conexión a la base de datos exitosa');
    } catch (error) {
        console.error('Error al conectar a la base de datos:', error);
        conexionExitosa = false;
    } finally {
        client.release();
    }
    return conexionExitosa;
}

export default comprobarConexionDB;