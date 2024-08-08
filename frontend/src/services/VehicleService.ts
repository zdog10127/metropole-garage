import axios from "axios";
import { Vehicle } from "../types/Vehicle";

const api = axios.create({
  baseURL: "http://localhost:3000/api", // URL do backend
});

class VehicleService {
  private vehicles: Vehicle[] = [];

  async fetchVehicles(ownerId: string): Promise<Vehicle[]> {
    const response = await api.get(`/vehicles?owner=${ownerId}`);
    return response.data;
  }

  async spawnVehicle(vehicle: Vehicle): Promise<Vehicle> {
    const response = await api.post(`/vehicles/spawn`, {
      id: vehicle.id,
      plate: vehicle.plate,
    });
    return response.data;
  }

  async despawnVehicle(vehicle: Vehicle): Promise<Vehicle> {
    const response = await api.post(`/vehicles/despawn`, {
      id: vehicle.id,
      plate: vehicle.plate,
    });
    return response.data;
  }
}

export default new VehicleService();
