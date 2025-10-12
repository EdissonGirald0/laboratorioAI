# 🔐 CREDENCIALES DEL SISTEMA - LaboratorioAI

**⚠️ IMPORTANTE: Este archivo contiene credenciales sensibles. NO compartir públicamente.**

---

## 🌐 Acceso a Interfaces Web

### Flowise - Constructor Visual de Agentes IA
- **URL:** http://localhost:3000
- **Email:** `edisson.giraldo.dev@gmail.com`
- **Contraseña:** `Admin@2025!Secure`
- **Nota:** La cuenta fue creada durante el primer acceso. La contraseña DEBE contener al menos un carácter especial

---

### OpenWebUI - Interfaz de Chat con IA
- **URL:** http://localhost:8080
- **Acceso:** Crea tu cuenta en el primer acceso (el primer usuario será administrador)

---

### n8n - Automatización de Workflows
- **URL:** http://localhost:5678
- **Acceso:** Crea tu cuenta en el primer acceso

---

### Qdrant - Base de Datos Vectorial (Dashboard)
- **URL:** http://localhost:6333/dashboard
- **API Key:** Ver `.env` → `QDRANT_API_KEY`

---

## 🗄️ Base de Datos PostgreSQL

**Bases de datos disponibles:**
- `ailab` - Usada por Flowise
- `n8n_db` - Usada por n8n

**Para conexiones desde servicios dentro de Docker:**
```
Host: host.docker.internal (o postgres)
Port: 5432
Database: ailab (Flowise) o n8n_db (n8n)
User: aiadmin
Password: [Ver .env → POSTGRES_PASSWORD]
```

**Para conexiones desde el host:**
```
Host: localhost
Port: 5432
Database: ailab
User: aiadmin
Password: [Ver .env → POSTGRES_PASSWORD]
```

---

## 💾 Redis Cache

**Configuración:**
```
Host: redis (dentro de Docker) o localhost (desde host)
Port: 6379
Password: [Ver .env → REDIS_PASSWORD]
URL: redis://:PASSWORD@redis:6379
```

**⚠️ Importante:** Redis REQUIERE autenticación. La contraseña es alfanumérica de 32 caracteres.

---

## 🤖 Ollama API

**Endpoints:**
- Desde servicios Docker: `http://ollama:11434`
- Desde el host: `http://localhost:11434`

**API Status:** http://localhost:11434/api/version

**No requiere autenticación**

---

## 📋 Variables de Entorno Críticas

Todas las credenciales están en el archivo `.env`:

| Variable | Descripción | Requerimientos |
|----------|-------------|----------------|
| `FLOWISE_USERNAME` | Usuario admin de Flowise | Cualquier string |
| `FLOWISE_PASSWORD` | Contraseña admin de Flowise | **DEBE tener al menos 1 carácter especial** |
| `REDIS_PASSWORD` | Contraseña de Redis | Alfanumérica, 32 caracteres |
| `POSTGRES_PASSWORD` | Contraseña de PostgreSQL | Alfanumérica, 16 caracteres |
| `QDRANT_API_KEY` | API Key de Qdrant | Alfanumérica, 32 caracteres |
| `N8N_ENCRYPTION_KEY` | Clave de encriptación n8n | Base64, 32 bytes |

---

## 🔄 Cómo Cambiar Credenciales

### 1. Cambiar contraseña de Flowise:

```bash
# Editar .env
nano .env

# Cambiar la línea:
FLOWISE_PASSWORD=TuNuevaContraseña@2025!

# Reiniciar Flowise
docker compose restart floowise
```

**⚠️ Requisitos de la contraseña:**
- Mínimo 8 caracteres
- Al menos 1 carácter especial (@, !, #, $, %, etc.)

---

### 2. Cambiar contraseña de Redis:

```bash
# Editar .env
nano .env

# Cambiar estas líneas:
REDIS_PASSWORD=nuevacontraseña32caracteres
REDIS_URL=redis://:nuevacontraseña32caracteres@redis:6379

# Reiniciar todos los servicios que usan Redis
docker compose restart redis openwebui floowise
```

---

### 3. Cambiar contraseña de PostgreSQL:

```bash
# Editar .env
nano .env

# Cambiar:
POSTGRES_PASSWORD=nuevacontraseña
POSTGRES_NON_ROOT_PASSWORD=nuevacontraseña

# Detener servicios
docker compose down

# Eliminar volumen de PostgreSQL (¡CUIDADO! Borra datos)
docker volume rm laboratorioai_postgres_data

# Reiniciar
docker compose up -d
```

---

## 🧪 Verificar Credenciales

### Flowise:
```bash
# Verificar que el servidor está escuchando
curl http://localhost:3000/

# Los logs deben mostrar:
docker logs floowise --tail=5
# Debe aparecer: "Flowise Server is listening at http://0.0.0.0:3000"
```

### Redis:
```bash
# Probar conexión con autenticación
docker exec -it redis redis-cli -a "$(grep REDIS_PASSWORD .env | cut -d= -f2)" ping
# Debe responder: PONG
```

### PostgreSQL:
```bash
# Probar conexión
docker exec -it laboratorioai-postgres-1 psql -U aiadmin -d ailab -c "SELECT version();"
```

---

## ❌ Errores Comunes

### "Password must contain at least one special character"
**Causa:** Contraseña de Flowise sin caracteres especiales  
**Solución:** Agregar caracteres como @, !, #, $, % a la contraseña

---

### "WRONGPASS invalid username-password pair"
**Causa:** Contraseña de Redis incorrecta o no configurada  
**Solución:** 
1. Verificar `REDIS_PASSWORD` en `.env`
2. Verificar que `REDIS_URL` incluye la contraseña: `redis://:PASSWORD@redis:6379`
3. Reiniciar servicios: `docker compose restart redis openwebui floowise`

---

### "Unauthorized Access" en Flowise
**Causa:** Intentando acceder sin login o credenciales incorrectas  
**Solución:** Usar `admin` / `Admin@2025!Secure` en http://localhost:3000

---

## 📝 Notas Importantes

1. **Nunca compartir el archivo `.env`** - Contiene todas las credenciales del sistema

2. **Backup de credenciales** - Guarda las credenciales en un gestor de contraseñas seguro

3. **Primer acceso a OpenWebUI y n8n** - El primer usuario que se registre será el administrador

4. **Regenerar credenciales** - Usa `./scripts/init-env.sh` para generar nuevas credenciales automáticamente (borrará las actuales)

5. **Contraseña de Flowise** - Siempre debe incluir caracteres especiales o la aplicación no permitirá el login

---

## 🆘 Si Olvidaste las Credenciales

### Flowise:
```bash
# Ver la contraseña actual
grep FLOWISE_PASSWORD .env
```

### Regenerar TODAS las credenciales (⚠️ Borrará las actuales):
```bash
# Backup del .env actual
cp .env .env.backup

# Generar nuevas credenciales
./scripts/init-env.sh

# Reiniciar todo
docker compose down
docker compose up -d
```

---

**Última actualización:** 12 de octubre de 2025
