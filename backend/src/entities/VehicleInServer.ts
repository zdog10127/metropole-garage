import { Entity, PrimaryGeneratedColumn, OneToOne, JoinColumn } from "typeorm";
import { Vehicle } from "./Vehicle";

@Entity()
export class VehicleInServer {
  @PrimaryGeneratedColumn()
  id!: number;

  @OneToOne(() => Vehicle)
  @JoinColumn({ name: "vehicle_owner_id", referencedColumnName: "id" })
  vehicle_owner_id!: Vehicle;

  @OneToOne(() => Vehicle)
  @JoinColumn({ name: "vehicle_plate", referencedColumnName: "plate" })
  vehicle_plate!: Vehicle;
}
