import { Pool } from 'pg';
import * as config from '../config.json';

class ConnectionPostgre {
    private static pool: Pool;

    private constructor() { }

    public static getPool(): Pool {
        if (!ConnectionPostgre.pool) {
            ConnectionPostgre.pool = new Pool({
                user: config.db.user,
                host: config.db.host,
                database: config.db.database,
                password: config.db.password,
                port: config.db.port,
            });
        }
        return ConnectionPostgre.pool;
    }
}

export default ConnectionPostgre;