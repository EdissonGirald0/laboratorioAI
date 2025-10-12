# Changelog - Laboratorio AI Local

## [2025-10-12] - Correcciones Críticas de Despliegue y Configuración Final

### 🐛 Correcciones Críticas

#### Docker Compose
- **Networks Duplicadas**: Eliminada clave `networks` duplicada en servicio n8n (líneas 240 y 255)
- **Estructura de Volúmenes**: Reorganizada sección `volumes` al final del archivo, fuera de `services`
- **Sintaxis YAML**: Corregida estructura del archivo docker-compose.yml para validación correcta

#### Variables de Entorno
- **Redis**: Agregadas variables `REDIS_PASSWORD` y `REDIS_URL`
- **n8n Auth**: Agregadas `N8N_BASIC_AUTH_USER` y `N8N_BASIC_AUTH_PASSWORD` (opcionales)
- **n8n Database**: Agregadas 5 variables `DB_POSTGRESDB_*` para conexión PostgreSQL
- **SMTP**: Agregadas 4 variables `SMTP_*` para notificaciones por correo (opcionales)
- **Flowise**: Agregadas `FLOWISE_API_KEY`, `FLOWISE_USERNAME`, `FLOWISE_PASSWORD`
- **Credentials JSON**: Agregada `CREDENTIAL_JSON` en formato de una sola línea

#### Script init-env.sh
- **Generación Automática**: Todas las variables ahora se generan automáticamente
- **Formato JSON**: `CREDENTIAL_JSON` se genera en una sola línea para evitar errores de parsing
- **Output Mejorado**: Mensajes organizados por categoría (PostgreSQL, Redis, Flowise, Claves)
- **Contraseñas Seguras**: Generación de contraseñas aleatorias para todos los servicios

#### Dockerfile de Floowise
- **Sintaxis RUN**: Agregados caracteres de continuación `\` en comando `RUN apk add`
- **Sintaxis ENV**: Agregados caracteres de continuación `\` en variables de entorno
- **Build Exitoso**: Dockerfile ahora se construye sin errores de sintaxis

#### Imagen de Ollama
- **Migración a Imagen Oficial**: Eliminado build custom, usando directamente `ollama/ollama:latest`
- **CMD Corregido**: Removido Dockerfile.ollama, imagen oficial funciona sin modificaciones
- **API Funcional**: Ollama API v0.12.5 respondiendo en puerto 11434

#### Redis con Autenticación
- **Contraseña Configurada**: Redis requiere autenticación con contraseña alfanumérica (32 caracteres hex)
- **Command Actualizado**: Agregado `redis-server --requirepass ${REDIS_PASSWORD}`
- **Healthcheck Corregido**: Actualizado healthcheck para usar autenticación con `-a ${REDIS_PASSWORD}`
- **URL de Conexión**: Formato `redis://:password@redis:6379` para compatibilidad con todos los servicios

#### Flowise Community Edition
- **PostgreSQL Configurado**: Base de datos `ailab` con schema `public`
- **Enterprise Deshabilitado**: Variables `FLOWISE_ENTERPRISE_ENABLED=false` y `SKIP_ENTERPRISE_MIGRATIONS=true`
- **Directorios Persistentes**: Creados `.secrets`, `.apikeys` y `logs` en volumen
- **Cache Redis**: Conectado correctamente a Redis con autenticación
- **Healthcheck Simplificado**: Cambiado de `/api/v1/health` a `/` para evitar autenticación

#### OpenWebUI
- **Redis Integrado**: Configurado `REDIS_URL` con autenticación correcta
- **Ollama Conectado**: API base URL apuntando a `host.docker.internal:11434/api`
- **Estado Healthy**: Servicio completamente funcional en puerto 8080

### 📚 Documentación Actualizada
- **Instrucciones para Agentes IA**: Creado `.github/copilot-instructions.md` con patrones del proyecto
- **Flujos de Trabajo**: Documentados flujos críticos de inicialización y mantenimiento
- **Arquitectura**: Explicada comunicación entre servicios y uso de `host.docker.internal`

### ✅ Validación
- **Script validate-env.sh**: Todas las variables requeridas validadas correctamente
- **Sintaxis Docker Compose**: Archivo valida sin errores
- **Build Exitoso**: Todas las imágenes construyen correctamente

### 🔧 Proceso de Despliegue Mejorado
1. Crear directorios de datos con permisos correctos
2. Generar variables de entorno con `init-env.sh`
3. Validar configuración con `validate-env.sh`
4. Construir imagen de Ollama si es necesario
5. Desplegar servicios con `docker compose up -d`

## [2025-06-31] - Actualización Completa del Sistema

### 🚀 Características Nuevas
- **N8N v1.104.1**: Actualizado a la versión más reciente con todas las mejoras continuas
- **Flowise v2.1.1**: Migrado a la implementación oficial de Flowise con soporte completo para PostgreSQL
- **Workflows en Español**: 4 workflows de N8N completamente traducidos y actualizados:
  - Sistema de Procesamiento de Documentos
  - Sistema de Consultas Inteligentes
  - Pipeline de Análisis de Sentimientos
  - Monitoreo de Salud del Sistema

### 🔒 Seguridad Mejorada
- **Credenciales Auto-generadas**: Todas las contraseñas se generan automáticamente usando OpenSSL
- **Documentación Sanitizada**: Eliminadas todas las credenciales expuestas del README
- **Variables de Entorno**: Uso consistente de variables de entorno para todas las credenciales
- **Métodos Criptográficos**: Implementación de SCRAM-SHA-256 para PostgreSQL

### 🏗️ Arquitectura Actualizada
- **PostgreSQL Multi-DB**: Base de datos `ailab` para N8N y `flowise` para Flowise
- **Usuarios Segregados**: Usuario `aiadmin` para N8N y `postgres` para Flowise
- **Volúmenes Optimizados**: Estructura de directorios mejorada para persistencia
- **Red Docker**: Configuración de red optimizada para comunicación entre servicios

### 🐛 Correcciones
- **Autenticación PostgreSQL**: Resueltos problemas de conexión entre servicios
- **Permisos Git**: Actualizados `.gitignore` para excluir datos sensibles
- **Conflictos de Puerto**: Resuelto conflicto en puerto 3000 para Flowise
- **Sintaxis Workflows**: Corregidos errores de sintaxis en workflows N8N

### 📚 Documentación
- **README Completo**: Documentación exhaustiva con índice y navegación
- **Guías de Seguridad**: Explicación detallada de métodos de generación de credenciales
- **Scripts de Diagnóstico**: Comandos para verificación y solución de problemas
- **Información de Soporte**: Secciones de ayuda y contacto agregadas

### 🔧 Scripts Mejorados
- **init-env.sh**: Generación automática de credenciales para Flowise
- **test-lab.sh**: Script de verificación de todos los servicios
- **Backup Scripts**: Mantenimiento de copias de seguridad automáticas

### ✅ Estado Actual
- **7 Servicios Activos**: Todos los contenedores funcionando correctamente
- **PostgreSQL**: 65+ tablas de N8N funcionando
- **Flowise**: Conectado a PostgreSQL sin errores
- **Workflows**: 4 workflows en español importados y funcionales
- **Seguridad**: Sin credenciales expuestas en documentación

### 🎯 Próximos Pasos
- Dashboard web personalizado para métricas
- Integración con modelos de Hugging Face
- Sistema de notificaciones avanzadas
- API GraphQL para consultas complejas
- Clustering automático de documentos

---

**Mantenido por**: [EdissonGirald0](https://github.com/EdissonGirald0)
**Fecha**: 31 Julio, 2025
