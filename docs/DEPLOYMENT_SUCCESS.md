# ✅ Despliegue Exitoso - LaboratorioAI

**Fecha de Despliegue:** 12 de octubre de 2025  
**Estado:** Todos los servicios operacionales

---

## 🎉 Servicios Activos

### 1. **Ollama** - Motor de IA Local
- **Estado:** ✅ Funcionando
- **Puerto:** 11434
- **URL:** http://localhost:11434
- **Versión API:** v0.12.5
- **Imagen:** `ollama/ollama:latest` (oficial)

**Próximo paso:** Descargar modelos
```bash
docker compose exec ollama ollama pull mistral
docker compose exec ollama ollama pull llama3
docker compose exec ollama ollama pull codellama
```

---

### 2. **OpenWebUI** - Interfaz de Chat con IA
- **Estado:** ✅ Healthy
- **Puerto:** 8080
- **URL:** http://localhost:8080
- **Características:**
  - ✅ Conectado a Ollama API
  - ✅ Redis cache habilitado
  - ✅ Base de datos SQLite

**Acceso:** Crea tu cuenta en el primer acceso

---

### 3. **Flowise** - Constructor Visual de Agentes IA
- **Estado:** ✅ Funcionando
- **Puerto:** 3000
- **URL:** http://localhost:3000
- **Edición:** Community

**Credenciales de Acceso:**
```
Email: edisson.giraldo.dev@gmail.com
Contraseña: Admin@2025!Secure
```

**Nota:** La cuenta fue creada durante el primer acceso. Flowise Community no utiliza las variables `FLOWISE_USERNAME` y `FLOWISE_PASSWORD` para pre-crear cuentas.

**Características:**
- ✅ Base de datos PostgreSQL (`ailab`)
- ✅ Cache Redis con autenticación
- ✅ Conectado a Ollama (http://ollama:11434)
- ✅ Conectado a Qdrant (http://qdrant:6333)
- ✅ Directorios persistentes creados

---

### 4. **n8n** - Automatización de Workflows
- **Estado:** ✅ Healthy
- **Puerto:** 5678
- **URL:** http://localhost:5678
- **Base de datos:** PostgreSQL (`n8n_db`)

**Credenciales listas para importar:** 
- ✅ `postgres-main.json` - Conexión a base de datos n8n_db
- ✅ `redis-main.json` - Conexión a Redis con autenticación
- ✅ `ollama-api.json` - API de Ollama
- ✅ `flowise-api.json` - API de Flowise
- ✅ `qdrant-api.json` - Base de datos vectorial

**Workflows disponibles (7):** 
- `chatbot.json` - Bot de chat con IA
- `document-processing-automation.json` - Procesamiento automático de documentos
- `document-processing.json` - Procesamiento de documentos
- `intelligent-query-system-es.json` - Sistema de consultas inteligentes (Español)
- `intelligent-query-system.json` - Sistema de consultas inteligentes
- `sentiment-analysis-pipeline.json` - Pipeline de análisis de sentimientos
- `system-health-monitoring.json` - Monitoreo de salud del sistema

**Cómo importar:**
```bash
# Ver instrucciones completas
cat ./n8n/IMPORT_INSTRUCTIONS.md

# O ejecutar el script helper
./scripts/import-n8n-data.sh
```

**Acceso:** Crea tu cuenta en el primer acceso → Settings → Credentials → Importar credenciales → Workflows → Import from File

---

### 5. **PostgreSQL** - Base de Datos Relacional
- **Estado:** ✅ Healthy
- **Puerto:** 5432 (solo interno)
- **Bases de datos:** 
  - `ailab` - Usada por Flowise
  - `n8n_db` - Usada por n8n
- **Usuario:** `aiadmin`
- **Contraseña:** Ver archivo `.env` → `POSTGRES_PASSWORD`

**Conexión desde servicios:**
```
Host: host.docker.internal (o postgres)
Port: 5432
Database: ailab (Flowise) o n8n_db (n8n)
User: aiadmin
```

---

### 6. **Redis** - Cache y Mensajería
- **Estado:** ✅ Healthy con autenticación
- **Puerto:** 6379
- **Contraseña:** Ver archivo `.env` → `REDIS_PASSWORD`

**URL de conexión:**
```
redis://:d5863c011152954059ed17067bb14020@redis:6379
```

---

### 7. **Qdrant** - Base de Datos Vectorial
- **Estado:** ✅ Funcionando
- **Puerto:** 6333 (HTTP), 6334 (gRPC)
- **URL:** http://localhost:6333
- **Dashboard:** http://localhost:6333/dashboard
- **API Key:** Ver archivo `.env` → `QDRANT_API_KEY`

---

## 🔐 Seguridad Implementada

| Servicio | Autenticación | Estado |
|----------|--------------|--------|
| Redis | ✅ Contraseña alfanumérica 32 caracteres | Habilitada |
| PostgreSQL | ✅ Usuario/contraseña generados | Habilitada |
| Qdrant | ✅ API Key generada | Habilitada |
| Flowise | ✅ Usuario: admin / Contraseña con caracteres especiales | Habilitada |
| n8n | ✅ Encryption key generada | Habilitada |
| OpenWebUI | ✅ Registro de usuarios | Habilitada |

---

## 📁 Datos Persistentes

Todos los datos se almacenan en:

```
/home/edissondev1/proyectos/laboratorioAI/
├── redis/data/          → Datos de Redis
├── postgres/data/       → Base de datos PostgreSQL
├── ollama/data/         → Modelos de Ollama (se poblarán al descargar)
├── openwebui/data/      → Conversaciones y configuración
├── floowise_data/       → Flujos y configuración de Flowise
├── n8n/data/            → Workflows y credenciales
└── qdrant_data/         → Índices vectoriales
```

---

## 🚀 Primeros Pasos

### 1. Descargar Modelos de IA (Recomendado)

```bash
# Modelo general rápido (~4GB)
docker compose exec ollama ollama pull mistral

# Modelo potente (~4.7GB)
docker compose exec ollama ollama pull llama3

# Modelo para código (~3.8GB)
docker compose exec ollama ollama pull codellama

# Verificar modelos instalados
docker compose exec ollama ollama list
```

### 2. Probar OpenWebUI

1. Accede a http://localhost:8080
2. Crea tu cuenta (primer usuario será admin)
3. Selecciona un modelo de la lista desplegable
4. ¡Comienza a chatear con tu IA local!

### 3. Crear Flujo en Flowise

1. Accede a http://localhost:3000
2. Login con `admin` / `Admin@2025!Secure`
3. Click en "Add New"
4. Arrastra nodos:
   - **Chat Models** → Ollama
   - **Vector Stores** → Qdrant
   - **Memory** → Conversation Buffer Memory
5. Conecta los nodos y guarda

### 4. Configurar Automatización en n8n

1. Accede a http://localhost:5678
2. Crea tu cuenta
3. Ve a "Workflows" → "Import from File"
4. Importa workflows desde `./n8n/workflows/`
5. Configura credenciales de Ollama y Flowise

---

## 🔧 Comandos Útiles

### Ver estado de servicios
```bash
docker compose ps
```

### Ver logs en tiempo real
```bash
docker logs -f <servicio>
# Ejemplo: docker logs -f floowise
```

### Reiniciar un servicio
```bash
docker compose restart <servicio>
```

### Reiniciar todo el stack
```bash
docker compose restart
```

### Backup completo
```bash
./scripts/backup-data.sh
```

### Detener todo
```bash
docker compose down
```

### Iniciar todo nuevamente
```bash
docker compose up -d
```

---

## 📊 Recursos del Sistema

**Límites configurados por servicio:**

| Servicio | CPU Límite | RAM Límite | CPU Reservada | RAM Reservada |
|----------|-----------|-----------|---------------|---------------|
| Redis | 1.0 | 1GB | 0.25 | 256MB |
| Flowise | 2.0 | 4GB | 0.5 | 1GB |
| n8n | 2.0 | 2GB | 0.5 | 512MB |

**Otros servicios sin límites estrictos:**
- Ollama: Sin límite (usará lo necesario para modelos)
- PostgreSQL: Sin límite
- Qdrant: Sin límite
- OpenWebUI: Sin límite

---

## ⚠️ Notas Importantes

1. **Redis requiere autenticación:** Todos los servicios están configurados para usar la contraseña de Redis del archivo `.env`

2. **Flowise requiere contraseña fuerte:** La contraseña debe contener al menos un carácter especial

3. **Primera vez con Ollama:** Necesitas descargar modelos antes de poder usarlos

4. **Backups:** Los datos están en volúmenes locales. Usa `./scripts/backup-data.sh` regularmente

5. **Variables de entorno:** No compartas el archivo `.env`, contiene credenciales sensibles

---

## 🐛 Solución de Problemas

Si encuentras algún problema, consulta:

1. **TROUBLESHOOTING.md** → Guía completa de solución de problemas
2. **CHANGELOG.md** → Registro de todos los cambios y fixes
3. **docs/QUICKSTART.md** → Guía de inicio rápido

### Errores comunes:

**"Cannot connect to Redis"**
```bash
# Verifica que Redis esté healthy
docker compose ps redis

# Revisa logs
docker logs redis --tail=20
```

**"Ollama model not found"**
```bash
# Descarga el modelo que necesitas
docker compose exec ollama ollama pull mistral
```

**"Flowise database error"**
```bash
# Verifica PostgreSQL
docker compose ps postgres

# Reinicia Flowise
docker compose restart floowise
```

---

## 📞 Soporte y Contribuciones

- **Documentación:** Carpeta `docs/`
- **Scripts útiles:** Carpeta `scripts/`
- **Workflows de ejemplo:** Carpeta `n8n/workflows/`

---

## 🎯 Próximas Mejoras Sugeridas

1. ✅ Sistema desplegado y funcionando
2. ⏳ Descargar y probar modelos de IA
3. ⏳ Crear flujos personalizados en Flowise
4. ⏳ Configurar workflows de automatización en n8n
5. ⏳ Implementar RAG (Retrieval Augmented Generation) con Qdrant
6. ⏳ Configurar backups automáticos
7. ⏳ Monitoreo de salud con el workflow incluido

---

**¡Felicitaciones! Tu laboratorio de IA local está completamente operacional.** 🚀
