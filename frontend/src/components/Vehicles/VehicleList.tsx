import { Vehicle } from '../../types/Vehicle';
import VehicleCard from './VehicleCard';
import './Vehicle.css'

interface VehicleListProps {
    vehicles: Vehicle[];
    onSpawn: (vehicle: Vehicle) => void;
    onDespawn: (vehicle: Vehicle) => void;
}

const VehicleList: React.FC<VehicleListProps> = ({ vehicles, onSpawn, onDespawn }) => {
    return (
        <div className="vehicle-list">
            {vehicles.map((vehicle) => <VehicleCard key={vehicle.plate} vehicle={vehicle} onSpawn={onSpawn} onDespawn={onDespawn} />)}
        </div>
    );
};

export default VehicleList;
