import React, { useEffect, useState } from 'react';
import useVehicles from './hooks/useVehicles';
import VehicleService from './services/VehicleService';
import UserPanel from './components//Users/UserPanel';
import VehicleList from './components/Vehicles/VehicleList';
import Title from './components/Title';
import "./App.css"
import { Vehicle } from './types/Vehicle';

const App: React.FC = () => {
  const [ownerId, setOwnerId] = useState("admin");
  const [vehicles, setVehicles] = useState<Vehicle[]>([]);
  const { vehicles: fetchedVehicles, loading, error } = useVehicles(ownerId);
  const [filter, setFilter] = useState("");

  useEffect(() => {
    setVehicles(fetchedVehicles);
  }, [fetchedVehicles]);

  const filterVehicles = (plate: string) => {
    if (filter !== "") {
      return vehicles.filter((vehicle) => vehicle.plate.includes(plate));
    } else {
      return vehicles;
    }
  };

  const handleSpawn = async (vehicle: Vehicle) => {
    try {
      await VehicleService.spawnVehicle(vehicle);
      alert('Vehicle spawned successfully!');
      // Atualiza a lista de veículos após o spawn
      setVehicles(prevVehicles =>
        prevVehicles.map(v =>
          v.id === vehicle.id ? { ...v, spawned: true } : v
        )
      );
    } catch (err) {
      console.error('Failed to spawn vehicle:', err);
      alert('Failed to spawn vehicle.');
    }
  };

  const handleDespawn = async (vehicle: Vehicle) => {
    try {
      await VehicleService.despawnVehicle(vehicle);
      alert('Vehicle despawned successfully!');
      // Atualiza a lista de veículos após o despawn
      setVehicles(prevVehicles =>
        prevVehicles.map(v =>
          v.id === vehicle.id ? { ...v, spawned: false } : v
        )
      );
    } catch (err) {
      console.error('Failed to despawn vehicle:', err);
      alert('Failed to despawn vehicle.');
    }
  };

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error loading vehicles: {error.message}</p>;

  return (
    <div className="App">
      <Title />
      <UserPanel setUser={setOwnerId} setPlate={setFilter} />
      <VehicleList vehicles={filterVehicles(filter)} onSpawn={handleSpawn} onDespawn={handleDespawn} />
    </div>
  );
};

export default App;
