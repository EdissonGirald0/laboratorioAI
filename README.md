# Laboratorio AI Local

[![GitHub Actions](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml/badge.svg)](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-green.svg)](LICENSE)

## 📋 Información del Repositorio

Este repositorio contiene la configuración y scripts necesarios para desplegar un laboratorio de Inteligencia Artificial local utilizando Docker. El proyecto está diseñado para proporcionar un entorno completo y aislado para experimentar con diferentes modelos de IA y herramientas de procesamiento de datos.

### 📁 Estructura del Proyecto

```
laboratorioAI/
├── docs/                # 📚 Documentación completa
├── scripts/             # 🔧 Scripts de automatización
├── n8n/                 # 🤖 Workflows y credenciales
├── config/              # 🔐 Configuración sensible
├── backups/             # 💾 Respaldos
├── postgres/            # 🗄️ Base de datos
├── qdrant/              # 🔍 Base de datos vectorial
├── ollama/              # 🧠 Modelos de IA
├── floowise/            # 🌊 Procesamiento de flujos
├── openwebui/           # 🖥️ Interfaz web
└── redis/               # ⚡ Caché y sesiones
```

### 🚀 Inicio Rápido

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/EdissonGirald0/laboratorioAI.git
   cd laboratorioAI
   ```

2. **Ejecutar el script de configuración:**
   ```bash
   chmod +x .devcontainer/post-create.sh
   ./.devcontainer/post-create.sh
   ```

3. **Verificar la instalación:**
   - El script verificará automáticamente:
     - Instalación de Docker
     - Instalación de Docker Compose
     - Permisos de usuario
     - Directorios necesarios

### 🔧 Solución de Problemas

1. **Problemas de Permisos Docker:**
   ```bash
   # Agregar usuario al grupo docker
   newgrp docker
   # Si persisten los problemas
   sudo chmod 666 /var/run/docker.sock
   ```

2. **Verificar Estado de Docker:**
   ```bash
   sudo systemctl status docker
   # Si está detenido
   sudo systemctl restart docker
   ```

## 🔄 Estado del Sistema

Ver documentación completa en [docs/PROJECT_SUMMARY.md](docs/PROJECT_SUMMARY.md) para resumen ejecutivo y métricas del proyecto.

### 🔄 Flujo de Instalación

1. **Detección de Entorno**
   - Verificación del sistema operativo
   - Identificación de Codespace vs Local

2. **Verificación del Sistema**
   - Comprobación de dependencias
   - Validación de requisitos

3. **Configuración de Docker**
   - Instalación de Docker si es necesario
   - Instalación de Docker Compose
   - Configuración de permisos

4. **Configuración de Ambiente**
   - Instalación de Node.js y herramientas
   - Creación de directorios
   - Configuración de permisos
   - Verificación final

### 🛠️ Entornos Soportados

El script de configuración ahora soporta dos entornos principales:

1. **GitHub Codespaces**
   - Detección automática del entorno
   - Verificación de herramientas preinstaladas
   - Configuración mínima necesaria

2. **Sistema Local (Linux)**
   - Instalación completa de dependencias
   - Configuración de Docker y Docker Compose
   - Gestión de permisos y directorios

### 🚀 Características Principales

- **Entorno Aislado**: Todos los servicios se ejecutan en contenedores Docker
- **Fácil Configuración**: Scripts automatizados para la configuración inicial
- **Backup Automático**: Sistema de respaldo para datos y configuraciones
- **Seguridad**: Configuración segura por defecto
- **Escalabilidad**: Fácil de extender con nuevos servicios

### 🛠️ Tecnologías y Herramientas

- **Core Technologies**
  - Docker
  - Docker Compose
  - Node.js

- **Servicios**
  - PostgreSQL (Base de datos)
  - Qdrant (Vector DB)
  - Ollama (Modelos de IA)
  - N8N (Automatización)
  - Floowise (Procesamiento)
  - OpenWebUI (Interfaz)

- **Herramientas de Desarrollo**
  - TypeScript
  - ts-node
  - n8n CLI

### 📦 Estructura Completa del Repositorio

Ver documentación detallada en [docs/PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md)

## Requisitos Previos

- Docker y Docker Compose
- Git
- Sistema operativo Linux (recomendado Ubuntu 22.04 o superior)
- Mínimo 16GB de RAM
- 50GB de espacio en disco
- GPU compatible con CUDA (opcional, pero recomendado)

## Directorio de Datos

```
data/
├── postgres/            # Base de datos principal
├── qdrant/             # Base de datos vectorial
├── ollama/             # Modelos de IA
├── n8n/                # Configuración de automatización
├── floowise/           # Datos de la aplicación
├── openwebui/          # Configuración de la interfaz
└── redis/             # Caché y mensajería
```

## Configuración Inicial

1. Clonar el repositorio:
```bash
git clone https://github.com/EdissonGirald0/laboratorioAI.git
cd laboratorioAI
```

2. Generar el archivo .env:
```bash
chmod +x scripts/init-env.sh
./scripts/init-env.sh
```

3. Iniciar los servicios:
```bash
docker compose up -d
```

4. Configurar n8n automáticamente:
```bash
./scripts/setup-n8n-complete.sh
```

## Scripts de Mantenimiento

### Inicialización del Entorno
```bash
./scripts/init-env.sh
```
- Genera claves de seguridad aleatorias
- Crea el archivo .env con todas las variables necesarias
- Establece permisos correctos en el archivo .env
- Muestra las credenciales generadas

### Setup Completo de n8n
```bash
./scripts/setup-n8n-complete.sh
```
- Importa 5 workflows automáticamente
- Crea 5 credenciales automáticamente
- Ahorro del 96% de tiempo (~80 min → 3 min)

### Backup de Datos
```bash
sudo ./scripts/backup-data.sh
```
- Realiza backup de todos los datos excepto Ollama
- Incluye archivos de configuración
- Mantiene los últimos 4 backups
- Genera archivo de metadatos
- Nota: Los modelos de Ollama se omiten del backup

### Restauración de Datos
```bash
sudo ./scripts/restore-data.sh ./backups/backup_YYYYMMDD_HHMMSS
```
- Restaura datos desde un backup específico
- Ajusta permisos automáticamente
- Reinicia los servicios
- Nota: Requiere descargar nuevamente los modelos de Ollama

## Servicios Disponibles

### Ollama (Modelos de IA)
- **URL**: `http://localhost:11434`
- **Versión**: 0.6.7
- **Configuración**: 
  - Host: `0.0.0.0`
  - Puerto: `11434`
  - Volumen persistente: `./ollama/data`

### OpenWebUI (Interfaz Web para Ollama)
- **URL**: `http://localhost:8080`
- **Versión**: latest
- **Configuración**:
  - Base de datos: SQLite
  - Conexión a Ollama: `http://host.docker.internal:11434/api`
  - Redis: Integrado para caché
  - Volumen persistente: `./openwebui/data`

### n8n (Automatización)
- **URL**: `http://localhost:5678`
- **Versión**: latest
- **Configuración**:
  - Base de datos: PostgreSQL (n8n_db)
  - Redis: Integrado para jobs
  - 5 workflows incluidos
  - 5 credenciales pre-configuradas
  - Volumen persistente: `./n8n/data`

### Flowise (Aplicación Principal)
- **URL**: `http://localhost:3000`
- **Configuración**:
  - Base de datos: PostgreSQL (ailab)
  - Vector DB: Qdrant
  - Redis: Integrado para cache
  - Volumen persistente: `./floowise/data`

### PostgreSQL (Base de Datos)
- **Puerto**: 5432
- **Versión**: 16
- **Configuración**:
  - Usuario root: definido en .env
  - Usuario no root: definido en .env
  - Volumen persistente: ./postgres/data

### Qdrant (Base de Datos Vectorial)
- **URL**: `http://localhost:6333`
- **Versión**: latest
- **Configuración**:
  - Puerto: `6333`
  - API Key: generada automáticamente
  - Volumen persistente: `./qdrant/data`

### Redis (Caché y Mensajería)
- **Puerto**: `6379`
- **Versión**: alpine
- **Configuración**:
  - Autenticación: habilitada
  - Volumen persistente: `./redis/data`
  - Usado por: OpenWebUI, n8n, Flowise

## Gestión de Datos

### Volúmenes Persistentes
Todos los datos se almacenan en volúmenes locales:
- PostgreSQL: ./postgres/data
- Qdrant: ./qdrant/data
- Ollama: ./ollama/data
- n8n: ./n8n/data
- Floowise: ./floowise/data
- OpenWebUI: ./openwebui/data

### Reinicio de Servicios
Para reiniciar todos los servicios:
```bash
docker compose down && docker compose up -d
```

Para reiniciar un servicio específico:
```bash
docker compose restart <nombre-servicio>
```

## Solución de Problemas

### Problemas de Conexión
Si hay problemas de conexión entre servicios:
1. Verificar que todos los contenedores estén en ejecución:
```bash
docker compose ps
```

2. Verificar los logs de un servicio específico:
```bash
docker compose logs <nombre-servicio>
```

3. Ver documentación de troubleshooting:
   - [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Problemas comunes
   - [docs/REDIS_FIX.md](docs/REDIS_FIX.md) - Solución Redis/OpenWebUI

### Problemas con n8n
- Si hay problemas con la clave de encriptación, verificar que `N8N_ENCRYPTION_KEY` esté correctamente configurada en `.env`
- Para problemas con workflows o credenciales, ver [docs/N8N_API_SETUP.md](docs/N8N_API_SETUP.md)
- Para automatización completa, ver [docs/COMPLETE_AUTOMATION.md](docs/COMPLETE_AUTOMATION.md)

## 📝 Notas de Actualización

### Versión 2.0.0 (12 de octubre de 2025)

**✨ Reorganización Completa:**
- 📚 Documentación movida a `docs/` (17 archivos)
- 🔐 Archivos sensibles en `config/`
- 💾 Backups organizados en `backups/`
- 📖 READMEs contextuales en cada carpeta

**🤖 Automatización 96%:**
- ✅ Auto-importación de workflows n8n
- ✅ Auto-creación de credenciales
- ✅ Script maestro `setup-n8n-complete.sh`
- ⏱️ Ahorro: ~80 min → 3 min

**🔧 Correcciones Técnicas:**
- ✅ Fix autenticación Redis en OpenWebUI
- ✅ Scripts actualizados con nuevas rutas
- ✅ `.gitignore` optimizado por categorías

**📚 Documentación Nueva:**
- `PROJECT_SUMMARY.md` - Resumen ejecutivo
- `PROJECT_STRUCTURE.md` - Estructura detallada
- `FINAL_REPORT.md` - Reporte completo
- `REDIS_FIX.md` - Solución problema Redis
- `COMPLETE_AUTOMATION.md` - Guía automatización
- Y 8 documentos adicionales

Ver [CHANGELOG.md](CHANGELOG.md) para historial completo.

## 🤖 Automatización de n8n

### Setup Automático Completo

El proyecto incluye **automatización completa** para configurar n8n en segundos:

```bash
# Configuración completa automática (workflows + credenciales)
./scripts/setup-n8n-complete.sh
```

Este comando ejecuta automáticamente:
- ✅ Importación de 5 workflows
- ✅ Creación de 5 credenciales
- ✅ Validación de disponibilidad
- ✅ Reporte detallado

**Ahorro de tiempo: ~25 minutos → 15 segundos (99%)**

### Scripts Individuales

```bash
# Solo workflows
./scripts/auto-import-n8n-workflows.sh

# Solo credenciales
./scripts/auto-import-n8n-credentials.sh
```

### Requisito Previo

**Primera vez solamente:** Genera una API Key en n8n

1. Accede a: `http://localhost:5678`
2. Ve a: `Settings → API`
3. Crea una API Key
4. Ejecuta: `./scripts/auto-import-n8n-workflows.sh "tu-api-key"`

La API Key se guarda automáticamente para futuros usos.

### Workflows Incluidos

| Workflow | Descripción |
|----------|-------------|
| AI Chatbot with Memory | Chatbot con memoria usando Qdrant |
| Document Processing Automation | Procesamiento automático de documentos |
| AI Document Processing | Pipeline de procesamiento de documentos |
| Intelligent Query System (ES/EN) | Sistema inteligente de consultas |

### Credenciales Creadas

| Credencial | Servicio |
|------------|----------|
| PostgreSQL Main | Base de datos n8n_db |
| Redis Main | Cache y sesiones |
| Ollama API | Modelos de IA |
| Flowise API | Workflows de IA |
| Qdrant | Base de datos vectorial |

### Documentación Completa

Ver documentación detallada en:
- [docs/COMPLETE_AUTOMATION.md](docs/COMPLETE_AUTOMATION.md) - Guía completa de automatización
- [docs/N8N_API_SETUP.md](docs/N8N_API_SETUP.md) - Configuración de API Key
- [docs/WORKFLOW_IMPORT_SUCCESS.md](docs/WORKFLOW_IMPORT_SUCCESS.md) - Resultados de importación
- [docs/README.md](docs/README.md) - Índice completo de documentación

## 📚 Documentación

El proyecto incluye documentación completa en la carpeta `docs/`:

### Para Empezar
- [PROJECT_SUMMARY.md](docs/PROJECT_SUMMARY.md) - ⭐ Resumen ejecutivo
- [QUICKSTART.md](docs/QUICKSTART.md) - Guía rápida
- [CREDENTIALS.md](docs/CREDENTIALS.md) - Credenciales del sistema

### Para Desarrolladores
- [PROJECT_STRUCTURE.md](docs/PROJECT_STRUCTURE.md) - Estructura del proyecto
- [COMPLETE_AUTOMATION.md](docs/COMPLETE_AUTOMATION.md) - Automatización
- [CONTRIBUTING.md](docs/CONTRIBUTING.md) - Guía de contribución
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Solución de problemas

### Documentación Técnica
- [OLLAMA.md](docs/OLLAMA.md) - Configuración de Ollama
- [FLOOWISE.md](docs/FLOOWISE.md) - Configuración de Flowise
- [INTEGRACIONES.md](docs/INTEGRACIONES.md) - Integraciones entre servicios
- [REDIS_FIX.md](docs/REDIS_FIX.md) - Solución problema Redis

Ver índice completo en [docs/README.md](docs/README.md)

## 🤝 Contribuir

Las contribuciones son bienvenidas. Ver [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) para guía detallada.

1. Fork el repositorio
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Autores

- **Edisson Giraldo** - [EdissonGirald0](https://github.com/EdissonGirald0)

## 🙏 Agradecimientos

- Comunidad de Docker
- Proyecto Ollama
- Proyecto n8n
- Comunidad Open Source

---

**Desarrollado con ❤️ por Edisson Giraldo** 