import { Router } from "express";
import {
  despawnVehicle,
  getVehicles,
  spawnVehicle,
} from "../controllers/vehicleController";

const router = Router();

router.get("/vehicles", getVehicles);
router.post("/vehicles/spawn", spawnVehicle);
router.post("/vehicles/despawn", despawnVehicle);

export default router;
