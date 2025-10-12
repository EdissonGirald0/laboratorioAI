# Guía de Solución de Problemas - LaboratorioAI

## Errores Comunes y Soluciones

### 1. Error: "docker-compose: orden no encontrada"

**Problema**: El comando `docker-compose` no está disponible.

**Solución**:
```bash
# En sistemas modernos, usar 'docker compose' (sin guión)
docker compose up -d

# O instalar docker-compose
sudo apt-get update
sudo apt-get install docker-compose-plugin
```

---

### 2. Error: "mapping key 'networks' already defined"

**Problema**: Clave duplicada en docker-compose.yml.

**Solución**: Este error ya fue corregido en la versión actual. Si persiste:
```bash
# Restaurar desde backup
cp docker-compose.yml.backup docker-compose.yml

# O usar git para obtener la versión corregida
git pull origin main
```

---

### 3. Error: "volumes additional properties not allowed"

**Problema**: La sección `volumes` está mal ubicada en docker-compose.yml.

**Solución**: La sección `volumes` debe estar al mismo nivel que `services` y `networks`, no dentro de `services`. Ya corregido en la versión actual.

---

### 4. Error: "unexpected character in variable name"

**Problema**: JSON multilínea en archivo `.env`.

**Solución**:
```bash
# Regenerar el archivo .env
./scripts/init-env.sh

# El script ahora genera JSON en una sola línea
```

---

### 5. Error: "dockerfile parse error: unknown instruction"

**Problema**: Falta el carácter de continuación `\` en comandos multilínea del Dockerfile.

**Solución**: Ya corregido en `floowise/Dockerfile`. Ejemplo del formato correcto:
```dockerfile
RUN apk add --no-cache \
    python3 \
    py3-pip \
    build-base
```

---

### 6. Error: "pull access denied for localaidocker-ollama"

**Problema**: La imagen de Ollama no existe en Docker Hub, debe construirse localmente.

**Solución**:
```bash
# Construir la imagen antes del despliegue
docker compose build ollama

# O durante el despliegue
docker compose up -d --build
```

---

### 7. Faltan Variables de Entorno

**Problema**: Warnings sobre variables no definidas al ejecutar docker compose.

**Solución**:
```bash
# Regenerar archivo .env con todas las variables
./scripts/init-env.sh

# Validar que todas estén presentes
./scripts/validate-env.sh
```

Variables que se generan automáticamente:
- REDIS_PASSWORD, REDIS_URL
- N8N_BASIC_AUTH_USER, N8N_BASIC_AUTH_PASSWORD
- DB_POSTGRESDB_* (5 variables)
- SMTP_* (4 variables)
- FLOWISE_API_KEY, FLOWISE_USERNAME, FLOWISE_PASSWORD
- CREDENTIAL_JSON

---

### 8. Problemas de Permisos en Directorios

**Problema**: Los contenedores no pueden escribir en los volúmenes.

**Solución**:
```bash
# Crear directorios con permisos correctos
mkdir -p postgres/data qdrant/data ollama/data n8n/data floowise/data openwebui/data redis/data

# Establecer permisos
chmod -R 777 */data

# O ajustar ownership
sudo chown -R 1000:1000 */data
```

---

### 9. Servicios No se Inician

**Problema**: Contenedores se detienen inmediatamente después de iniciar.

**Diagnóstico**:
```bash
# Ver logs de un servicio específico
docker compose logs <nombre_servicio>

# Ver logs de todos los servicios
docker compose logs

# Ver estado de los contenedores
docker compose ps -a
```

**Soluciones comunes**:
- Verificar que el archivo `.env` exista y sea válido
- Verificar que los puertos no estén en uso
- Revisar logs para errores específicos

---

### 10. Error de Conexión entre Servicios

**Problema**: Los servicios no pueden comunicarse entre sí.

**Verificación**:
```bash
# Verificar que todos estén en la misma red
docker network inspect laboratorio_ai

# Verificar conectividad desde un contenedor
docker compose exec n8n ping postgres
docker compose exec floowise ping ollama
```

**Solución**:
- Asegúrate de usar `host.docker.internal` para referencias entre servicios
- Verifica que todos los servicios estén en la red `laboratorio_ai`
- Reinicia los servicios: `docker compose restart`

---

### 11. Base de Datos No Se Inicializa

**Problema**: PostgreSQL no crea las bases de datos o usuarios.

**Solución**:
```bash
# Eliminar volúmenes y empezar de cero
docker compose down -v

# Verificar que el script de inicialización existe
ls -l postgres/init-scripts/

# Volver a desplegar
docker compose up -d postgres

# Verificar logs de PostgreSQL
docker compose logs postgres
```

---

### 12. Modelos de Ollama No Disponibles

**Problema**: Ollama no tiene modelos descargados.

**Solución**:
```bash
# Listar modelos disponibles
docker compose exec ollama ollama list

# Descargar modelos necesarios
docker compose exec ollama ollama pull mistral
docker compose exec ollama ollama pull codellama
docker compose exec ollama ollama pull nomic-embed-text
```

---

## Comandos Útiles de Diagnóstico

### Ver Estado General
```bash
# Estado de todos los servicios
docker compose ps

# Recursos utilizados
docker stats

# Espacio en disco
df -h
du -sh */data
```

### Logs y Debugging
```bash
# Logs en tiempo real
docker compose logs -f

# Logs de un servicio específico
docker compose logs -f n8n

# Últimas 100 líneas de logs
docker compose logs --tail=100
```

### Reiniciar Servicios
```bash
# Reiniciar todos los servicios
docker compose restart

# Reiniciar un servicio específico
docker compose restart postgres

# Reinicio completo (elimina contenedores pero no volúmenes)
docker compose down
docker compose up -d
```

### Limpieza Completa
```bash
# Detener y eliminar todo (incluyendo volúmenes)
docker compose down -v

# Limpiar imágenes no utilizadas
docker system prune -a

# Limpiar todo el sistema Docker
docker system prune -a --volumes
```

---

## Verificación Post-Despliegue

Una vez desplegado, verifica que todo funcione:

```bash
# 1. Todos los servicios deben estar 'Up'
docker compose ps

# 2. Verificar healthchecks
docker compose ps | grep healthy

# 3. Verificar conectividad de servicios
curl http://localhost:11434/api/version  # Ollama
curl http://localhost:6333/health        # Qdrant
curl http://localhost:8080              # OpenWebUI
curl http://localhost:5678              # n8n
curl http://localhost:3000              # Floowise

# 4. Verificar PostgreSQL
docker compose exec postgres psql -U aiadmin -d ailab -c "SELECT version();"
```

---

## Recursos Adicionales

- **Docker Compose Docs**: https://docs.docker.com/compose/
- **Ollama Docs**: https://ollama.ai/docs
- **n8n Docs**: https://docs.n8n.io/
- **Flowise Docs**: https://docs.flowiseai.com/

---

## Soporte

Si encuentras un problema no documentado aquí:

1. Revisa los logs detalladamente: `docker compose logs`
2. Verifica el archivo `.env` con: `./scripts/validate-env.sh`
3. Consulta el CHANGELOG.md para cambios recientes
4. Abre un issue en GitHub con:
   - Descripción del problema
   - Logs relevantes
   - Comando que causa el error
   - Versión de Docker y Docker Compose
