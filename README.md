# Laboratorio AI Local

[![GitHub Actions](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml/badge.svg)](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-green.svg)](LICENSE)

## 🛠️ Tecnologías

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)](https://redis.io/)
[![Qdrant](https://img.shields.io/badge/Qdrant-FF6B6B?style=for-the-badge&logo=qdrant&logoColor=white)](https://qdrant.tech/)
[![Ollama](https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white)](https://ollama.ai/)
[![N8N](https://img.shields.io/badge/N8N-EA4B71?style=for-the-badge&logo=n8n&logoColor=white)](https://n8n.io/)
[![Floowise](https://img.shields.io/badge/Floowise-6B73FF?style=for-the-badge&logo=flow&logoColor=white)](https://flowiseai.com/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org/)
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
[![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](https://sqlite.org/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)

## 📋 Información del Repositorio

Este repositorio contiene la configuración y scripts necesarios para desplegar un laboratorio de Inteligencia Artificial local utilizando Docker. El proyecto está diseñado para proporcionar un entorno completo y aislado para experimentar con diferentes modelos de IA y herramientas de procesamiento de datos.

## 🚀 Nuevas Funcionalidades v2.0 - Automatizaciones IA

### 🤖 Sistema Completo de Automatizaciones N8N
- **4 Workflows preconfigurados** para procesamiento automático de IA
- **Integración completa** con PostgreSQL, Redis, Qdrant y Ollama
- **APIs REST** listas para usar con endpoints especializados
- **Configuración automática** con scripts de instalación y pruebas

### ⚡ Cache y Performance con Redis
- **Sistema de colas** para tareas en background
- **Cache inteligente** para resultados de IA
- **Optimización de rendimiento** para consultas frecuentes
- **Persistencia configurable** con AOF

### 🧠 Procesamiento Inteligente de Documentos
- **Embeddings automáticos** con modelos Ollama
- **Almacenamiento vectorial** en Qdrant
- **Búsqueda semántica** avanzada
- **Metadatos estructurados** en PostgreSQL

### 😊 Análisis de Sentimientos y Emociones
- **Machine Learning** para análisis de texto
- **Detección de emociones** y tonos
- **Analytics detallados** con métricas
- **Soporte multiidioma**

### 🏥 Monitoreo y Alertas Automáticas
- **Verificación continua** de salud del sistema
- **Alertas inteligentes** por fallos o degradación
- **Dashboard en tiempo real** de métricas
- **Logs estructurados** para análisis

## 🏗️ Arquitectura del Sistema

```mermaid
graph TB
    subgraph Network ["Red Docker laboratorio_ai"]
        subgraph Frontend ["Frontend Layer"]
            UI["OpenWebUI Puerto 8080"]
            N8N["N8N Automation Puerto 5678"]
            FW["Floowise Puerto 3000"]
        end
        
        subgraph AI ["AI Layer"]
            OL["Ollama Puerto 11434"]
        end
        
        subgraph Data ["Data Layer"]
            PG[("PostgreSQL Puerto 5432")]
            RD[("Redis Cache Puerto 6379")]
            QD[("Qdrant Vector DB Puerto 6333")]
        end
        
        subgraph Storage ["Storage Layer"]
            VOL1["postgres_data"]
            VOL2["qdrant_data"]
            VOL3["ollama_data"]
            VOL4["openwebui_data"]
            VOL5["n8n_data"]
            VOL6["floowise_data"]
            VOL7["redis_data"]
        end
        
        subgraph Automation ["N8N Workflows"]
            WF1["Document Processing"]
            WF2["Intelligent Query"]
            WF3["Sentiment Analysis"]
            WF4["System Monitoring"]
        end
    end
    
    USER["Usuario"] --> UI
    USER --> N8N
    USER --> FW
    
    UI --> OL
    FW --> PG
    FW --> QD
    FW --> OL
    
    N8N --> OL
    N8N --> PG
    N8N --> RD
    N8N --> QD
    N8N --> WF1
    N8N --> WF2
    N8N --> WF3
    N8N --> WF4
    
    PG --> VOL1
    QD --> VOL2
    OL --> VOL3
    UI --> VOL4
    N8N --> VOL5
    FW --> VOL6
    RD --> VOL7
    
    classDef userClass fill:#e8eaf6,stroke:#3f51b5,stroke-width:3px
    classDef frontendClass fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef aiClass fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef dataClass fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef storageClass fill:#f1f8e9,stroke:#388e3c,stroke-width:2px
    classDef automationClass fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    
    class USER userClass
    class UI,N8N,FW frontendClass
    class OL aiClass
    class PG,RD,QD dataClass
    class VOL1,VOL2,VOL3,VOL4,VOL5,VOL6,VOL7 storageClass
    class WF1,WF2,WF3,WF4 automationClass
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
    participant RD as Redis

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
    
    Note over N8N,RD: Automatizaciones IA
    U->>N8N: Webhook de documento
    N8N->>OL: Genera embeddings
    N8N->>QD: Almacena vectores
    N8N->>PG: Guarda metadatos
    N8N->>RD: Cache resultado
    N8N-->>U: Respuesta con document_id
    
    U->>N8N: Consulta inteligente
    N8N->>OL: Embedding de consulta
    N8N->>QD: Búsqueda vectorial
    N8N->>OL: Genera respuesta IA
    N8N->>PG: Log de consulta
    N8N-->>U: Respuesta contextual
    
    U->>N8N: Análisis de sentimientos
    N8N->>OL: Procesa texto con IA
    N8N->>PG: Guarda análisis
    N8N->>RD: Cache por 1 hora
    N8N-->>U: Resultado de sentimiento
```

## 🔄 Flujo de Automatizaciones N8N

```mermaid
graph TB
    subgraph Triggers ["Disparadores"]
        WH1["Webhook Documentos"]
        WH2["Webhook Consultas"]
        WH3["Webhook Sentimientos"]
        CRON["Monitoreo cada 5min"]
    end
    
    subgraph Processing ["Procesamiento"]
        PREP["Preparar Datos"]
        EMB["Generar Embeddings"]
        SEARCH["Búsqueda Vectorial"]
        AI["Análisis con IA"]
        HEALTH["Verificar Salud"]
    end
    
    subgraph Storage ["Almacenamiento"]
        QD_STORE["Qdrant Vectores"]
        PG_STORE["PostgreSQL Logs"]
        RD_CACHE["Redis Cache"]
    end
    
    subgraph Responses ["Respuestas"]
        DOC_RESP["Document ID"]
        QUERY_RESP["Respuesta IA"]
        SENT_RESP["Análisis Sentimiento"]
        ALERT["Alertas Sistema"]
    end
    
    WH1 --> PREP
    WH2 --> PREP
    WH3 --> PREP
    CRON --> HEALTH
    
    PREP --> EMB
    PREP --> AI
    EMB --> SEARCH
    
    EMB --> QD_STORE
    AI --> PG_STORE
    SEARCH --> RD_CACHE
    HEALTH --> PG_STORE
    
    QD_STORE --> DOC_RESP
    SEARCH --> QUERY_RESP
    AI --> SENT_RESP
    HEALTH --> ALERT
    
    classDef triggerClass fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef processClass fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef storageClass fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef responseClass fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    
    class WH1,WH2,WH3,CRON triggerClass
    class PREP,EMB,SEARCH,AI,HEALTH processClass
    class QD_STORE,PG_STORE,RD_CACHE storageClass
    class DOC_RESP,QUERY_RESP,SENT_RESP,ALERT responseClass
```

## 🔗 Integración de Servicios N8N

```mermaid
graph LR
    subgraph N8N_Core [N8N Core]
        EXECUTOR[Workflow Executor]
        SCHEDULER[Task Scheduler]
        QUEUE[Queue Manager]
    end
    
    subgraph External_Services [Servicios Externos]
        OLLAMA[Ollama API]
        POSTGRES[PostgreSQL DB]
        REDIS[Redis Cache]
        QDRANT[Qdrant Vector DB]
    end
    
    subgraph Workflows [Workflows Activos]
        WF_DOC[Document Processing]
        WF_QUERY[Intelligent Query]
        WF_SENTIMENT[Sentiment Analysis]
        WF_HEALTH[System Health]
    end
    
    EXECUTOR --> WF_DOC
    EXECUTOR --> WF_QUERY
    EXECUTOR --> WF_SENTIMENT
    SCHEDULER --> WF_HEALTH
    
    WF_DOC --> OLLAMA
    WF_DOC --> QDRANT
    WF_DOC --> POSTGRES
    
    WF_QUERY --> OLLAMA
    WF_QUERY --> QDRANT
    WF_QUERY --> POSTGRES
    
    WF_SENTIMENT --> OLLAMA
    WF_SENTIMENT --> POSTGRES
    WF_SENTIMENT --> REDIS
    
    WF_HEALTH --> POSTGRES
    WF_HEALTH --> REDIS
    WF_HEALTH --> QDRANT
    WF_HEALTH --> OLLAMA
    
    QUEUE --> REDIS
    
    classDef n8nClass fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    classDef serviceClass fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef workflowClass fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    
    class EXECUTOR,SCHEDULER,QUEUE n8nClass
    class OLLAMA,POSTGRES,REDIS,QDRANT serviceClass
    class WF_DOC,WF_QUERY,WF_SENTIMENT,WF_HEALTH workflowClass
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
        UC1["Entrenar Modelos"]
        UC2["Procesar Documentos"]
        UC3["Consultar IA"]
        UC4["Automatizar Workflows"]
        UC5["Buscar Vectorial"]
        UC6["Gestionar Datos"]
        UC7["Monitorear Sistema"]
        UC8["Realizar Backups"]
        UC9["Configurar Servicios"]
    end
    
    subgraph Sistemas
        OL_SYSTEM[Sistema Ollama]
        FW_SYSTEM[Sistema Floowise]
        UI_SYSTEM[Sistema OpenWebUI]
        N8N_SYSTEM[Sistema N8N]
        QD_SYSTEM[Sistema Qdrant]
        PG_SYSTEM[Sistema PostgreSQL]
        RD_SYSTEM[Sistema Redis]
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
    UC7 --> RD_SYSTEM
    UC8 --> PG_SYSTEM
    UC9 --> OL_SYSTEM
    
    classDef actorClass fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef ucClass fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef systemClass fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    
    class DEV,DATA,USER,ADMIN actorClass
    class UC1,UC2,UC3,UC4,UC5,UC6,UC7,UC8,UC9 ucClass
    class OL_SYSTEM,FW_SYSTEM,UI_SYSTEM,N8N_SYSTEM,QD_SYSTEM,PG_SYSTEM,RD_SYSTEM systemClass
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
    
    class Redis {
        +string version
        +int port
        +string password
        +set()
        +get()
        +expire()
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
    Service <|-- Redis
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
    N8N ..> PostgreSQL
    N8N ..> Redis
    N8N ..> Qdrant
```

## 🔄 Flujo de Configuración e Inicialización

```mermaid
flowchart TD
    START([Inicio]) --> CLONE[git clone repositorio]
    CLONE --> CHECK_DOCKER{Docker instalado?}
    CHECK_DOCKER --> INSTALL_DOCKER["Instalar Docker"]
    CHECK_DOCKER --> INIT_ENV["./scripts/init-env.sh"]
    INSTALL_DOCKER --> INIT_ENV
    
    INIT_ENV --> ENV_CREATED{.env creado?}
    ENV_CREATED --> ENV_ERROR["Error: Revisar permisos"]
    ENV_CREATED --> BUILD_IMAGES["docker-compose build"]
    
    BUILD_IMAGES --> BUILD_SUCCESS{Build exitoso?}
    BUILD_SUCCESS --> BUILD_ERROR["Error: Revisar logs"]
    BUILD_SUCCESS --> START_SERVICES["docker-compose up -d"]
    
    START_SERVICES --> CHECK_HEALTH["Verificar salud servicios"]
    CHECK_HEALTH --> POSTGRES_OK{PostgreSQL OK?}
    POSTGRES_OK --> POSTGRES_ERROR["Error PostgreSQL"]
    POSTGRES_OK --> QDRANT_OK{Qdrant OK?}
    
    QDRANT_OK --> QDRANT_ERROR["Error Qdrant"]
    QDRANT_OK --> OLLAMA_OK{Ollama OK?}
    
    OLLAMA_OK --> OLLAMA_ERROR["Error Ollama"]
    OLLAMA_OK --> DOWNLOAD_MODELS["Descargar modelos IA"]
    
    DOWNLOAD_MODELS --> INIT_DATA["./scripts/init-data.sh"]
    INIT_DATA --> READY(["Sistema Listo"])
    
    ENV_ERROR --> FIX_ENV["Corregir configuración"]
    BUILD_ERROR --> FIX_BUILD["Revisar Dockerfile"]
    POSTGRES_ERROR --> FIX_POSTGRES["Revisar configuración DB"]
    QDRANT_ERROR --> FIX_QDRANT["Revisar Qdrant config"]
    OLLAMA_ERROR --> FIX_OLLAMA["Revisar Ollama setup"]
    
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
    subgraph HostSystem ["Host System"]
        HOST["Docker Engine"]
        PORTS["Puertos Expuestos"]
    end
    
    subgraph DockerNetwork ["Docker Network laboratorio_ai"]
        subgraph Frontend ["Frontend Services"]
            UI["OpenWebUI 8080"]
            N8N["N8N 5678"]
            FW["Floowise 3000"]
        end
        
        subgraph Backend ["Backend Services"]
            OL["Ollama 11434"]
            PG["PostgreSQL 5432"]
            RD["Redis 6379"]
            QD["Qdrant 6333"]
        end
    end
    
    subgraph Storage ["External Storage"]
        VOL_PG["postgres_data"]
        VOL_RD["redis_data"]
        VOL_QD["qdrant_data"]
        VOL_OL["ollama_data"]
        VOL_UI["openwebui_data"]
        VOL_N8N["n8n_data"]
        VOL_FW["floowise_data"]
    end
    
    HOST --> UI
    HOST --> N8N
    HOST --> FW
    HOST --> QD
    HOST --> OL
    HOST --> RD
    
    UI -.->|HTTP API| OL
    FW -.->|SQL| PG
    FW -.->|Vector API| QD
    FW -.->|HTTP API| OL
    N8N -.->|HTTP API| OL
    N8N -.->|SQL| PG
    N8N -.->|Cache| RD
    N8N -.->|Vector API| QD
    
    PG -.->|Mount| VOL_PG
    RD -.->|Mount| VOL_RD
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
    class OL,PG,RD,QD backendClass
    class VOL_PG,VOL_RD,VOL_QD,VOL_OL,VOL_UI,VOL_N8N,VOL_FW storageClass
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

**⚠️ IMPORTANTE**: Debes ejecutar estos pasos en orden:

1. Clonar el repositorio:
```bash
git clone <url-del-repositorio>
cd laboratorio-ai
```

2. **OBLIGATORIO** - Generar el archivo .env:
```bash
chmod +x scripts/init-env.sh
./scripts/init-env.sh
```

3. Iniciar los servicios:
```bash
docker-compose up -d
```

**Nota**: Si ejecutas `docker-compose up -d` sin haber creado el archivo `.env` primero, verás advertencias sobre variables no configuradas. En ese caso, ejecuta el paso 2 y luego reinicia los servicios:
```bash
docker-compose down
docker-compose up -d
```

## Scripts de Mantenimiento

### Inicialización del Entorno
```bash
./scripts/init-env.sh
```
- Genera claves de seguridad aleatorias
- Crea el archivo .env con todas las variables necesarias
- **Incluye configuración de Redis** con contraseña generada automáticamente
- Establece permisos correctos en el archivo .env
- Muestra las credenciales generadas (PostgreSQL, Redis, N8N, Qdrant, OpenWebUI)

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

### Redis (Cache y Sistema de Colas)
- **Puerto**: 6379
- **Versión**: 7-alpine
- **Configuración**:
  - Persistencia: AOF habilitada
  - Contraseña: generada automáticamente en .env
  - Volumen persistente: ./redis/data
  - Usado por N8N para manejo de colas y cache

## 🤖 Automatizaciones N8N

### Configuración Automática
El laboratorio incluye un sistema completo de automatizaciones N8N preconfiguradas:

```bash
# Configurar automatizaciones N8N
./scripts/setup-n8n-automation.sh

# Probar todas las automatizaciones
./scripts/test-n8n-automations.sh
```

### Workflows Disponibles

#### 1. 📄 Procesamiento de Documentos
- **Endpoint**: `POST http://localhost:5678/webhook/document-processing`
- **Funcionalidad**: 
  - Recibe documentos vía webhook
  - Genera embeddings con Ollama
  - Almacena vectores en Qdrant
  - Guarda metadatos en PostgreSQL
- **Payload de ejemplo**:
```json
{
  "content": "Texto del documento",
  "filename": "documento.txt",
  "content_type": "text/plain",
  "metadata": {
    "author": "Usuario",
    "category": "documentos"
  }
}
```

#### 2. 🧠 Sistema de Consultas Inteligentes
- **Endpoint**: `POST http://localhost:5678/webhook/intelligent-query`
- **Funcionalidad**:
  - Procesa consultas en lenguaje natural
  - Busca información relevante en Qdrant
  - Genera respuestas contextuales con IA
  - Registra todas las consultas
- **Payload de ejemplo**:
```json
{
  "query": "¿Qué información tienes sobre machine learning?",
  "limit": 5,
  "threshold": 0.7
}
```

#### 3. 😊 Análisis de Sentimientos
- **Endpoint**: `POST http://localhost:5678/webhook/sentiment-analysis`
- **Funcionalidad**:
  - Analiza sentimientos en texto
  - Identifica emociones y tonos
  - Cache de resultados en Redis
  - Analytics y métricas detalladas
- **Payload de ejemplo**:
```json
{
  "text": "Me encanta este laboratorio de IA!",
  "language": "es",
  "source": "usuario",
  "user_id": "usuario123"
}
```

#### 4. 🏥 Monitoreo del Sistema
- **Funcionalidad**:
  - Verificación automática cada 5 minutos
  - Monitoreo de salud de todos los servicios
  - Alertas automáticas por fallos
  - Dashboard de métricas en tiempo real
- **Servicios monitoreados**:
  - PostgreSQL
  - Redis
  - Qdrant
  - Ollama
  - OpenWebUI

### Integraciones de Base de Datos

#### PostgreSQL
Las automatizaciones crean y utilizan las siguientes tablas:

```sql
-- Logs de consultas inteligentes
CREATE TABLE query_logs (
    query_id VARCHAR(255) PRIMARY KEY,
    original_query TEXT,
    documents_found INTEGER,
    response_generated TEXT,
    timestamp TIMESTAMP
);

-- Análisis de sentimientos
CREATE TABLE sentiment_analysis (
    analysis_id VARCHAR(255) PRIMARY KEY,
    original_text TEXT,
    overall_sentiment VARCHAR(20),
    confidence_score DECIMAL(5,3),
    emotional_indicators JSONB,
    created_at TIMESTAMP
);

-- Documentos procesados
CREATE TABLE processed_documents (
    document_id VARCHAR(255) PRIMARY KEY,
    filename VARCHAR(255),
    content_type VARCHAR(100),
    qdrant_point_id VARCHAR(255),
    processed_at TIMESTAMP
);

-- Logs de salud del sistema
CREATE TABLE system_health_logs (
    check_id VARCHAR(255) PRIMARY KEY,
    overall_health VARCHAR(20),
    service_details JSONB,
    timestamp TIMESTAMP
);
```

#### Redis Cache
Redis se utiliza para:
- **Sistema de colas N8N**: Manejo de tareas en background
- **Cache de sentimientos**: Resultados de análisis con TTL de 1 hora
- **Estado del sistema**: Última verificación de salud (TTL 10 minutos)
- **Métricas en tiempo real**: Contadores y estadísticas

### APIs de Automatización

#### Verificar Estado de Automatizaciones
```bash
# Ver workflows activos
curl http://localhost:5678/api/v1/workflows

# Ver ejecuciones recientes
curl http://localhost:5678/api/v1/executions

# Ver estado de salud del sistema
redis-cli -p 6379 -a <REDIS_PASSWORD> GET system:health:latest
```

#### Ejemplos de Uso

##### Procesar un documento
```bash
curl -X POST http://localhost:5678/webhook/document-processing \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Machine Learning es una rama de la inteligencia artificial...",
    "filename": "ml-intro.txt",
    "content_type": "text/plain"
  }'
```

##### Hacer una consulta inteligente
```bash
curl -X POST http://localhost:5678/webhook/intelligent-query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Explícame qué es Machine Learning",
    "limit": 3
  }'
```

##### Analizar sentimiento
```bash
curl -X POST http://localhost:5678/webhook/sentiment-analysis \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Este laboratorio es increíble, me encanta trabajar con IA!",
    "language": "es"
  }'
```

### Métricas y Monitoreo

#### Dashboard de Salud
Accede a métricas en tiempo real:
- **N8N Dashboard**: http://localhost:5678
- **PostgreSQL**: Consultas a las tablas de logs
- **Redis**: Comandos INFO y MONITOR
- **Sistema**: Logs automáticos cada 5 minutos

#### Alertas Automáticas
El sistema genera alertas automáticas cuando:
- Servicios están inactivos
- Errores en procesamiento
- Rendimiento degradado
- Fallos de conectividad

## Gestión de Datos

### Volúmenes Persistentes
Todos los datos se almacenan en volúmenes locales:
- **PostgreSQL**: ./postgres/data
- **Redis**: ./redis/data
- **Qdrant**: ./qdrant/data
- **Ollama**: ./ollama/data
- **N8N**: ./n8n/data (incluye workflows y credenciales)
- **Floowise**: ./floowise/data
- **OpenWebUI**: ./openwebui/data

### Directorios de Configuración
- **N8N Workflows**: ./n8n/workflows/ (automatizaciones preconfiguradas)
- **N8N Credentials**: ./n8n/credentials/ (credenciales de servicios)
- **PostgreSQL Scripts**: ./postgres/init-scripts/ (esquemas de BD)
- **Scripts de Automatización**: ./scripts/ (configuración y pruebas)

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

3. Verificar conectividad de red:
```bash
docker network inspect laboratorio_ai
```

### Problemas con N8N
- Si hay problemas con la clave de encriptación, verificar que N8N_ENCRYPTION_KEY esté correctamente configurada en .env
- Para reiniciar workflows: `docker-compose restart n8n`
- Verificar logs de N8N: `docker-compose logs n8n`
- Verificar conexiones a PostgreSQL y Redis en las credenciales

### Problemas con Redis
- Verificar conexión: `docker exec laboratorioai-redis-1 redis-cli -a <REDIS_PASSWORD> ping`
- Ver uso de memoria: `docker exec laboratorioai-redis-1 redis-cli -a <REDIS_PASSWORD> info memory`
- Limpiar cache: `docker exec laboratorioai-redis-1 redis-cli -a <REDIS_PASSWORD> flushall`

### Problemas con Automatizaciones
- Ejecutar script de pruebas: `./scripts/test-n8n-automations.sh`
- Verificar logs de workflows en N8N dashboard
- Reiniciar configuración: `./scripts/setup-n8n-automation.sh`
- Verificar estado de servicios: `curl http://localhost:5678/healthz`

### Problemas de Base de Datos
- Verificar conexión PostgreSQL: `docker exec laboratorioai-postgres-1 pg_isready`
- Ver logs de PostgreSQL: `docker-compose logs postgres`
- Recrear esquemas: ejecutar scripts en ./postgres/init-scripts/

### Diagnóstico del Sistema
Ejecutar diagnóstico completo:
```bash
# Script de pruebas integral
./scripts/test-n8n-automations.sh

# Verificar todos los servicios
./scripts/validate-env.sh

# Ver estado de salud
curl -s http://localhost:5678/webhook/system-health | jq
```

## Notas de Actualización

### Cambios Recientes v2.0 (Automatizaciones IA)
- ✅ **Redis agregado**: Sistema de cache y colas para N8N
- ✅ **4 Workflows N8N preconfigurados**:
  - Procesamiento automático de documentos con IA
  - Sistema de consultas inteligentes con búsqueda vectorial
  - Análisis de sentimientos con machine learning
  - Monitoreo automático del sistema cada 5 minutos
- ✅ **Base de datos expandida**: Nuevas tablas para logs, sentimientos y monitoreo
- ✅ **Scripts de automatización**: Configuración y pruebas automáticas
- ✅ **Credenciales preconfiguradas**: PostgreSQL y Redis para N8N
- ✅ **APIs REST**: Endpoints para todas las funcionalidades IA
- ✅ **Sistema de alertas**: Notificaciones automáticas por fallos
- ✅ **Cache inteligente**: Redis para optimización de rendimiento
- ✅ **Documentación completa**: Ejemplos de uso y troubleshooting

### Cambios Previos v1.0
- Movidos scripts de inicialización a la carpeta scripts/
- Mejorado el sistema de backup y restauración
- Agregado soporte para modelos Ollama personalizados
- Configuración de red Docker optimizada

### Próximas Funcionalidades
- 🔄 Dashboard web personalizado para métricas
- 🔄 Integración con modelos de Hugging Face
- 🔄 Sistema de notificaciones por email/Slack
- 🔄 API GraphQL para consultas avanzadas
- 🔄 Clustering automático de documentos
- 🔄 Sistema de backup automático programado
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
