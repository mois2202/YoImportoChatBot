import dotenv from 'dotenv';

dotenv.config();

export const dbConfig = {
    "db": {
      "host_pg": process.env.DB_HOST || "postgres",
      "user_pg": process.env.DB_USERNAME || "postgres",
      "password_pg": process.env.DB_PASSWORD || "1234",
      "database_pg": process.env.DB_NAME || "ChatBotDemo-DB",
      "port_pg": process.env.DB_PORT || "5434"
    }
  }