-- Crear extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Crear esquema para n8n
CREATE SCHEMA IF NOT EXISTS n8n;

-- Crear esquema para floowise
CREATE SCHEMA IF NOT EXISTS floowise;

-- Asignar permisos
GRANT ALL PRIVILEGES ON SCHEMA n8n TO aiadmin;
GRANT ALL PRIVILEGES ON SCHEMA floowise TO aiadmin; 