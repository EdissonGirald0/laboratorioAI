# Laboratorio AI Local

[![GitHub Actions](https://github.com/Ediss## 🔄 Estado del Sistemairald0/laboratorioAI/actions/workflows/main.y### 🤝 Contribuir

Para contribuir al proyecto:

1. Haz fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### 📝 Licenciag)](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-green.svg)](LICENSE)

## 📋 Información del Repositorio

Este repositorio contiene la configuración y scripts necesarios para desplegar un laboratorio de Inteligencia Artificial local utilizando Docker. El proyecto está diseñado para proporcionar un entorno completo y aislado para experimentar con diferentes modelos de IA y herramientas de procesamiento de datos.

### 📁 Estructura del Proyecto

```
laboratorioAI/
├── data/
│   ├── postgres/
│   ├── qdrant/
│   ├── ollama/
│   ├── n8n/
│   ├── floowise/
│   ├── openwebui/
│   └── redis/
├── scripts/
│   ├── init-env.sh
│   ├── backup-data.sh
│   └── restore-data.sh
└── .devcontainer/
    └── post-create.sh
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

## � Estado del Sistema

Este repositorio contiene la configuración y scripts necesarios para desplegar un laboratorio de Inteligencia Artificial local utilizando Docker. El proyecto está diseñado para proporcionar un entorno completo y aislado para experimentar con diferentes modelos de IA y herramientas de procesamiento de datos.

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

### 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor, lee nuestras guías de contribución antes de enviar un pull request:

1. Haz fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

### 👥 Autores

- **Edisson Giraldo** - *Desarrollo inicial* - [EdissonGirald0](https://github.com/EdissonGirald0)

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
docker-compose up -d
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

### Inicialización de Bases de Datos
```bash
./scripts/init-data.sh
```
- Crea usuarios y roles en PostgreSQL
- Establece permisos necesarios
- Configura la base de datos inicial

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
- **Versión**: v0.6.13
- **Configuración**:
  - Base de datos: SQLite
  - Conexión a Ollama: http://host.docker.internal:11434/api
  - Volumen persistente: ./openwebui/data

### n8n (Automatización)
- **URL**: `http://localhost:5678`
- **Versión**: latest (1.97.1)
- **Configuración**:
  - Modo: `development`
  - Gestión de usuarios: deshabilitada
  - Diagnósticos: deshabilitados
  - Métricas: deshabilitadas
  - Archivos de configuración: deshabilitados
  - Volumen persistente: `./n8n/data`

### Floowise (Aplicación Principal)
- **URL**: `http://localhost:3000`
- **Configuración**:
  - Base de datos: PostgreSQL
  - Vector DB: Qdrant
  - Volumen persistente: ./floowise/data

### PostgreSQL (Base de Datos)
- **Puerto**: 5432
- **Versión**: 16
- **Configuración**:
  - Usuario root: definido en .env
  - Usuario no root: definido en .env
  - Volumen persistente: ./postgres/data

### Qdrant (Base de Datos Vectorial)
- **URL**: http://localhost:6333
- **Versión**: latest
- **Configuración**:
  - Puerto: 6333
  - API Key: generada automáticamente
  - Volumen persistente: ./qdrant/data

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
docker-compose down && docker-compose up -d
```

Para reiniciar un servicio específico:
```bash
docker-compose restart <nombre-servicio>
```

## Solución de Problemas

### Problemas de Conexión
Si hay problemas de conexión entre servicios:
1. Verificar que todos los contenedores estén en ejecución:
```bash
docker-compose ps
```

2. Verificar los logs de un servicio específico:
```bash
docker-compose logs <nombre-servicio>
```

### Problemas con n8n
- Si hay problemas con la clave de encriptación, verificar que N8N_ENCRYPTION_KEY esté correctamente configurada en .env
- Los task runners están deshabilitados por defecto, pero se recomienda habilitarlos en futuras versiones

## Notas de Actualización

### Cambios Recientes
- Movidos scripts de inicialización a la carpeta scripts/
- Mejorado el sistema de backup y restauración
- Omitidos los datos de Ollama del backup
- Agregada generación automática de API Key para Qdrant
- Optimizada la gestión de permisos en los scripts

## Contribuir

1. Fork el repositorio
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles. 