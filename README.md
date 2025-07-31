# Laboratorio AI Local

[![GitHub Actions](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml/badge.svg)](https://github.com/EdissonGirald0/laboratorioAI/actions/workflows/main.yml)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-green.svg)](LICENSE)

## 📋 Índice

- [🛠️ Stack Tecnológico](#stack-tecnológico)
- [📋 Descripción del Proyecto](#descripción-del-proyecto)
- [🎯 Características Principales](#características-principales)
- [🏗️ Arquitectura del Sistema](#arquitectura-del-sistema)
- [🌐 Servicios Principales](#servicios-principales)
- [🔐 Seguridad y Credenciales](#seguridad-y-credenciales)
- [🚀 Configuración e Instalación](#configuración-e-instalación)
- [📊 Verificación de Servicios](#verificación-de-servicios)
- [🔧 Scripts de Mantenimiento](#scripts-de-mantenimiento)
- [🤖 Workflows N8N Disponibles](#workflows-n8n-disponibles)
- [🔍 Administración y Monitoreo](#administración-y-monitoreo)
- [🧠 Modelos IA y Configuración](#modelos-ia-y-configuración)
- [🎨 Ejemplos de Uso Avanzado](#ejemplos-de-uso-avanzado)
- [🐛 Solución de Problemas](#solución-de-problemas)
- [🤝 Contribuciones](#contribuciones)
- [📝 Licencia](#licencia)

## 🛠️ Stack Tecnológico

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)](https://redis.io/)
[![Qdrant](https://img.shields.io/badge/Qdrant-FF6B6B?style=for-the-badge&logo=qdrant&logoColor=white)](https://qdrant.tech/)
[![Ollama](https://img.shields.io/badge/Ollama-000000?style=for-the-badge&logo=ollama&logoColor=white)](https://ollama.ai/)
[![N8N](https://img.shields.io/badge/N8N-EA4B71?style=for-the-badge&logo=n8n&logoColor=white)](https://n8n.io/)
[![Flowise](https://img.shields.io/badge/Flowise-6B73FF?style=for-the-badge&logo=flow&logoColor=white)](https://flowiseai.com/)
[![OpenWebUI](https://img.shields.io/badge/OpenWebUI-00D4AA?style=for-the-badge&logo=openai&logoColor=white)](https://github.com/open-webui/open-webui)

## 📋 Descripción del Proyecto

**Laboratorio AI Local** es una plataforma completa de Inteligencia Artificial que se ejecuta localmente usando Docker. Proporciona un ecosistema integrado para experimentar con modelos de IA, automatizaciones, procesamiento de documentos y análisis de datos.

### 🎯 Características Principales

- **🔒 Totalmente Local**: Sin dependencias externas de APIs
- **🐳 Dockerizado**: Configuración reproducible y aislada
- **🚀 Listo para Usar**: Scripts de inicialización automática
- **📊 Base de Datos Completa**: PostgreSQL para persistencia
- **⚡ Cache Inteligente**: Redis para rendimiento optimizado
- **🧠 IA Integrada**: Ollama + OpenWebUI para modelos locales
- **🔄 Automatizaciones**: N8N con workflows preconfigurados
- **🎨 Constructor Visual**: Flowise para flujos de IA sin código

## 🏗️ Arquitectura del Sistema

### 🌐 Servicios Principales

| Servicio | Puerto | Descripción | Estado |
|----------|--------|-------------|---------|
| **N8N** | 5678 | Automatizaciones y workflows de IA | ✅ v1.104.1 |
| **Flowise** | 3000 | Constructor visual de flujos IA | ✅ v2.1.1 |
| **OpenWebUI** | 8080 | Interfaz web para modelos IA | ✅ v0.6.13 |
| **Ollama** | 11434 | Servidor de modelos IA locales | ✅ Latest |
| **Qdrant** | 6333 | Base de datos vectorial | ✅ Latest |
| **PostgreSQL** | 5432 | Base de datos relacional | ✅ v16-alpine |
| **Redis** | 6379 | Cache y colas de trabajo | ✅ v7-alpine |

### 🗂️ Estructura de Directorios

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
            FW["Flowise Puerto 3000"]
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
            VOL6["flowise_data"]
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
```

## 📊 Diagrama de Secuencia - Flujo de Interacción

```mermaid
sequenceDiagram
    participant U as Usuario
    participant UI as OpenWebUI
    participant OL as Ollama
    participant FW as Flowise
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
```

## 🔗 Integración de Servicios N8N

```mermaid
graph LR
    subgraph N8N_Core ["N8N Core"]
        EXECUTOR[Workflow Executor]
        SCHEDULER[Task Scheduler]
        QUEUE[Queue Manager]
    end
    
    subgraph External_Services ["Servicios Externos"]
        OLLAMA[Ollama API]
        POSTGRES[PostgreSQL DB]
        REDIS[Redis Cache]
        QDRANT[Qdrant Vector DB]
    end
    
    subgraph Workflows ["Workflows Activos"]
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
        FW_SYSTEM[Sistema Flowise]
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
    
    class Flowise {
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
    Service <|-- Flowise
    
    OpenWebUI ..> Ollama
    Flowise ..> PostgreSQL
    Flowise ..> Qdrant
    Flowise ..> Ollama
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
            FW["Flowise 3000"]
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
        VOL_FW["flowise_data"]
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
- Flowise para procesamiento de datos
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
├── flowise/                   # Configuración de Flowise
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
```
laboratorioAI/
├── docker-compose.yml   # Configuración principal de servicios
├── .env                 # Variables de entorno (auto-generado)
├── .gitignore          # Archivos excluidos del control de versiones
├── scripts/            # Scripts de automatización y mantenimiento
│   ├── init-env.sh     # Generación automática de credenciales
│   ├── init-db.sh      # Inicialización de base de datos
│   ├── backup-data.sh  # Respaldo de datos
│   ├── test-lab.sh     # Pruebas de conectividad
│   └── reset-env.sh    # Reinicio completo del entorno
├── postgres/           # Configuración PostgreSQL
│   ├── data/          # Datos persistentes (auto-generado)
│   └── init-scripts/  # Scripts de inicialización
├── n8n/               # Configuración N8N
│   ├── data/          # Datos persistentes
│   ├── workflows/     # Workflows preconfigurados en español
│   └── credentials/   # Credenciales de servicios
├── flowise/           # Datos Flowise
│   └── data/          # Base de datos y configuración
├── openwebui/         # Datos OpenWebUI
│   └── data/          # Configuración y chat history
├── ollama/            # Modelos y datos Ollama
│   └── data/          # Modelos descargados
├── qdrant/            # Base de datos vectorial
│   └── data/          # Colecciones y vectores
└── redis/             # Cache y colas
    └── data/          # Datos persistentes
```

## � Gestión de Credenciales y Seguridad

### 🔑 Generación Automática de Credenciales

**🚨 IMPORTANTE**: Este proyecto genera automáticamente todas las credenciales usando métodos criptográficamente seguros. **NUNCA** uses credenciales por defecto en producción.

#### 🛠️ Script de Inicialización Segura

```bash
# Ejecutar para generar credenciales únicas
./scripts/init-env.sh
```

**Qué genera este script:**
- ✅ Contraseñas de 16 caracteres aleatorios para PostgreSQL
- ✅ Claves de encriptación de 32 bytes para N8N
- ✅ API Keys seguros para Qdrant
- ✅ Secret Keys para aplicaciones web
- ✅ Contraseñas para Redis con caracteres alfanuméricos

#### 🔒 Métodos de Seguridad Implementados

| Componente | Método de Generación | Longitud | Algoritmo |
|------------|---------------------|----------|-----------|
| **PostgreSQL** | `openssl rand -base64` | 16 chars | Base64 + filtrado |
| **N8N Encryption** | `openssl rand -base64` | 32 bytes | Base64 puro |
| **Redis Password** | `openssl rand + tr filter` | 16 chars | Alfanumérico |
| **Qdrant API Key** | `openssl rand + tr filter` | 32 chars | Alfanumérico |
| **WebUI Secret** | `openssl rand -base64` | 32 bytes | Base64 puro |

### 📋 Configuración de Servicios

#### 🗃️ PostgreSQL (Base de Datos Principal)
```properties
# Configuración automática en .env
Host: postgres (interno) / localhost (externo)
Puerto: 5432
Base de Datos: ailab
Usuario Admin: postgres (auto-generado)
Usuario Apps: aiadmin (auto-generado)
Conexión: Autenticación scram-sha-256
```

#### 🚀 N8N (Automatización)
```properties
# Acceso y configuración
URL: http://localhost:5678
Autenticación: Deshabilitada (desarrollo local)
Base de Datos: PostgreSQL (usuario aiadmin)
Encriptación: AES-256 con clave auto-generada
Queue: Redis para tareas en background
```

#### 🎨 Flowise (Constructor Visual IA)
```properties
# Acceso seguro
URL: http://localhost:3000
Usuario: admin
Contraseña: Auto-generada (16 caracteres)
Base de Datos: PostgreSQL (usuario postgres)
Tipo: flowiseai/flowise:2.1.1 (oficial)
```

#### ⚡ Redis (Cache y Colas)
```properties
# Configuración de rendimiento
Host: redis / localhost
Puerto: 6379
Autenticación: Contraseña requerida (auto-generada)
Persistencia: AOF habilitada
Uso: Cache N8N + Queue jobs
```

#### 🧠 Qdrant (Base de Datos Vectorial)
```properties
# Almacenamiento de embeddings
URL: http://localhost:6333
API Key: Requerido (32 caracteres auto-generados)
Puerto gRPC: 6334
Colecciones: Auto-creadas por workflows
```

#### 🤖 Ollama (Modelos IA Locales)
```properties
# Servidor de modelos
URL: http://localhost:11434
Autenticación: No requerida (local)
Modelos: Descarga automática según necesidad
API: Compatible con OpenAI
```

#### 🌐 OpenWebUI (Interfaz Web)
```properties
# Chat interface
URL: http://localhost:8080
Base de Datos: SQLite integrada
Autenticación: Registro local opcional
Integración: Ollama backend automático
```

### � Verificación de Credenciales

## Scripts de Mantenimiento

```bash
# Verificación de servicios - Usar estos comandos para verificar el estado
docker-compose ps                    # Estado de todos los servicios
docker logs laboratorioai-n8n-1    # Logs específicos de N8N
docker logs laboratorioai-flowise-1 # Logs específicos de Flowise

# Verificar conexión PostgreSQL
docker exec -it laboratorioai-postgres-1 psql -U postgres -d ailab -c "SELECT version();"

# Test de credenciales N8N
curl -f http://localhost:5678/healthz

# Test de credenciales Flowise  
curl -f http://localhost:3000/api/v1/ping

# Verificar base de datos Qdrant
curl -f http://localhost:6333/health

# Regenerar credenciales (solo si es necesario por seguridad)
bash scripts/init-env.sh  # Genera nuevas credenciales seguras
docker-compose down && docker-compose up -d
```

## 🚀 Configuración e Instalación

### Requisitos Previos
- **Docker** y **Docker Compose** instalados
- **Git** para clonar el repositorio  
- **Linux** (Ubuntu 22.04+ recomendado)
- **16GB RAM** mínimo recomendado
- **50GB** espacio en disco
- **GPU CUDA** (opcional para rendimiento)

### 📝 Pasos de Instalación (Orden Obligatorio)

#### 1. Clonar y Preparar
```bash
git clone https://github.com/EdissonGirald0/laboratorioAI.git
cd laboratorioAI
```

#### 2. **🔑 CRÍTICO - Generar Credenciales**
```bash
chmod +x scripts/init-env.sh
./scripts/init-env.sh
```
**⚠️ IMPORTANTE**: Este paso es OBLIGATORIO antes de `docker-compose up`

#### 3. Iniciar Servicios
```bash
docker-compose up -d
```

#### 4. Verificar Estado
```bash
# Verificar todos los servicios
docker-compose ps

# Verificar logs si hay problemas
docker-compose logs <servicio>
```

### 🔧 Scripts de Configuración Automática

#### Inicialización Completa del Entorno
```bash
./scripts/init-env.sh
```
**Genera automáticamente**:
- ✅ Contraseñas seguras para PostgreSQL (2 usuarios)
- ✅ Contraseña Redis para cache y colas
- ✅ Claves de encriptación N8N
- ✅ API Keys para Qdrant y servicios
- ✅ Tokens de seguridad OpenWebUI
- ✅ Archivo `.env` con permisos 600
- ✅ Credenciales mostradas en pantalla para respaldo

#### Configuración de Automatizaciones N8N  
```bash
./scripts/setup-n8n-automation.sh
```

#### Pruebas del Sistema
```bash
./scripts/test-n8n-automations.sh
```

## 🐳 Estado Actual de Servicios (Verificado Junio 2025)

### ✅ Servicios Funcionando Correctamente

| Servicio | Estado | URL | Versión | Base de Datos |
|----------|--------|-----|---------|---------------|
| **PostgreSQL** | 🟢 Healthy | `localhost:5432` | 16-alpine | - |
| **Redis** | 🟢 Healthy | `localhost:6379` | 7-alpine | - |
| **N8N** | 🟢 Running | `http://localhost:5678` | v1.104.1 | PostgreSQL |
| **Flowise** | 🟢 Running | `http://localhost:3000` | v2.1.1 | PostgreSQL |
| **Ollama** | 🟢 Running | `http://localhost:11434` | latest | - |
| **OpenWebUI** | 🟢 Healthy | `http://localhost:8080` | v0.6.13 | SQLite |
| **Qdrant** | 🟢 Running | `http://localhost:6333` | latest | - |

### 📊 Verificación de Conectividad

#### Test de Conexiones PostgreSQL
```bash
# Usuario administrador
docker exec laboratorioai-postgres-1 psql -U postgres -c "SELECT version();"

# Usuario aplicaciones (N8N)
docker exec laboratorioai-postgres-1 psql -U aiadmin -d ailab -c "SELECT COUNT(*) FROM information_schema.tables;"

# Base de datos Flowise
docker exec laboratorioai-postgres-1 psql -U postgres -d flowise -c "SELECT 1;"
```

#### Test de Redis
```bash
# Verificar conexión Redis (usar variable de entorno)
docker exec redis redis-cli -a $REDIS_PASSWORD ping

# Ver información de memoria
docker exec redis redis-cli -a $REDIS_PASSWORD info memory
```

#### Test de Servicios Web
```bash
# Todos deben retornar HTTP 200
curl -s -o /dev/null -w "%{http_code}" http://localhost:5678  # N8N
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000  # Flowise  
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080  # OpenWebUI
curl -s -o /dev/null -w "%{http_code}" http://localhost:6333  # Qdrant
curl -s -o /dev/null -w "%{http_code}" http://localhost:11434 # Ollama
```

## 🏗️ Arquitectura y Configuración Detallada

### 🔗 Conectividad Entre Servicios (Verificada)

#### Matriz de Conexiones
| Origen | Destino | Protocolo | Puerto | Estado |
|--------|---------|-----------|--------|--------|
| N8N | PostgreSQL | TCP/SQL | 5432 | ✅ Conectado |
| N8N | Redis | TCP | 6379 | ✅ Conectado |
| N8N | Ollama | HTTP | 11434 | ✅ Conectado |
| N8N | Qdrant | HTTP | 6333 | ✅ Conectado |
| Flowise | PostgreSQL | TCP/SQL | 5432 | ✅ Conectado |
| Flowise | Qdrant | HTTP | 6333 | ✅ Conectado |
| OpenWebUI | Ollama | HTTP | 11434 | ✅ Conectado |

#### Red Docker: `laboratorio_ai`
```bash
# Ver detalles de la red
docker network inspect laboratorio_ai

# IPs asignadas automáticamente:
# PostgreSQL: 172.18.0.3
# Redis: 172.18.0.4  
# Qdrant: 172.18.0.5
# Ollama: 172.18.0.6
# etc.
```

### 📁 Estructura de Volúmenes (Persistencia de Datos)

#### Mapeo de Directorios Host ↔ Contenedor
```
Host Directory                    → Container Mount
./postgres/data                   → /var/lib/postgresql/data
./redis/data                      → /data  
./qdrant/data                     → /qdrant/storage
./ollama/data                     → /root/.ollama
./n8n/data                        → /home/node/.n8n
./flowise/data                    → /root/.flowise
./openwebui/data                  → /app/data
```

#### Tamaños de Datos Actuales
```bash
# Verificar uso de espacio
du -sh ./*/data/
# postgres/data:  ~500MB (65 tablas + datos)
# redis/data:     ~50MB (cache + colas)
# qdrant/data:    ~100MB (vectores)
# ollama/data:    ~5GB (modelos descargados)
# n8n/data:       ~100MB (workflows + config)
# flowise/data:   ~50MB (configuraciones)
# openwebui/data: ~200MB (usuarios + chats)
```

### 🔧 Configuraciones Avanzadas

#### PostgreSQL - Configuración de Rendimiento
```sql
-- Configuraciones aplicadas automáticamente
shared_buffers = 256MB
effective_cache_size = 1GB  
work_mem = 4MB
maintenance_work_mem = 64MB
max_connections = 100
```

#### Redis - Configuración de Persistencia  
```conf
# Configuración actual
appendonly yes                 # AOF habilitado
appendfsync everysec          # Sincronización cada segundo  
save 900 1                    # Snapshot cada 15min si ≥1 cambio
save 300 10                   # Snapshot cada 5min si ≥10 cambios
save 60 10000                 # Snapshot cada 1min si ≥10k cambios
```

#### N8N - Configuración de Colas y Workers
```properties
# Variables aplicadas
EXECUTIONS_MODE=queue          # Uso de Redis para colas
QUEUE_BULL_REDIS_HOST=redis   # Conexión a Redis
QUEUE_HEALTH_CHECK_ACTIVE=true # Monitoreo activo
N8N_USER_MANAGEMENT_DISABLED=true # Sin autenticación (desarrollo)
```

## 🤖 Sistema de Automatizaciones N8N (Actualizado)

### 📋 Estado de Workflows (Enero 2025)

| Workflow | Estado | Endpoint | Funcionalidad | Base de Datos |
|----------|--------|----------|---------------|---------------|
| **Procesamiento de Documentos** | ✅ Activo | `/webhook/document-processing` | Embeddings + Vectorización | PostgreSQL + Qdrant |
| **Consultas Inteligentes** | ✅ Activo | `/webhook/intelligent-query` | Búsqueda Semántica + IA | PostgreSQL + Qdrant + Cache |
| **Análisis de Sentimientos** | ✅ Activo | `/webhook/sentiment-analysis` | ML para Emociones | PostgreSQL + Redis |
| **Monitoreo del Sistema** | ✅ Activo | Automático (5min) | Health Check All Services | PostgreSQL + Redis |

### 🔄 APIs de Automatización (Endpoints Verificados)

#### 1. 📄 Procesamiento de Documentos
```bash
# Endpoint verificado funcionando
curl -X POST http://localhost:5678/webhook/document-processing \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Texto del documento a procesar con IA",
    "filename": "documento.txt", 
    "content_type": "text/plain",
    "metadata": {
      "author": "Usuario",
      "category": "documentos",
      "language": "es"
    }
  }'

# Respuesta esperada:
{
  "success": true,
  "document_id": "doc_1234567890",
  "qdrant_point_id": "vector_1234567890", 
  "processed_at": "2025-01-31T12:00:00Z",
  "embedding_model": "llama2:latest"
}
```

#### 2. 🧠 Consultas Inteligentes  
```bash
# Búsqueda semántica con contexto
curl -X POST http://localhost:5678/webhook/intelligent-query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "¿Qué información tienes sobre machine learning?",
    "limit": 5,
    "threshold": 0.7,
    "include_metadata": true
  }'

# Respuesta con contexto IA:
{
  "success": true,
  "query_id": "query_1234567890",
  "original_query": "¿Qué información tienes sobre machine learning?",
  "documents_found": 3,
  "ai_response": "Basado en los documentos encontrados, machine learning es...",
  "sources": [
    {"document_id": "doc_123", "score": 0.95, "filename": "ml-intro.txt"},
    {"document_id": "doc_456", "score": 0.87, "filename": "ai-concepts.md"}
  ],
  "processing_time_ms": 1250
}
```

#### 3. 😊 Análisis de Sentimientos
```bash
# Análisis completo de emociones
curl -X POST http://localhost:5678/webhook/sentiment-analysis \
  -H "Content-Type: application/json" \
  -d '{
    "text": "¡Me encanta este laboratorio de IA! Es increíble lo que se puede hacer.",
    "language": "es",
    "source": "usuario_feedback",
    "user_id": "user123"
  }'

# Resultado detallado:
{
  "success": true,
  "analysis_id": "sent_1234567890", 
  "overall_sentiment": "positive",
  "confidence_score": 0.94,
  "emotional_indicators": {
    "joy": 0.85,
    "excitement": 0.78, 
    "satisfaction": 0.82,
    "negative_emotions": 0.02
  },
  "text_metrics": {
    "length": 67,
    "words": 12,
    "exclamation_marks": 2
  },
  "cached": false,
  "processing_time_ms": 890
}
```

#### 4. 🏥 Monitoreo Automático del Sistema
```bash
# Verificar última verificación de salud
curl -s http://localhost:5678/api/v1/executions/current | jq '.[0]'

# Ver logs de salud en PostgreSQL
docker exec laboratorioai-postgres-1 psql -U aiadmin -d ailab -c \
  "SELECT * FROM system_health_logs ORDER BY timestamp DESC LIMIT 5;"

# Verificar métricas en Redis
docker exec redis redis-cli -a $REDIS_PASSWORD GET system:health:latest
```

### 📊 Base de Datos - Esquemas Actualizados

#### Tablas de Automatización en PostgreSQL
```sql
-- Esquema verificado y funcionando en ailab database

-- 1. Logs de consultas inteligentes
CREATE TABLE IF NOT EXISTS query_logs (
    query_id VARCHAR(255) PRIMARY KEY,
    original_query TEXT NOT NULL,
    documents_found INTEGER DEFAULT 0,
    response_generated TEXT,
    processing_time_ms INTEGER,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Análisis de sentimientos 
CREATE TABLE IF NOT EXISTS sentiment_analysis (
    analysis_id VARCHAR(255) PRIMARY KEY,
    original_text TEXT NOT NULL,
    overall_sentiment VARCHAR(20),
    confidence_score DECIMAL(5,3),
    emotional_indicators JSONB,
    text_metrics JSONB,
    language VARCHAR(10) DEFAULT 'es',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Documentos procesados
CREATE TABLE IF NOT EXISTS processed_documents (
    document_id VARCHAR(255) PRIMARY KEY,
    filename VARCHAR(255),
    content_type VARCHAR(100),
    content_length INTEGER,
    qdrant_point_id VARCHAR(255),
    metadata JSONB,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Logs de salud del sistema
CREATE TABLE IF NOT EXISTS system_health_logs (
    check_id VARCHAR(255) PRIMARY KEY,
    overall_health VARCHAR(20),
    service_details JSONB,
    response_times JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Métricas de performance
CREATE TABLE IF NOT EXISTS performance_metrics (
    metric_id VARCHAR(255) PRIMARY KEY,
    service_name VARCHAR(100),
    metric_type VARCHAR(50),
    metric_value DECIMAL(10,3),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ver estadísticas actuales
SELECT 
    'query_logs' as tabla, COUNT(*) as registros FROM query_logs
UNION ALL SELECT 
    'sentiment_analysis' as tabla, COUNT(*) as registros FROM sentiment_analysis  
UNION ALL SELECT
    'processed_documents' as tabla, COUNT(*) as registros FROM processed_documents
UNION ALL SELECT
    'system_health_logs' as tabla, COUNT(*) as registros FROM system_health_logs;
```

#### Redis - Estructura de Cache
```bash
# Claves utilizadas por el sistema (verificadas)

# 1. Cache de análisis de sentimientos (TTL: 1 hora)
redis-cli -a $REDIS_PASSWORD KEYS "sentiment:*"

# 2. Estado de salud del sistema (TTL: 10 minutos)  
redis-cli -a $REDIS_PASSWORD GET "system:health:latest"

# 3. Colas de N8N (persistentes)
redis-cli -a $REDIS_PASSWORD KEYS "bull:*"

# 4. Métricas en tiempo real (TTL: 5 minutos)
redis-cli -a $REDIS_PASSWORD KEYS "metrics:*"

# Ver estadísticas de uso
redis-cli -a $REDIS_PASSWORD INFO keyspace
```

## 🔍 Monitoreo y Diagnóstico (Herramientas Verificadas)

### 📈 Dashboard de Métricas en Tiempo Real

#### N8N Dashboard (Principal)
- **URL**: http://localhost:5678
- **Funciones**: 
  - ✅ Ver ejecuciones de workflows en tiempo real
  - ✅ Logs detallados de cada automatización
  - ✅ Estadísticas de rendimiento por workflow
  - ✅ Configuración y edición de automatizaciones

#### Métricas de Base de Datos
```sql
-- Consultas útiles para monitoreo
-- Actividad reciente (últimas 24 horas)
SELECT 
    DATE_TRUNC('hour', timestamp) as hora,
    COUNT(*) as ejecuciones
FROM query_logs 
WHERE timestamp > NOW() - INTERVAL '24 hours'
GROUP BY hora ORDER BY hora;

-- Análisis de sentimientos por tipo
SELECT 
    overall_sentiment,
    COUNT(*) as cantidad,
    AVG(confidence_score) as confianza_promedio
FROM sentiment_analysis
GROUP BY overall_sentiment;

-- Documentos procesados por día
SELECT 
    DATE(processed_at) as fecha,
    COUNT(*) as documentos_procesados
FROM processed_documents
GROUP BY fecha ORDER BY fecha DESC;

-- Estado de salud del sistema (última semana)
SELECT 
    overall_health,
    COUNT(*) as verificaciones,
    MAX(timestamp) as ultima_verificacion
FROM system_health_logs
WHERE timestamp > NOW() - INTERVAL '7 days'
GROUP BY overall_health;
```

#### Comandos de Diagnóstico Rápido
```bash
# 🔧 Script completo de diagnóstico del sistema
cat << 'EOF' > quick-diagnosis.sh
#!/bin/bash
echo "=== DIAGNÓSTICO DEL LABORATORIO AI ==="
echo "Fecha: $(date)"
echo ""

echo "📊 Estado de Contenedores:"
docker-compose ps

echo -e "\n🌐 Conectividad de Servicios:"
echo "N8N: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:5678)"
echo "Flowise: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)" 
echo "OpenWebUI: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)"
echo "Qdrant: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:6333)"
echo "Ollama: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:11434)"

echo -e "\n💾 Estado de Base de Datos:"
docker exec laboratorioai-postgres-1 psql -U postgres -c "SELECT version();" 2>/dev/null | head -3
echo "Tablas N8N: $(docker exec laboratorioai-postgres-1 psql -U aiadmin -d ailab -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" -t 2>/dev/null | tr -d ' ')"

echo -e "\n📦 Estado de Redis:"
docker exec redis redis-cli -a $REDIS_PASSWORD ping 2>/dev/null
echo "Claves en cache: $(docker exec redis redis-cli -a $REDIS_PASSWORD DBSIZE 2>/dev/null | cut -d' ' -f1)"

echo -e "\n🔄 Actividad Reciente (últimas 24h):"
docker exec laboratorioai-postgres-1 psql -U aiadmin -d ailab -c \
  "SELECT 'Consultas: ' || COUNT(*) FROM query_logs WHERE timestamp > NOW() - INTERVAL '24 hours';" -t 2>/dev/null
docker exec laboratorioai-postgres-1 psql -U aiadmin -d ailab -c \
  "SELECT 'Sentimientos: ' || COUNT(*) FROM sentiment_analysis WHERE created_at > NOW() - INTERVAL '24 hours';" -t 2>/dev/null
docker exec laboratorioai-postgres-1 psql -U aiadmin -d ailab -c \
  "SELECT 'Documentos: ' || COUNT(*) FROM processed_documents WHERE processed_at > NOW() - INTERVAL '24 hours';" -t 2>/dev/null

echo -e "\n✅ Diagnóstico Completado"
EOF

chmod +x quick-diagnosis.sh
./quick-diagnosis.sh
```

### 🚨 Sistema de Alertas Automáticas

#### Configuración de Alertas N8N
```json
{
  "alertas_configuradas": {
    "servicios_caidos": {
      "frecuencia": "cada_5_minutos",
      "servicios_monitoreados": ["postgres", "redis", "qdrant", "ollama"],
      "accion": "log_en_postgresql + cache_redis"
    },
    "rendimiento_degradado": {
      "umbral_respuesta": "5_segundos",
      "accion": "alerta_en_logs"
    },
    "errores_criticos": {
      "tipos": ["conexion_bd", "fallo_ai", "memoria_insuficiente"],
      "accion": "log_detallado + notificacion"
    }
  }
}
```

#### Logs de Alertas  
```bash
# Ver alertas recientes del sistema
docker exec laboratorioai-postgres-1 psql -U aiadmin -d ailab -c \
  "SELECT * FROM system_health_logs WHERE overall_health != 'healthy' ORDER BY timestamp DESC LIMIT 10;"

# Ver errores en logs de N8N
docker logs n8n --tail 50 | grep -i "error\|fail\|exception"

# Verificar uso de recursos
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

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

### Flowise (Aplicación Principal)
- **URL**: http://localhost:3000
- **Configuración**:
  - Base de datos: PostgreSQL
  - Vector DB: Qdrant
  - Volumen persistente: ./flowise/data

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
- **Flowise**: ./flowise/data
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

### 🆘 Soporte y Ayuda

Si encuentras problemas o necesitas ayuda:

1. **Documentación**: Revisa esta documentación completa
2. **Scripts de Test**: Ejecuta `bash scripts/test-lab.sh` para diagnóstico
3. **Logs**: Revisa los logs con `docker-compose logs [servicio]`
4. **Issues**: Abre un issue en GitHub con información detallada
5. **Comunidad**: Participa en las discusiones del proyecto

#### 🔧 Comandos de Diagnóstico Rápido

```bash
# Estado general del sistema
docker-compose ps

# Verificar logs de errores
docker-compose logs | grep -i error

# Reinicio completo del sistema
docker-compose down && docker-compose up -d

# Verificar conectividad de red
docker network inspect laboratorio_ai_default
```

### 📞 Contacto

- **GitHub**: [EdissonGirald0](https://github.com/EdissonGirald0)
- **Proyecto**: [laboratorioAI](https://github.com/EdissonGirald0/laboratorioAI)
- **Issues**: [Reportar Problemas](https://github.com/EdissonGirald0/laboratorioAI/issues)

### 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

### 👥 Autores

- **Edisson Giraldo** - *Desarrollo inicial* - [EdissonGirald0](https://github.com/EdissonGirald0)
