import { Vehicle } from '../../types/Vehicle';
import './Vehicle.css'

interface VehicleCardProps {
    vehicle: Vehicle;
    onSpawn: (vehicle: Vehicle) => void;
    onDespawn: (vehicle: Vehicle) => void;
}

const toUpperCaseFirstLetter = (word: string) => {
    return word[0].toUpperCase() + word.substring(1)
}

const VehicleCard: React.FC<VehicleCardProps> = ({ vehicle, onSpawn, onDespawn }) => {

    const renderCustomizations = () => {
        const customizations: { [key: string]: string } = JSON.parse(vehicle.customizations);
        return (
            <>
                {Object.entries(customizations).map(([key, value]) => (
                    <p>{toUpperCaseFirstLetter(key)}: {toUpperCaseFirstLetter(value)}</p>
                ))}
            </>

        )
    };

    const dataButton = {
        className: vehicle.spawned ? "isSpawned" : "isNotSpawned",
        onClick: vehicle.spawned ? () => onDespawn(vehicle) : () => onSpawn(vehicle),
        text: vehicle.spawned ? "Despawn" : "Spawn"
    }

    return (
        <div className="vehicle-card">
            <h2>{vehicle.model}</h2>
            <p>Cor: {vehicle.color}</p>
            <p>Placa: {vehicle.plate}</p>
            {renderCustomizations()}
            <button className={dataButton.className} onClick={dataButton.onClick}>{dataButton.text}</button>
        </div>
    );
};

export default VehicleCard;
