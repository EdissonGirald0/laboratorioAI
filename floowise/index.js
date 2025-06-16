require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const axios = require('axios');

const app = express();
const port = process.env.FLOOWISE_PORT || 3000;

// Configuración de la base de datos PostgreSQL
const pool = new Pool({
    connectionString: process.env.DATABASE_URL
});

// Configuración de Qdrant
const qdrantUrl = process.env.QDRANT_URL;

app.use(express.json());

// Ruta de prueba
app.get('/', (req, res) => {
    res.json({ message: 'Floowise API está funcionando' });
});

// Verificar conexión a PostgreSQL
app.get('/health/postgres', async (req, res) => {
    try {
        const result = await pool.query('SELECT NOW()');
        res.json({ status: 'ok', timestamp: result.rows[0].now });
    } catch (error) {
        res.status(500).json({ status: 'error', message: error.message });
    }
});

// Verificar conexión a Qdrant
app.get('/health/qdrant', async (req, res) => {
    try {
        const response = await axios.get(`${qdrantUrl}/health`);
        res.json({ status: 'ok', qdrant: response.data });
    } catch (error) {
        res.status(500).json({ status: 'error', message: error.message });
    }
});

app.listen(port, process.env.FLOOWISE_HOST, () => {
    console.log(`Floowise API escuchando en http://${process.env.FLOOWISE_HOST}:${port}`);
}); 