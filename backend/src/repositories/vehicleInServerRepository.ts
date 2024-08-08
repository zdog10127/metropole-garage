import { AppDataSource } from "../ormconfig";
import { VehicleInServer } from "../entities/VehicleInServer";

export const vehicleInServerRepository =
  AppDataSource.getRepository(VehicleInServer);
