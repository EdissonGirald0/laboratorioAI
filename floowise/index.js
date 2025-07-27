require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');
const axios = require('axios');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const morgan = require('morgan');

const app = express();
const port = process.env.FLOOWISE_PORT || 3000;

// Middleware de logging
app.use(morgan('combined'));

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutos
    max: 100 // límite de 100 peticiones por ventana
});
app.use(limiter);

// CORS
app.use(cors());

// JSON Parser con límite
app.use(express.json({ limit: '50mb' }));

// Configuración de la base de datos PostgreSQL
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});

// Configuración de servicios externos
const qdrantUrl = process.env.QDRANT_URL;
const ollamaUrl = process.env.OLLAMA_API_BASE_URL;

// Middleware de autenticación
const authenticateRequest = (req, res, next) => {
    const apiKey = req.headers['x-api-key'];
    if (!apiKey || apiKey !== process.env.API_KEY) {
        return res.status(401).json({ error: 'Unauthorized' });
    }
    next();
};

// Rutas de health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', version: '1.0.0' });
});

app.get('/health/postgres', async (req, res) => {
    try {
        const result = await pool.query('SELECT NOW()');
        res.json({ status: 'ok', timestamp: result.rows[0].now });
    } catch (error) {
        console.error('Error PostgreSQL:', error);
        res.status(500).json({ status: 'error', message: error.message });
    }
});

app.get('/health/qdrant', async (req, res) => {
    try {
        const response = await axios.get(`${qdrantUrl}/health`);
        res.json({ status: 'ok', qdrant: response.data });
    } catch (error) {
        console.error('Error Qdrant:', error);
        res.status(500).json({ status: 'error', message: error.message });
    }
});

// Rutas protegidas
app.post('/api/process', authenticateRequest, async (req, res) => {
    try {
        const { text, model = 'mistral', options = {} } = req.body;
        
        if (!text) {
            return res.status(400).json({ error: 'Text is required' });
        }

        // Procesar con Ollama
        const ollamaResponse = await axios.post(`${ollamaUrl}/generate`, {
            model,
            prompt: text,
            ...options
        });

        // Guardar en PostgreSQL
        await pool.query(
            'INSERT INTO processing_history (input_text, model, response) VALUES ($1, $2, $3)',
            [text, model, JSON.stringify(ollamaResponse.data)]
        );

        res.json(ollamaResponse.data);
    } catch (error) {
        console.error('Error processing:', error);
        res.status(500).json({ error: 'Processing failed', details: error.message });
    }
});

app.post('/api/search', authenticateRequest, async (req, res) => {
    try {
        const { query, collection, limit = 10 } = req.body;
        
        if (!query || !collection) {
            return res.status(400).json({ error: 'Query and collection are required' });
        }

        // Generar embedding con Ollama
        const embeddingResponse = await axios.post(`${ollamaUrl}/embeddings`, {
            model: 'nomic-embed-text',
            prompt: query
        });

        // Buscar en Qdrant
        const searchResponse = await axios.post(`${qdrantUrl}/collections/${collection}/points/search`, {
            vector: embeddingResponse.data.embedding,
            limit
        });

        res.json(searchResponse.data);
    } catch (error) {
        console.error('Error searching:', error);
        res.status(500).json({ error: 'Search failed', details: error.message });
    }
});

// Manejo de errores global
app.use((err, req, res, next) => {
    console.error('Unhandled error:', err);
    res.status(500).json({ error: 'Internal server error' });
});

// Iniciar servidor
const server = app.listen(port, process.env.FLOOWISE_HOST, () => {
    console.log(`Floowise API escuchando en http://${process.env.FLOOWISE_HOST}:${port}`);
});

// Manejo de señales de terminación
process.on('SIGTERM', () => {
    console.log('SIGTERM recibido. Cerrando servidor...');
    server.close(() => {
        console.log('Servidor cerrado');
        pool.end();
        process.exit(0);
    });
}); 