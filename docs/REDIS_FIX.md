# 🔧 Solución: Error de Autenticación Redis en OpenWebUI

## 📋 Resumen del Problema

**Fecha**: 12 de octubre de 2025  
**Servicio Afectado**: OpenWebUI  
**Error**: `redis.exceptions.AuthenticationError: Authentication required`  
**Estado**: ✅ **RESUELTO**

---

## 🔍 Descripción del Error

OpenWebUI no podía conectarse a Redis y mostraba el siguiente error en los logs:

```python
redis.exceptions.AuthenticationError: Authentication required.
```

### Stack Trace Completo

```
File "/app/backend/open_webui/config.py", line 269, in __getattr__
  redis_value = self._redis.get(redis_key)
File "/usr/local/lib/python3.11/site-packages/redis/commands/core.py", line 1829, in get
  return self.execute_command("GET", name, keys=[name])
redis.exceptions.AuthenticationError: Authentication required.
```

---

## 🎯 Causa Raíz

El formato de la URL de Redis era **incorrecto** para OpenWebUI. El formato antiguo:

```
redis://:PASSWORD@redis:6379
```

Tenía dos problemas:
1. **Host incorrecto**: Usaba `redis` en lugar de `host.docker.internal`
2. **Formato de autenticación**: El formato `:PASSWORD@` no funcionaba correctamente

---

## ✅ Solución Implementada

### 1. Formato Correcto de la URL

Cambiar de:
```
redis://:PASSWORD@redis:6379
```

A:
```
redis://host.docker.internal:6379/0?password=PASSWORD
```

### 2. Cambios en `docker-compose.yml`

**Antes:**
```yaml
openwebui:
  environment:
    - REDIS_URL=${REDIS_URL}
```

Con `.env` conteniendo:
```env
REDIS_URL=redis://:d5863c011152954059ed17067bb14020@redis:6379
```

**Después:**
```yaml
openwebui:
  environment:
    - REDIS_URL=redis://host.docker.internal:6379/0?password=${REDIS_PASSWORD}
```

### 3. Cambios en `.env`

**Antes:**
```env
REDIS_URL=redis://:d5863c011152954059ed17067bb14020@redis:6379
```

**Después:**
```env
REDIS_URL=redis://host.docker.internal:6379/0?password=d5863c011152954059ed17067bb14020
```

---

## 🔧 Comandos Ejecutados

### 1. Actualizar archivos de configuración
```bash
# Editar docker-compose.yml y .env con los nuevos formatos
```

### 2. Recrear el contenedor de OpenWebUI
```bash
docker compose up -d --force-recreate openwebui
```

### 3. Verificar que funciona
```bash
# Ver logs
docker compose logs openwebui --tail 30

# Verificar estado
docker compose ps openwebui

# Probar conexión HTTP
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8080
```

---

## ✅ Verificación de la Solución

### Estado del Servicio
```bash
$ docker compose ps openwebui
NAME        STATUS
openwebui   Up (healthy)
```

### Sin Errores en Logs
```bash
$ docker compose logs openwebui --since 5m | grep -i "redis.*error"
# Sin resultados = No hay errores
```

### HTTP Funcional
```bash
$ curl -I http://localhost:8080
HTTP/1.1 200 OK
```

---

## 📝 Notas Técnicas

### Formato de URL de Redis

El formato correcto para URL de Redis con autenticación es:

```
redis://[host]:[port]/[database]?password=[password]
```

**Componentes:**
- `host`: Hostname o IP del servidor Redis
- `port`: Puerto (por defecto 6379)
- `database`: Número de base de datos (0-15, por defecto 0)
- `password`: Contraseña para autenticación

**Ejemplo:**
```
redis://localhost:6379/0?password=mypassword123
```

### Host en Docker Compose

En este proyecto usamos `host.docker.internal` porque:
- Redis está en un contenedor separado
- OpenWebUI necesita acceder desde otra red
- `host.docker.internal` resuelve al host del contenedor

---

## 🚨 Troubleshooting Adicional

### Si el error persiste:

#### 1. Verificar que Redis está funcionando
```bash
docker compose ps redis
docker compose logs redis --tail 20
```

#### 2. Probar conexión manual a Redis
```bash
docker exec -it redis redis-cli -a "TU_PASSWORD" ping
# Debe responder: PONG
```

#### 3. Verificar variables de entorno
```bash
docker compose exec openwebui env | grep REDIS
```

#### 4. Verificar que el password es correcto
```bash
# En .env debe coincidir con docker-compose.yml
grep REDIS_PASSWORD .env
```

#### 5. Recrear completamente
```bash
# Detener todo
docker compose down

# Eliminar volúmenes de OpenWebUI (opcional, perderás datos)
docker volume rm laboratorioai_openwebui_data

# Iniciar de nuevo
docker compose up -d
```

---

## 🔐 Consideraciones de Seguridad

1. **Password en la URL**: El password está en texto plano en la URL
   - ✅ Aceptable en redes internas Docker
   - ⚠️ No exponer públicamente

2. **Variables de entorno**: 
   - Archivo `.env` debe tener permisos `600`
   - Nunca commitear al repositorio (ya en `.gitignore`)

3. **Alternativas más seguras**:
   - Usar Docker secrets (en producción)
   - Variables de entorno separadas: `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`

---

## 📚 Referencias

- [Redis URL Format](https://redis.io/docs/connect/clients/)
- [OpenWebUI Redis Configuration](https://github.com/open-webui/open-webui)
- [Docker Compose Networks](https://docs.docker.com/compose/networking/)

---

## ✅ Checklist de Solución

- [x] Identificar error de autenticación Redis
- [x] Analizar formato de URL incorrecto
- [x] Cambiar formato en `docker-compose.yml`
- [x] Actualizar `.env` con formato correcto
- [x] Recrear contenedor OpenWebUI
- [x] Verificar logs sin errores
- [x] Confirmar HTTP 200 en OpenWebUI
- [x] Documentar solución

---

**Estado**: ✅ Problema resuelto completamente  
**Tiempo de resolución**: ~10 minutos  
**Impacto**: OpenWebUI ahora funciona correctamente con Redis para caché y sesiones

---

**Última actualización**: 12 de octubre de 2025  
**Documentado por**: GitHub Copilot AI Agent
