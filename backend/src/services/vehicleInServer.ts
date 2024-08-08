import { DeleteResult } from "typeorm";
import { VehicleInServer } from "../entities/VehicleInServer";
import { vehicleInServerRepository } from "../repositories/vehicleInServerRepository";
import { getVehiclesById } from "./vehicleService";

export const addVehicleInServer = async (
  id: number
): Promise<VehicleInServer> => {
  const vehicle = await getVehiclesById(id);
  const currentVehicle = vehicle[0];
  const data: Partial<VehicleInServer> = {
    vehicle_owner_id: currentVehicle,
    vehicle_plate: currentVehicle,
  };
  return await vehicleInServerRepository.save(data);
};

export const removeVehicleInServer = async (
  id: number
): Promise<DeleteResult> => {
  const vehicle = await getVehiclesById(id);
  const currentVehicle = vehicle[0];
  const register: VehicleInServer =
    await vehicleInServerRepository.findOneOrFail({
      where: {
        vehicle_owner_id: currentVehicle,
      },
    });
  return await vehicleInServerRepository.delete(register);
};
