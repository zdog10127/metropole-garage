import { DataSource } from "typeorm";
import { Vehicle } from "./entities/Vehicle";
import { VehicleInServer } from "./entities/VehicleInServer";

export const AppDataSource = new DataSource({
  type: "mysql",
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT) || 3306,
  username: process.env.DB_USER || "root",
  password: process.env.DB_PASS || "password",
  database: process.env.DB_NAME || "fivem",
  synchronize: true,
  logging: false,
  entities: [Vehicle, VehicleInServer],
  migrations: [],
  subscribers: [],
});
