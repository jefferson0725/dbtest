// app.js
import express from "express";
import mysql from "mysql2/promise";
import dotenv from "dotenv";

// Cargar variables de entorno desde .env (en producción las variables deben
// venir del entorno del sistema o del servicio de despliegue)
dotenv.config();

const app = express();



// Variables requeridas en producción
const required = ['DB_HOST', 'DB_USER', 'DB_NAME'];
const missing = required.filter((k) => !process.env[k]);
if (process.env.NODE_ENV === 'production' && missing.length) {
  console.error('Missing required env vars:', missing.join(', '));
  process.exit(1);
}

// Pool de conexiones con opciones razonables para producción
const pool = mysql.createPool({
  host: process.env.DB_HOST ?? 'localhost',
  user: process.env.DB_USER ?? 'root',
  password: process.env.DB_PASSWORD ?? '',
  database: process.env.DB_NAME ?? 'empleados',
  port: Number(process.env.DB_PORT ?? 3306),
  waitForConnections: true,
  connectionLimit: Number(process.env.DB_CONNECTION_LIMIT || 10),
  queueLimit: 0,
  connectTimeout: Number(process.env.DB_CONNECT_TIMEOUT_MS || 10000),
});

// Comprueba la conexión a la base de datos al iniciar para fall-fast si hay problemas
// (útil para que el proceso salga y el orquestador lo reinicie)
async function verifyDatabaseConnection() {
  try {
    await pool.query('SELECT 1');
    if (process.env.NODE_ENV !== 'production') {
      console.log('✅ Conexión a la base de datos verificada');
    }
  } catch (err) {
    console.error('❌ Error inicial conectando a la base de datos:', err.message);
    // En producción preferimos salir y dejar que el supervisor reinicie el proceso
    if (process.env.NODE_ENV === 'production') process.exit(1);
  }
}

verifyDatabaseConnection();


// Endpoint público para listar empleados
app.get("/api/empleados", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM empleados");
    res.json(rows);
  } catch (err) {
    console.error("❌ Error:", err.message);
    res.status(500).json({ error: "Error al consultar empleados" });
  }
});

// Health check para orquestadores y balanceadores
app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok' });
  } catch (err) {
    console.error('Healthcheck DB error:', err.message);
    res.status(503).json({ status: 'unhealthy' });
  }
});

const effectivePort = Number(process.env.APP_PORT ?? 4000);
const server = app.listen(effectivePort, () => {
  console.log(`API corriendo en http://localhost:${effectivePort}`);
});

// Shutdown ordenado: cerrar pool y servidor al recibir señales
async function shutdown(signal) {
  console.log(`Received ${signal}, closing server...`);
  try {
    await pool.end();
    server.close(() => {
      console.log('Server closed');
      process.exit(0);
    });
  } catch (err) {
    console.error('Error during shutdown:', err.message);
    process.exit(1);
  }
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));
