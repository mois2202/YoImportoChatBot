import pg from 'pg';
import { dbConnection } from '../shared/db/dbConnection';


export async function ExecuteSQLProcedure(procedureName: string, params: any[]): Promise<void> { 
  try{
    const useClient = await dbConnection();
    const paramPlaceholders = params.map((_, index) => `$${index + 1}`).join(', ');
    const query = `CALL ${procedureName}(${paramPlaceholders})`;
    await useClient.query(query, params);
    await useClient.end();
  }
   catch (err) {
    console.error('Error al ejecutar el procedimiento', err);
  }
}

export async function ExecuteSQLFunction(functionName: string, params: any[]): Promise<any> {

  try {
    const useClient = await dbConnection();
    const paramPlaceholders = params.map((_, index) => `$${index + 1}`).join(', ');
    const query = `SELECT * FROM ${functionName}(${paramPlaceholders})`;
    const res = await useClient.query(query, params);
    useClient.end();
    return res.rows;
  } catch (err) {
    console.error('Error al ejecutar la función', err);
  } 
}


