# Guia Rapida

## 1. Requisitos

```bash
docker --version      # Docker instalado
docker compose version # Docker Compose instalado
```

## 2. Configurar

```bash
# Generar archivo .env con claves aleatorias
chmod +x scripts/init-env.sh
./scripts/init-env.sh
```

## 3. Iniciar

```bash
# Iniciar todos los servicios
docker compose up -d
```

## 4. Verificar

```bash
# Ver estado de servicios
make status

# O manualmente
docker compose ps
```

## 5. Acceder

| Servicio | URL |
|----------|-----|
| n8n | http://localhost:5678 |
| Flowise | http://localhost:3000 |
| OpenWebUI | http://localhost:8080 |
| Ollama API | http://localhost:11434 |
| Qdrant | http://localhost:6333 |

## 6. Automatizar n8n (opcional)

```bash
./scripts/setup-n8n-complete.sh
```

Importa 5 workflows y 5 credenciales automaticamente.

## Comandos frecuentes

```bash
make ps        # Ver contenedores
make logs      # Ver logs
make restart   # Reiniciar todo
make clean     # Limpiar todo (peligroso)
```

## Bases de datos

- `ailab` - Flowise (se crea automaticamente)
- `n8n_db` - n8n (se crea/recupera automaticamente)

Si una BD se borra, se recrea al reiniciar postgres.

## Problemas comunes

Ver [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)