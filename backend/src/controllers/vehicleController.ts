import { Request, Response } from "express";
import { getVehiclesByOwner, updateVehicle } from "../services/vehicleService";
import {
  addVehicleInServer,
  removeVehicleInServer,
} from "../services/vehicleInServer";
import { vehicleInServerRepository } from "../repositories/vehicleInServerRepository";

export const getVehicles = async (
  req: Request,
  res: Response
): Promise<void> => {
  const owner = req.query.owner as string;
  try {
    const vehicles = await getVehiclesByOwner(owner);
    res.status(200).json(vehicles);
  } catch (error) {
    res.status(500).json({ message: "Error fetching vehicles", error });
  }
};

export const spawnVehicle = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { id } = req.body;

  const spawnedVehicle = await updateVehicle(id, { spawned: true });
  await addVehicleInServer(id);
  await logger();
  res
    .status(200)
    .json({ message: "Vehicle spawned successfully", spawnedVehicle });
};

export const despawnVehicle = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { id } = req.body;
  const despawnedVehicle = await updateVehicle(id, { spawned: false });
  await removeVehicleInServer(id);
  await logger();
  res
    .status(200)
    .json({ message: "Vehicle despawned successfully", despawnedVehicle });
};

const logger = async () => {
  const vehiclesInServer = await vehicleInServerRepository.find({
    relations: ["vehicle_owner_id", "vehicle_plate"],
  });
  console.log(`Novo Registro: ${new Date()}`);
  console.log(`Carros no servidor: ${vehiclesInServer.length}`);
  console.log(`Modelo -- Placa -- Id_Carro`);
  for (const vehicle of vehiclesInServer) {
    console.log(
      `${vehicle.vehicle_plate.model} -- ${vehicle.vehicle_plate.plate} -- ${vehicle.vehicle_owner_id.id}`
    );
  }
  console.log(`#################################################`);
};
