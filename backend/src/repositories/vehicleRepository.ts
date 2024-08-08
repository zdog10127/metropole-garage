import { AppDataSource } from "../ormconfig";
import { Vehicle } from "../entities/Vehicle";

export const vehicleRepository = AppDataSource.getRepository(Vehicle);
