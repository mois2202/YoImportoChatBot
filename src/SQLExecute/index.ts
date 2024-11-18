import { dbConfig } from '~/shared/db/dbConfig';
import pg from 'pg';

const { host_pg, user_pg, password_pg, database_pg, port_pg } = dbConfig.db;

export async function ExecuteSQLFunction(functionName: string, params: any[]): Promise<any> {
  const client = new pg.Client({ user: user_pg, host: host_pg, database: database_pg, password: password_pg, port: port_pg });

  try {
    await client.connect();

    const paramPlaceholders = params.map((_, index) => `$${index + 1}`).join(', ');
    const query = `SELECT * FROM ${functionName}(${paramPlaceholders})`;
    const res = await client.query(query, params);

    return res.rows;

  } catch (err) {

    console.error('Error al ejecutar la función', err);
    return null;
    
  } finally {

    await client.end();

  }
}


export async function ExecuteSQLProcedure(procedureName: string, params: any[]): Promise<any> {
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

export default {ExecuteSQLProcedure , ExecuteSQLFunction};