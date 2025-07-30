# Laboratorio AI Local

[![GitHub Actions](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml/badge.svg)](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-green.svg)](LICENSE)

## 🛠️ Tecnologías

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Qdrant](https://img.shields.io/badge/Qdrant-FF6B6B?style=for-the-badge&logo=qdrant&logoColor=white)](https://qdrant.tech/)
[![Ollama](https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white)](https://ollama.ai/)
[![N8N](https://img.shields.io/badge/N8N-EA4B71?style=for-the-badge&logo=n8n&logoColor=white)](https://n8n.io/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
[![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://sqlite.org/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)

## 📋 Información del Repositorio

Este repositorio contiene la configuración y scripts necesarios para desplegar un laboratorio de Inteligencia Artificial local utilizando Docker. El proyecto está diseñado para proporcionar un entorno completo y aislado para experimentar con diferentes modelos de IA y herramientas de procesamiento de datos.

## 🏗️ Arquitectura del Sistema

```mermaid
graph TB
    subgraph Network [Red Docker laboratorio_ai]
        subgraph Frontend [Frontend Layer]
            UI[OpenWebUI<br/>Puerto 8080]
            N8N[N8N<br/>Puerto 5678]
            FW[Floowise<br/>Puerto 3000]
        end
        
        subgraph AI [AI Layer]
            OL[Ollama<br/>Puerto 11434]
        end
        
        subgraph Data [Data Layer]
            PG[(PostgreSQL<br/>Puerto 5432)]
            QD[(Qdrant Vector DB<br/>Puerto 6333)]
        end
        
        subgraph Storage [Storage Layer]
            VOL1[postgres_data]
            VOL2[qdrant_data]
            VOL3[ollama_data]
            VOL4[openwebui_data]
            VOL5[n8n_data]
            VOL6[floowise_data]
        end
    end
    
    USER[Usuario] --> UI
    USER --> N8N
    USER --> FW
    
    UI --> OL
    FW --> PG
    FW --> QD
    FW --> OL
    N8N --> OL
    
    PG --> VOL1
    QD --> VOL2
    OL --> VOL3
    UI --> VOL4
    N8N --> VOL5
    FW --> VOL6
    
    classDef userClass fill:#e8eaf6,stroke:#3f51b5,stroke-width:3px
    classDef frontendClass fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef aiClass fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef dataClass fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef storageClass fill:#f1f8e9,stroke:#388e3c,stroke-width:2px
    
    class USER userClass
    class UI,N8N,FW frontendClass
    class OL aiClass
    class PG,QD dataClass
    class VOL1,VOL2,VOL3,VOL4,VOL5,VOL6 storageClass
```

## 📊 Diagrama de Secuencia - Flujo de Interacción

```mermaid
sequenceDiagram
    participant U as Usuario
    participant UI as OpenWebUI
    participant OL as Ollama
    participant FW as Floowise
    participant PG as PostgreSQL
    participant QD as Qdrant
    participant N8N as N8N

    U->>UI: Accede a la interfaz web
    UI->>OL: Solicita lista de modelos
    OL-->>UI: Retorna modelos disponibles
    
    U->>UI: Envía consulta/prompt
    UI->>OL: Procesa consulta con modelo
    OL-->>UI: Retorna respuesta generada
    UI-->>U: Muestra respuesta
    
    Note over FW,QD: Procesamiento de Documentos
    U->>FW: Sube documentos para procesamiento
    FW->>QD: Genera embeddings vectoriales
    FW->>PG: Almacena metadatos
    QD-->>FW: Confirma almacenamiento
    PG-->>FW: Confirma metadatos
    FW-->>U: Confirma procesamiento exitoso
    
    Note over N8N,OL: Automatización
    U->>N8N: Configura workflow
    N8N->>OL: Ejecuta tareas automatizadas
    OL-->>N8N: Retorna resultados
    N8N-->>U: Notifica completion
```

## 🎯 Casos de Uso del Sistema

```mermaid
graph TB
    subgraph Actores
        DEV[Desarrollador]
        DATA[Data Scientist]
        USER[Usuario Final]
        ADMIN[Administrador]
    end
    
    subgraph CasosDeUso ["Casos de Uso"]
        UC1[Entrenar Modelos]
        UC2[Procesar Documentos]
        UC3[Consultar IA]
        UC4[Automatizar Workflows]
        UC5[Buscar Vectorial]
        UC6[Gestionar Datos]
        UC7[Monitorear Sistema]
        UC8[Realizar Backups]
        UC9[Configurar Servicios]
    end
    
    subgraph Sistemas
        OL_SYSTEM[Sistema Ollama]
        FW_SYSTEM[Sistema Floowise]
        UI_SYSTEM[Sistema OpenWebUI]
        N8N_SYSTEM[Sistema N8N]
        QD_SYSTEM[Sistema Qdrant]
        PG_SYSTEM[Sistema PostgreSQL]
    end
    
    DEV --> UC1
    DEV --> UC4
    DEV --> UC9
    
    DATA --> UC2
    DATA --> UC5
    DATA --> UC6
    
    USER --> UC3
    USER --> UC2
    
    ADMIN --> UC7
    ADMIN --> UC8
    ADMIN --> UC9
    
    UC1 --> OL_SYSTEM
    UC2 --> FW_SYSTEM
    UC3 --> UI_SYSTEM
    UC4 --> N8N_SYSTEM
    UC5 --> QD_SYSTEM
    UC6 --> PG_SYSTEM
    UC7 --> OL_SYSTEM
    UC7 --> FW_SYSTEM
    UC8 --> PG_SYSTEM
    UC9 --> OL_SYSTEM
    
    classDef actorClass fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef ucClass fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef systemClass fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    
    class DEV,DATA,USER,ADMIN actorClass
    class UC1,UC2,UC3,UC4,UC5,UC6,UC7,UC8,UC9 ucClass
    class OL_SYSTEM,FW_SYSTEM,UI_SYSTEM,N8N_SYSTEM,QD_SYSTEM,PG_SYSTEM systemClass
```

## 🔧 Diagrama de Componentes

```mermaid
classDiagram
    class DockerCompose {
        +string version
        +up()
        +down()
        +restart()
    }
    
    class Service {
        +string name
        +string image
        +start()
        +stop()
        +restart()
    }
    
    class PostgreSQL {
        +string version
        +int port
        +string database
        +connect()
        +query()
        +backup()
    }
    
    class Qdrant {
        +string version
        +int port
        +string apiKey
        +createCollection()
        +search()
        +insert()
    }
    
    class Ollama {
        +string version
        +int port
        +string host
        +loadModel()
        +generate()
        +listModels()
    }
    
    class OpenWebUI {
        +string version
        +int port
        +string database
        +authenticate()
        +chat()
        +manageModels()
    }
    
    class N8N {
        +string version
        +int port
        +string encryptionKey
        +createWorkflow()
        +executeWorkflow()
        +scheduleWorkflow()
    }
    
    class Floowise {
        +int port
        +createFlow()
        +processDocument()
        +executeFlow()
    }
    
    DockerCompose "1" *-- "many" Service
    Service <|-- PostgreSQL
    Service <|-- Qdrant
    Service <|-- Ollama
    Service <|-- OpenWebUI
    Service <|-- N8N
    Service <|-- Floowise
    
    OpenWebUI ..> Ollama
    Floowise ..> PostgreSQL
    Floowise ..> Qdrant
    Floowise ..> Ollama
    N8N ..> Ollama
```

## 🔄 Flujo de Configuración e Inicialización

```mermaid
flowchart TD
    START([Inicio]) --> CLONE[git clone repositorio]
    CLONE --> CHECK_DOCKER{Docker instalado?}
    CHECK_DOCKER -->|No| INSTALL_DOCKER[Instalar Docker]
    CHECK_DOCKER -->|Sí| INIT_ENV[./scripts/init-env.sh]
    INSTALL_DOCKER --> INIT_ENV
    
    INIT_ENV --> ENV_CREATED{.env creado?}
    ENV_CREATED -->|No| ENV_ERROR[Error: Revisar permisos]
    ENV_CREATED -->|Sí| BUILD_IMAGES[docker-compose build]
    
    BUILD_IMAGES --> BUILD_SUCCESS{Build exitoso?}
    BUILD_SUCCESS -->|No| BUILD_ERROR[Error: Revisar logs]
    BUILD_SUCCESS -->|Sí| START_SERVICES[docker-compose up -d]
    
    START_SERVICES --> CHECK_HEALTH[Verificar salud servicios]
    CHECK_HEALTH --> POSTGRES_OK{PostgreSQL OK?}
    POSTGRES_OK -->|No| POSTGRES_ERROR[Error PostgreSQL]
    POSTGRES_OK -->|Sí| QDRANT_OK{Qdrant OK?}
    
    QDRANT_OK -->|No| QDRANT_ERROR[Error Qdrant]
    QDRANT_OK -->|Sí| OLLAMA_OK{Ollama OK?}
    
    OLLAMA_OK -->|No| OLLAMA_ERROR[Error Ollama]
    OLLAMA_OK -->|Sí| DOWNLOAD_MODELS[Descargar modelos IA]
    
    DOWNLOAD_MODELS --> INIT_DATA[./scripts/init-data.sh]
    INIT_DATA --> READY([Sistema Listo])
    
    ENV_ERROR --> FIX_ENV[Corregir configuración]
    BUILD_ERROR --> FIX_BUILD[Revisar Dockerfile]
    POSTGRES_ERROR --> FIX_POSTGRES[Revisar configuración DB]
    QDRANT_ERROR --> FIX_QDRANT[Revisar Qdrant config]
    OLLAMA_ERROR --> FIX_OLLAMA[Revisar Ollama setup]
    
    FIX_ENV --> INIT_ENV
    FIX_BUILD --> BUILD_IMAGES
    FIX_POSTGRES --> START_SERVICES
    FIX_QDRANT --> START_SERVICES
    FIX_OLLAMA --> START_SERVICES
    
    classDef successNode fill:#e8f5e8,stroke:#4caf50,stroke-width:2px
    classDef errorNode fill:#ffebee,stroke:#f44336,stroke-width:2px
    classDef processNode fill:#e3f2fd,stroke:#2196f3,stroke-width:2px
    
    class START,READY successNode
    class ENV_ERROR,BUILD_ERROR,POSTGRES_ERROR,QDRANT_ERROR,OLLAMA_ERROR errorNode
    class CLONE,INIT_ENV,BUILD_IMAGES,START_SERVICES,CHECK_HEALTH,DOWNLOAD_MODELS,INIT_DATA processNode
```

## 🌐 Diagrama de Red y Comunicación

```mermaid
graph TB
    subgraph HostSystem [Host System]
        HOST[Docker Engine]
        PORTS[Puertos Expuestos]
    end
    
    subgraph DockerNetwork [Docker Network laboratorio_ai]
        subgraph Frontend [Frontend Services]
            UI[OpenWebUI 8080]
            N8N[N8N 5678]
            FW[Floowise 3000]
        end
        
        subgraph Backend [Backend Services]
            OL[Ollama 11434]
            PG[PostgreSQL 5432]
            QD[Qdrant 6333]
        end
    end
    
    subgraph Storage [External Storage]
        VOL_PG[postgres_data]
        VOL_QD[qdrant_data]
        VOL_OL[ollama_data]
        VOL_UI[openwebui_data]
        VOL_N8N[n8n_data]
        VOL_FW[floowise_data]
    end
    
    HOST --> UI
    HOST --> N8N
    HOST --> FW
    HOST --> QD
    HOST --> OL
    
    UI -.->|HTTP API| OL
    FW -.->|SQL| PG
    FW -.->|Vector API| QD
    FW -.->|HTTP API| OL
    N8N -.->|HTTP API| OL
    
    PG -.->|Mount| VOL_PG
    QD -.->|Mount| VOL_QD
    OL -.->|Mount| VOL_OL
    UI -.->|Mount| VOL_UI
    N8N -.->|Mount| VOL_N8N
    FW -.->|Mount| VOL_FW
    
    classDef hostClass fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef frontendClass fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef backendClass fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef storageClass fill:#f5f5f5,stroke:#757575,stroke-width:2px
    
    class HOST,PORTS hostClass
    class UI,N8N,FW frontendClass
    class OL,PG,QD backendClass
    class VOL_PG,VOL_QD,VOL_OL,VOL_UI,VOL_N8N,VOL_FW storageClass
```

### 🚀 Características Principales

- **Entorno Aislado**: Todos los servicios se ejecutan en contenedores Docker
- **Fácil Configuración**: Scripts automatizados para la configuración inicial
- **Backup Automático**: Sistema de respaldo para datos y configuraciones
- **Seguridad**: Configuración segura por defecto
- **Escalabilidad**: Fácil de extender con nuevos servicios

### 🛠️ Tecnologías Utilizadas

- Docker y Docker Compose
- PostgreSQL para almacenamiento de datos
- Qdrant para búsqueda vectorial
- Ollama para modelos de lenguaje local
- N8N para automatización
- Floowise para procesamiento de datos
- OpenWebUI para interfaz web

### 📦 Estructura del Repositorio

```
laboratorioAI/
├── .github/                    # Configuración de GitHub Actions
├── scripts/                    # Scripts de mantenimiento
├── postgres/                   # Configuración de PostgreSQL
├── qdrant/                     # Configuración de Qdrant
├── ollama/                     # Configuración de Ollama
├── n8n/                        # Configuración de N8N
├── floowise/                   # Configuración de Floowise
├── openwebui/                  # Configuración de OpenWebUI
├── docker-compose.yml          # Configuración de Docker Compose
├── .gitignore                  # Archivos ignorados por Git
├── LICENSE                     # Licencia del proyecto
└── README.md                   # Este archivo
```

## Requisitos Previos

- Docker y Docker Compose
- Git
- Sistema operativo Linux (recomendado Ubuntu 22.04 o superior)
- Mínimo 16GB de RAM
- 50GB de espacio en disco
- GPU compatible con CUDA (opcional, pero recomendado)

## Estructura del Proyecto

```
.
├── README.md                 # Documentación del proyecto
├── docker-compose.yml        # Configuración de servicios Docker
├── .gitignore               # Archivos ignorados por Git
├── LICENSE                  # Licencia del proyecto
├── scripts/                 # Scripts de mantenimiento y configuración
│   ├── init-env.sh         # Generación de variables de entorno
│   ├── init-data.sh        # Inicialización de bases de datos
│   ├── backup-data.sh      # Backup de datos y configuración
│   └── restore-data.sh     # Restauración desde backups
├── backups/                # Directorio de respaldos
├── postgres/              # Datos de PostgreSQL
│   └── data/
├── qdrant/               # Datos de Qdrant
│   └── data/
├── ollama/              # Datos de Ollama
│   └── data/
├── n8n/                 # Datos de n8n
│   └── data/
├── floowise/            # Datos de Floowise
│   └── data/
└── openwebui/           # Datos de OpenWebUI
    └── data/
```

## Configuración Inicial

1. Clonar el repositorio:
```bash
git clone <url-del-repositorio>
cd laboratorio-ai
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
- **URL**: http://localhost:11434
- **Versión**: 0.6.7
- **Configuración**: 
  - Host: 0.0.0.0
  - Puerto: 11434
  - Volumen persistente: ./ollama/data

### OpenWebUI (Interfaz Web para Ollama)
- **URL**: http://localhost:8080
- **Versión**: v0.6.13
- **Configuración**:
  - Base de datos: SQLite
  - Conexión a Ollama: http://host.docker.internal:11434/api
  - Volumen persistente: ./openwebui/data

### n8n (Automatización)
- **URL**: http://localhost:5678
- **Versión**: latest (1.97.1)
- **Configuración**:
  - Modo: development
  - Gestión de usuarios: deshabilitada
  - Diagnósticos: deshabilitados
  - Métricas: deshabilitadas
  - Archivos de configuración: deshabilitados

### Floowise (Aplicación Principal)
- **URL**: http://localhost:3000
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
