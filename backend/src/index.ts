import "reflect-metadata";
import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import { AppDataSource } from "./ormconfig";
import vehicleRoutes from "./routes/vehicleRoutes";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

const corsOptions = {
  origin: "http://localhost:5173", // Substitua com o endereço do seu frontend
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));

app.use(express.json());
app.use("/api", vehicleRoutes);

AppDataSource.initialize()
  .then(() => {
    console.log("Data Source has been initialized!");
    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Error during Data Source initialization", err);
  });
