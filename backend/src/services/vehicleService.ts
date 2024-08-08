import { vehicleRepository } from "../repositories/vehicleRepository";
import { Vehicle } from "../entities/Vehicle";
import { UpdateResult } from "typeorm";

export const getVehiclesByOwner = async (owner: string): Promise<Vehicle[]> => {
  if (owner == "admin") {
    return await vehicleRepository.find();
  } else {
    return await vehicleRepository.find({ where: { owner } });
  }
};

export const spawnVehicleById = async (
  vehicleId: number
): Promise<Vehicle | null> => {
  const vehicle = await vehicleRepository.findOneBy({ id: vehicleId });
  if (vehicle) {
    // Lógica para "spawnar" o veículo (atualizar o status, etc.)
    // Por exemplo: vehicle.status = 'spawned';
    await vehicleRepository.save(vehicle);
  }
  return vehicle;
};

export const getVehiclesById = async (id: number): Promise<Vehicle[]> => {
  return await vehicleRepository.find({ where: { id } });
};

export const getVehicleById = async (id: number): Promise<Vehicle | null> => {
  return await vehicleRepository.findOne({ where: { id } });
};

export const updateVehicle = async (
  id: number,
  data: Partial<Vehicle>
): Promise<UpdateResult> => {
  return await vehicleRepository.update(id, data);
};
