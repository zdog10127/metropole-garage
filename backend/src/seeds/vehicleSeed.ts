import { AppDataSource } from "../ormconfig";
import { Vehicle } from "../entities/Vehicle";
import { VehicleInServer } from "../entities/VehicleInServer";

const seedVehicles = async () => {
  const vehicleRepository = AppDataSource.getRepository(Vehicle);
  const vehicleInServerRepository =
    AppDataSource.getRepository(VehicleInServer);

  // Remover temporariamente a restrição de chave estrangeira
  await AppDataSource.query("SET FOREIGN_KEY_CHECKS = 0");

  // Primeiro, limpe a tabela VehicleInServer
  await vehicleInServerRepository.clear();

  // Em seguida, limpe a tabela Vehicle
  await vehicleRepository.clear();

  // Reinserir a restrição de chave estrangeira
  await AppDataSource.query("SET FOREIGN_KEY_CHECKS = 1");

  const vehicles = [
    {
      model: "Adder",
      color: "Vermelho",
      plate: "ABC123",
      customizations: '{"aerofólio": "alto", "neon": "azul"}',
      owner: "player1_steam_id",
    },
    {
      model: "Cheetah",
      color: "Azul",
      plate: "DEF456",
      customizations: '{"aerofólio": "baixo", "neon": "vermelho"}',
      owner: "player1_steam_id",
    },
    {
      model: "EntityXF",
      color: "Verde",
      plate: "GHI789",
      customizations: '{"aerofólio": "médio", "neon": "verde"}',
      owner: "player1_steam_id",
    },
    {
      model: "Zentorno",
      color: "Amarelo",
      plate: "JKL012",
      customizations: '{"aerofólio": "alto", "neon": "amarelo"}',
      owner: "player2_steam_id",
    },
    {
      model: "T20",
      color: "Preto",
      plate: "MNO345",
      customizations: '{"aerofólio": "baixo", "neon": "roxo"}',
      owner: "player2_steam_id",
    },
  ];

  for (const vehicle of vehicles) {
    const vehicleEntity = vehicleRepository.create(vehicle);
    await vehicleRepository.save(vehicleEntity);
  }

  console.log("Seed vehicles complete!");
};

const seedVehiclesInServer = async () => {
  const vehicleRepository = AppDataSource.getRepository(Vehicle);
  const vehicleInServerRepository =
    AppDataSource.getRepository(VehicleInServer);

  // Encontre um veículo existente
  const vehicle = await vehicleRepository.findOne({
    where: {
      plate: "ABC123",
    },
  });

  if (!vehicle) {
    console.log("No vehicle found to seed.");
    return;
  }

  // Crie a entidade VehicleInServer
  const vehicleInServerEntity = vehicleInServerRepository.create({
    vehicle_owner_id: vehicle,
    vehicle_plate: vehicle,
  });

  // Salve a entidade VehicleInServer
  await vehicleInServerRepository.save(vehicleInServerEntity);

  await vehicleRepository.update(vehicle, { spawned: true });

  console.log("Seeded vehicle in server:", vehicleInServerEntity);
};

const main = async () => {
  try {
    await AppDataSource.initialize();
    await seedVehicles();
    await seedVehiclesInServer();
    console.log("Seeding complete!");
  } catch (error) {
    console.error("Seeding error:", error);
  } finally {
    await AppDataSource.destroy();
  }
};

main();
