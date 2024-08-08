import { Entity, PrimaryGeneratedColumn, Column } from "typeorm";

@Entity()
export class Vehicle {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  model!: string;

  @Column()
  color!: string;

  @Column({ unique: true })
  plate!: string;

  @Column("text")
  customizations!: string;

  @Column()
  owner!: string;

  @Column({ default: false })
  spawned!: boolean;
}
