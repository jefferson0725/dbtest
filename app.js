// app.js
import express from "express";
import mysql from "mysql2/promise";

const app = express();

// Conexión al pool MySQL
const pool = mysql.createPool({
  host: "127.0.0.1",
  user: "whatsapphub",      // <-- cambia esto
  password: "Admin123!", // <-- cambia esto
  database: "empleados",
  port: 3306,
});


// Endpoint para obtener empleados
app.get("/api/empleados", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM empleados");
    res.json(rows);
  } catch (err) {
    console.error("❌ Error:", err.message);
    res.status(500).json({ error: "Error al consultar empleados" });
  }
});

// Servidor
app.listen(4000, () => {
  console.log("✅ API corriendo en http://localhost:4000");
});
