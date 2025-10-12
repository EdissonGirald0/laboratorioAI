# Guía de Inicio Rápido - LaboratorioAI

## ⚡ Despliegue en 5 Minutos

### Requisitos Previos
- Docker y Docker Compose instalados
- 16GB de RAM (recomendado)
- 50GB de espacio en disco
- Linux/macOS (Windows con WSL2)

### Paso 1: Clonar el Repositorio
```bash
git clone https://github.com/EdissonGirald0/laboratorioAI.git
cd laboratorioAI
```

### Paso 2: Preparar el Entorno
```bash
# Dar permisos a los scripts
chmod +x scripts/*.sh

# Crear directorios de datos
mkdir -p postgres/data qdrant/data ollama/data n8n/data floowise/data openwebui/data redis/data

# Establecer permisos
chmod -R 777 */data
```

### Paso 3: Generar Variables de Entorno
```bash
# Genera automáticamente todas las credenciales
./scripts/init-env.sh
```

**⚠️ Importante**: Guarda las credenciales que se muestran en pantalla.

### Paso 4: Validar Configuración
```bash
# Verifica que todas las variables estén correctamente configuradas
./scripts/validate-env.sh
```

### Paso 5: Construir Imagen de Ollama
```bash
# Construye la imagen personalizada de Ollama
docker compose build ollama
```

### Paso 6: Desplegar Servicios
```bash
# Inicia todos los servicios en segundo plano
docker compose up -d
```

**Nota**: La primera vez puede tardar 10-15 minutos descargando imágenes y construyendo contenedores.

### Paso 7: Verificar Despliegue
```bash
# Ver estado de los servicios
docker compose ps

# Ver logs en tiempo real
docker compose logs -f
```

---

## 🎯 Acceso a los Servicios

Una vez desplegado, los servicios están disponibles en:

| Servicio | URL | Descripción |
|----------|-----|-------------|
| **OpenWebUI** | http://localhost:8080 | Interfaz web para chat con modelos de IA |
| **n8n** | http://localhost:5678 | Automatización de flujos de trabajo |
| **Floowise** | http://localhost:3000 | Constructor de aplicaciones de IA |
| **Ollama API** | http://localhost:11434 | API de modelos de lenguaje |
| **Qdrant** | http://localhost:6333 | Base de datos vectorial |
| **PostgreSQL** | localhost:5432 | Base de datos relacional |
| **Redis** | localhost:6379 | Cache y mensajería |

### Credenciales por Defecto

Las credenciales se generaron automáticamente durante `init-env.sh`. Para verlas:

```bash
# Ver archivo de variables de entorno
cat .env | grep PASSWORD
cat .env | grep USERNAME
```

---

## 🚀 Primeros Pasos

### 1. Descargar Modelos de IA en Ollama

```bash
# Modelo general (recomendado para empezar)
docker compose exec ollama ollama pull mistral

# Modelo para código
docker compose exec ollama ollama pull codellama

# Modelo para embeddings (búsqueda semántica)
docker compose exec ollama ollama pull nomic-embed-text
```

### 2. Acceder a OpenWebUI

1. Abre http://localhost:8080
2. Crea una cuenta (primera vez)
3. Selecciona un modelo de Ollama
4. ¡Comienza a chatear!

### 3. Importar Workflows en n8n

```bash
# Los workflows están en n8n/workflows/
# Importarlos desde la interfaz web de n8n
```

Workflows disponibles:
- `document-processing.json` - Procesamiento de documentos
- `intelligent-query-system-es.json` - Sistema de consultas inteligentes
- `sentiment-analysis-pipeline.json` - Análisis de sentimiento
- `system-health-monitoring.json` - Monitoreo del sistema

### 4. Configurar Floowise

1. Abre http://localhost:3000
2. Usa las credenciales de `FLOWISE_USERNAME` y `FLOWISE_PASSWORD` del archivo `.env`
3. Crea tu primer flujo de IA

---

## 🔧 Comandos Útiles

### Gestión de Servicios

```bash
# Ver estado
docker compose ps

# Ver logs
docker compose logs -f [servicio]

# Reiniciar un servicio
docker compose restart [servicio]

# Reiniciar todos los servicios
docker compose restart

# Detener servicios
docker compose stop

# Iniciar servicios detenidos
docker compose start

# Eliminar todo (sin borrar datos)
docker compose down

# Eliminar todo (incluyendo datos)
docker compose down -v
```

### Mantenimiento

```bash
# Backup de datos
./scripts/backup-data.sh

# Restaurar desde backup
./scripts/restore-data.sh ./backups/backup_YYYYMMDD_HHMMSS

# Limpiar logs antiguos
./scripts/cleanup.sh

# Monitorear servicios
./scripts/monitor-services.sh
```

### Diagnóstico

```bash
# Verificar salud de servicios
docker compose ps | grep healthy

# Ver uso de recursos
docker stats

# Ver espacio en disco
du -sh */data

# Logs de un servicio específico
docker compose logs --tail=100 postgres
```

---

## ❓ Solución de Problemas

### Servicio no se inicia

```bash
# Ver logs del servicio
docker compose logs [nombre_servicio]

# Verificar que el puerto no esté en uso
sudo netstat -tlnp | grep [puerto]

# Reiniciar el servicio
docker compose restart [nombre_servicio]
```

### Error de conexión entre servicios

```bash
# Verificar que estén en la misma red
docker network inspect laboratorio_ai

# Probar conectividad
docker compose exec n8n ping postgres
```

### Falta de espacio en disco

```bash
# Ver espacio usado
df -h
du -sh */data

# Limpiar imágenes no utilizadas
docker system prune -a

# Limpiar todo (cuidado!)
docker system prune -a --volumes
```

### Modelos de Ollama no disponibles

```bash
# Listar modelos descargados
docker compose exec ollama ollama list

# Descargar modelos necesarios
docker compose exec ollama ollama pull [nombre_modelo]
```

Para más detalles, consulta [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## 📚 Documentación Adicional

- [CHANGELOG.md](CHANGELOG.md) - Historial de cambios
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Guía completa de solución de problemas
- [docs/OLLAMA.md](docs/OLLAMA.md) - Documentación de Ollama
- [docs/FLOOWISE.md](docs/FLOOWISE.md) - Documentación de Floowise
- [docs/INTEGRACIONES.md](docs/INTEGRACIONES.md) - Guía de integraciones
- [.github/copilot-instructions.md](.github/copilot-instructions.md) - Instrucciones para agentes de IA

---

## 🤝 Contribuir

¿Encontraste un bug? ¿Tienes una sugerencia?

1. Fork el repositorio
2. Crea una rama: `git checkout -b feature/MiCaracteristica`
3. Commit tus cambios: `git commit -m 'Agrego nueva característica'`
4. Push a la rama: `git push origin feature/MiCaracteristica`
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

---

## 👥 Autor

**Edisson Giraldo** - [@EdissonGirald0](https://github.com/EdissonGirald0)

---

## ⭐ Si te gusta este proyecto, dale una estrella en GitHub!
