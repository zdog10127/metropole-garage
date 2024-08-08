import axios from 'axios';
import { Vehicle } from '../types/Vehicle';

const api = axios.create({
    baseURL: 'http://localhost:3000/api', // URL do backend
});

export const getVehicles = async (ownerId: string): Promise<Vehicle[]> => {
    const response = await api.get(`/vehicles?owner=${ownerId}`);
    // const response = await api.get(`/vehicles?owner=player1_steam_id`);
    return response.data;
};

export const spawnVehicle = async (vehicleId: number): Promise<void> => {
    await api.post(`/vehicles/spawn`, { vehicleId });
};
