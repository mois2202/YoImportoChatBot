import ConnectionPostgre from '../DB/ConnectionPostgre';

async function fetchData() {
    const pool = ConnectionPostgre.getPool();
    const client = await pool.connect();
    try {
        const res = await client.query('SELECT * FROM my_table');
        console.log(res.rows);
    } finally {
        client.release(); 
    }
}
