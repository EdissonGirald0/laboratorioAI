-- Crear extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Crear usuario para aplicaciones (la contraseña se tomará de las variables de entorno)
-- Docker automáticamente ejecuta este script después de crear el usuario root
CREATE USER aiadmin;
ALTER USER aiadmin PASSWORD 'DfAVtH4h1kBslEtM';

-- Crear base de datos si no existe y asignar propietario
-- La base de datos ailab ya se crea automáticamente por POSTGRES_DB
ALTER DATABASE ailab OWNER TO aiadmin;

-- Crear esquema para n8n
CREATE SCHEMA IF NOT EXISTS n8n;
ALTER SCHEMA n8n OWNER TO aiadmin;

-- Crear esquema para floowise
CREATE SCHEMA IF NOT EXISTS floowise;
ALTER SCHEMA floowise OWNER TO aiadmin;

-- Asignar permisos amplios
GRANT ALL PRIVILEGES ON DATABASE ailab TO aiadmin;
GRANT ALL PRIVILEGES ON SCHEMA n8n TO aiadmin;
GRANT ALL PRIVILEGES ON SCHEMA floowise TO aiadmin;
GRANT ALL PRIVILEGES ON SCHEMA public TO aiadmin;
GRANT CREATE ON DATABASE ailab TO aiadmin; 