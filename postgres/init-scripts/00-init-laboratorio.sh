#!/bin/bash
set -e

echo "=== LaboratorioAI - Inicialización de PostgreSQL ==="

# Verificar y crear base de datos n8n_db si no existe
echo "Verificando base de datos n8n_db..."
if psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tAc "SELECT 1 FROM pg_database WHERE datname='n8n_db'" | grep -q 1; then
    echo "  ✓ n8n_db ya existe (recuperación)"
else
    echo "  Creando n8n_db..."
    psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE DATABASE n8n_db;"
    echo "  ✓ n8n_db creada"
fi

# Extensiones
echo "Instalando extensiones..."
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS \"pgcrypto\";"
echo "  ✓ Extensiones instaladas"

# Crear usuario no-root si no existe
echo "Configurando usuario ${POSTGRES_NON_ROOT_USER}..."
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tAc "SELECT 1 FROM pg_roles WHERE rolname='${POSTGRES_NON_ROOT_USER}'" | grep -q 1 || {
    psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE USER ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';"
    echo "  ✓ Usuario creado"
}
echo "  ✓ Usuario verificado"

# Permisos
echo "Asignando permisos..."
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
    GRANT CREATE ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
    
    -- n8n_db también
    GRANT ALL PRIVILEGES ON DATABASE n8n_db TO ${POSTGRES_NON_ROOT_USER};
    GRANT CREATE ON DATABASE n8n_db TO ${POSTGRES_NON_ROOT_USER};
EOSQL
echo "  ✓ Permisos asignados"

echo "=== Inicialización completada ==="
