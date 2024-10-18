import pg from 'pg';
import config from '../../config.json';

const { host_pg, user_pg, password_pg, database_pg, port_pg } = config.db;

export async function ExecuteSP(procedureName: string, params: any[]): Promise<void> {
  
    const client = new pg.Client({user: user_pg, host: host_pg, database: database_pg, password: password_pg, port: port_pg});

  try {
    await client.connect();

    const paramPlaceholders = params.map((_, index) => `$${index + 1}`).join(', ');
    const query = `CALL ${procedureName}(${paramPlaceholders})`;

    await client.query(query, params);

  } catch (err) {

    console.error('Error al ejecutar el procedimiento', err);

  } finally {

    await client.end();

  }
}

export async function ExecuteSPR(procedureName: string, params: any[]): Promise<any> {
  const client = new pg.Client({ user: user_pg, host: host_pg, database: database_pg, password: password_pg, port: port_pg });

  try {
    await client.connect();

    const paramPlaceholders = params.map((_, index) => `$${index + 1}`).join(', ');
    const query = `CALL ${procedureName}(${paramPlaceholders})`;
    const res = await client.query(query, params);

    return res.rows;

  } catch (err) {

    console.error('Error al ejecutar el procedimiento', err);
    return null;
    
  } finally {

    await client.end();

  }
}


export default {ExecuteSP , ExecuteSPR};