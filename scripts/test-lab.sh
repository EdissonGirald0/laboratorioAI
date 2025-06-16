#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function check() {
  local name="$1"
  local cmd="$2"
  local expect="$3"
  echo -n "Probando $name... "
  if eval "$cmd" | grep -q "$expect"; then
    echo -e "${GREEN}OK${NC}"
  else
    echo -e "${RED}FALLÓ${NC}"
    exit 1
  fi
}

echo "--- Pruebas de entorno Laboratorio AI Docker ---"

# Ollama
check "Ollama" "curl -s http://localhost:11434/" "Ollama is running"

# OpenWebUI (espera hasta 30s si es necesario)
for i in {1..30}; do
  if curl -s http://localhost:8080/ | grep -q '<title>Open WebUI'; then
    echo -e "${GREEN}OpenWebUI OK${NC}"
    break
  fi
  sleep 1
done
if ! curl -s http://localhost:8080/ | grep -q '<title>Open WebUI'; then
  echo -e "${RED}OpenWebUI FALLÓ${NC}"
  exit 1
fi

# n8n (espera hasta 30s si es necesario)
for i in {1..30}; do
  if nc -z localhost 5678; then
    echo -e "${GREEN}n8n OK${NC}"
    break
  fi
  sleep 1
done
if ! nc -z localhost 5678; then
  echo -e "${RED}n8n FALLÓ${NC}"
  exit 1
fi

# Floowise
check "Floowise" "curl -s http://localhost:3000/" "Floowise API está funcionando"

# Qdrant
check "Qdrant" "curl -s http://localhost:6333/collections" 'collections'

# PostgreSQL (verifica conexión real)
if docker-compose exec postgres psql -U aiadmin -d ailab -c "SELECT 1" > /dev/null 2>&1; then
  echo -e "${GREEN}PostgreSQL OK${NC}"
else
  echo -e "${RED}PostgreSQL FALLÓ${NC}"
  exit 1
fi

echo -e "\n${GREEN}Todas las pruebas pasaron correctamente.${NC}" 