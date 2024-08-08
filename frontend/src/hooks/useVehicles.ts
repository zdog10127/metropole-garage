import { useState, useEffect } from 'react';
import VehicleService from '../services/VehicleService';
import { Vehicle } from '../types/Vehicle';

const useVehicles = (ownerId: string) => {
  const [vehicles, setVehicles] = useState<Vehicle[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const loadVehicles = async () => {
      try {
        const data = await VehicleService.fetchVehicles(ownerId);
        setVehicles(data);
      } catch (err) {
        setError(err);
      } finally {
        setLoading(false);
      }
    };

    loadVehicles();
  }, [ownerId]);

  return { vehicles, loading, error };
};

export default useVehicles;
