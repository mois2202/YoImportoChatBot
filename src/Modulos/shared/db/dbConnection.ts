import pg, { Client } from 'pg';
import {dbConfig} from './dbConfig';

const { host_pg, user_pg, password_pg, database_pg, port_pg } = dbConfig.db;
const client = new pg.Client({
  host: host_pg,
  user: user_pg,
  password: password_pg,
  database: database_pg,
  port: port_pg,
});

export async function dbConnection(): Promise<pg.Client> {
      await client.connect();
      return client;
  }