import pg from 'pg';
import config from '../config.json';

const { host_pg, user_pg, password_pg, database_pg, port_pg } = config.db;

const client = new pg.Client({
  host: host_pg,
  user: user_pg,
  password: password_pg,
  database: database_pg,
  port: port_pg,
});

export function VerEstadoDB() : boolean {
    let estado = false;
    try {

        client.connect();
        client.query('SELECT 1');
        console.log('Conectado a PostgreSQL');
        estado = true

    } catch (err) {

        console.error('Error al conectar a PostgreSQL', err);
    }

    finally {

        client.end();
        
    }
    return estado;
}