import { dbConfig } from '~/shared/db/dbConfig';
import pg from 'pg';

const { host_pg, user_pg, password_pg, database_pg, port_pg } = dbConfig.db;

const client = new pg.Client({
  host: host_pg,
  user: user_pg,
  password: password_pg,
  database: database_pg,
  port: port_pg,
});

export async function VerEstadoDB(): Promise<boolean> {
    let estado = false;
  
    try {

      await client.connect();
      await client.query('SELECT 1');
      console.log('Conectado a PostgreSQL');
      estado = true;

    } catch (err) {

      console.error('Error al conectar a PostgreSQL', err);

    } finally {

      await client.end();
      
    }
  
    return estado;
  }