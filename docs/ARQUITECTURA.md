# Arquitectura del Sistema

## 1. Arquitectura de Servicios

```mermaid
graph TB
    subgraph "Host"
        Browser["Navegador"]
        CLI["CLI / API"]
    end

    subgraph "Docker Network: laboratorio_ai"
        subgraph "Frontends"
            OW["OpenWebUI<br/>puerto 8080"]
            N8N["n8n<br/>puerto 5678"]
            FLOW["Flowise<br/>puerto 3000"]
        end

        subgraph "AI Engine"
            OLLAMA["Ollama<br/>puerto 11434"]
        end

        subgraph "Almacenamiento"
            PG[("PostgreSQL 16<br/>puerto 5432<br/>ailab + n8n_db")]
            QD[("Qdrant<br/>puerto 6333<br/>Vector DB")]
            RD[("Redis<br/>puerto 6380→6379<br/>Cache + Sesiones")]
        end
    end

    Browser -->|8080| OW
    Browser -->|5678| N8N
    Browser -->|3000| FLOW
    CLI -->|API| OLLAMA

    OW -->|consulta modelos| OLLAMA
    OW -->|cache| RD
    N8N -->|BD| PG
    N8N -->|jobs| RD
    N8N -->|consulta IA| OLLAMA
    N8N -->|vectores| QD
    FLOW -->|BD| PG
    FLOW -->|cache| RD
    FLOW -->|consulta IA| OLLAMA
    FLOW -->|vectores| QD

    style OW fill:#89b4fa,color:#11111b
    style N8N fill:#cba6f7,color:#11111b
    style FLOW fill:#a6e3a1,color:#11111b
    style OLLAMA fill:#fab387,color:#11111b
    style PG fill:#89b4fa,color:#11111b
    style QD fill:#cba6f7,color:#11111b
    style RD fill:#f38ba8,color:#11111b
```

## 2. Flujo de Datos

```mermaid
sequenceDiagram
    actor U as Usuario
    participant OW as OpenWebUI
    participant N8N as n8n
    participant FLOW as Flowise
    participant OLL as Ollama
    participant PG as PostgreSQL
    participant QD as Qdrant
    participant RD as Redis

    Note over U,RD: Flujo de Chat con IA
    U->>OW: Escribe mensaje
    OW->>RD: Recupera contexto de sesion
    OW->>OLL: Envia prompt al modelo
    OLL-->>OW: Respuesta del modelo
    OW-->>U: Muestra respuesta
    OW->>RD: Guarda contexto de sesion

    Note over U,RD: Flujo de Automatizacion
    U->>N8N: Activa workflow (webhook)
    N8N->>RD: Verifica estado de jobs
    N8N->>PG: Lee/escribe datos de workflow
    N8N->>OLL: Consulta modelo IA
    OLL-->>N8N: Respuesta del modelo
    N8N->>QD: Almacena/consulta vectores
    N8N-->>U: Resultado del workflow

    Note over U,RD: Flujo de RAG (Flowise)
    U->>FLOW: Envia consulta
    FLOW->>PG: Carga configuracion del flow
    FLOW->>QD: Busca documentos similares
    FLOW->>OLL: Genera respuesta con contexto
    OLL-->>FLOW: Respuesta generada
    FLOW-->>U: Resultado con fuentes
```

## 3. Estructura de Bases de Datos

```mermaid
erDiagram
    POSTGRESQL {
        string ailab "Flowise DB"
        string n8n_db "n8n DB"
    }

    ailab ||--o{ system_health_logs : contiene
    ailab ||--o{ system_alerts : contiene
    ailab ||--o{ performance_metrics : contiene

    system_health_logs {
        int id PK
        string check_id UK
        string overall_health
        int healthy_services
        int total_services
        jsonb service_details
        timestamp timestamp
    }

    system_alerts {
        int id PK
        string alert_id UK
        string severity
        string title
        text message
        jsonb details
        string status
        timestamp created_at
    }

    performance_metrics {
        int id PK
        string metric_id UK
        string service_name
        string metric_type
        decimal metric_value
        timestamp timestamp
    }

    n8n_db {
        string "76 tablas (TypeORM)"
    }

    QDRANT {
        string collections "Colecciones vectoriales"
    }

    REDIS {
        string sessions "Sesiones OpenWebUI"
        string cache "Cache Flowise"
        string jobs "Jobs n8n"
        string bull "Bull Queue"
    }
```

## 4. Inicializacion y Recuperacion de BD

```mermaid
flowchart TD
    START([docker compose up -d]) --> PG_START[PostgreSQL inicia]
    PG_START --> CHECK_DATA{Existe<br/>/var/lib/postgresql<br/>con datos?}

    CHECK_DATA -->|No, primer deploy| INIT[Ejecuta<br/>docker-entrypoint-initdb.d]
    INIT --> S00[00-init-users.sh<br/>• Crea n8n_db<br/>• Crea extensiones<br/>• Crea usuario aiadmin<br/>• Asigna permisos]
    S00 --> S01[01-init.sql<br/>• Schemas n8n + floowise]
    S01 --> S02[02-monitoring-schema.sql<br/>• Tablas de monitoreo<br/>• Vistas y funciones]

    CHECK_DATA -->|Si, datos existen| CHECK_N8N{Existe BD<br/>n8n_db?}
    CHECK_N8N -->|No| RECREATE[Comando inline<br/>CREATE DATABASE n8n_db]
    CHECK_N8N -->|Si| SKIP[✓ BD recuperada]

    S02 --> READY[PostgreSQL listo]
    RECREATE --> READY
    SKIP --> READY

    READY --> N8N_START[n8n inicia<br/>ejecuta migraciones]
    N8N_START --> N8N_READY[n8n listo<br/>76 tablas TypeORM]

    READY --> FLOW_START[Flowise inicia]
    FLOW_START --> FLOW_READY[Flowise listo]

    style INIT fill:#a6e3a1,color:#11111b
    style RECREATE fill:#fab387,color:#11111b
    style SKIP fill:#89b4fa,color:#11111b
    style N8N_READY fill:#cba6f7,color:#11111b
    style FLOW_READY fill:#a6e3a1,color:#11111b
```

## 5. Red y Puertos

```mermaid
graph LR
    subgraph "Host (localhost)"
        P8080["8080 → OpenWebUI"]
        P5678["5678 → n8n"]
        P3000["3000 → Flowise"]
        P11434["11434 → Ollama"]
        P6333["6333 → Qdrant"]
        P6380["6380 → Redis"]
        P5432["5432 → PostgreSQL"]
    end

    subgraph "Docker Network: laboratorio_ai (bridge)"
        OW2["openwebui :8080"]
        N8N2["n8n :5678"]
        FLOW2["floowise :3000"]
        OLL2["ollama :11434"]
        QD2["qdrant :6333"]
        RD2["redis :6379"]
        PG2["postgres :5432"]
    end

    P8080 -.-> OW2
    P5678 -.-> N8N2
    P3000 -.-> FLOW2
    P11434 -.-> OLL2
    P6333 -.-> QD2
    P6380 -.-> RD2

    OW2 -->|redis://redis:6379| RD2
    N8N2 -->|postgres:5432| PG2
    N8N2 -->|redis:6379| RD2
    N8N2 -->|ollama:11434| OLL2
    N8N2 -->|qdrant:6333| QD2
    FLOW2 -->|postgres:5432| PG2
    FLOW2 -->|redis:6379| RD2
    FLOW2 -->|ollama:11434| OLL2
    FLOW2 -->|qdrant:6333| QD2

    style P6380 fill:#f38ba8,color:#11111b
    style PG2 fill:#89b4fa,color:#11111b
    style RD2 fill:#f38ba8,color:#11111b
```

## 6. Flujo de Despliegue

```mermaid
flowchart TD
    A[git clone] --> B[./scripts/init-env.sh]
    B --> C{Existe .env?}
    C -->|No| B2[Genera .env<br/>con claves aleatorias]
    C -->|Si| D[✓ .env listo]
    B2 --> D

    D --> E[docker compose up -d]
    E --> F[Pull imagenes]
    F --> G[Build floowise]

    G --> H[Iniciar servicios]

    H --> I1[redis]
    H --> I2[postgres]
    H --> I3[qdrant]
    H --> I4[ollama]

    I2 --> J{Primer deploy?}
    J -->|Si| J1[Init scripts<br/>crean BD + schemas]
    J -->|No| J2[Recupera BD<br/>verifica n8n_db]
    J1 --> K[Postgres healthy]
    J2 --> K

    K --> L1[openwebui]
    K --> L2[n8n + migraciones]
    K --> L3[floowise]

    L2 --> M[n8n healthy<br/>76 tablas]

    I4 --> L1
    I3 --> L1
    I1 --> L1

    L1 --> OK[✓ Sistema listo]
    M --> OK
    L3 --> OK

    OK --> OPT{Setup n8n?}
    OPT -->|Si| N[./scripts/setup-n8n-complete.sh]
    OPT -->|No| DONE[✓ Produccion]
    N --> DONE

    style B fill:#fab387,color:#11111b
    style J1 fill:#a6e3a1,color:#11111b
    style J2 fill:#89b4fa,color:#11111b
    style OK fill:#cba6f7,color:#11111b
```

## 7. Recursos y Limites

```mermaid
graph LR
    subgraph "Sistema: 31 GB RAM"
        subgraph "Reservas Minimas ~3 GB"
            R1["redis 64 MB"]
            R2["postgres 128 MB"]
            R3["qdrant 256 MB"]
            R4["ollama 512 MB"]
            R5["openwebui 256 MB"]
            R6["n8n 512 MB"]
            R7["floowise 512 MB"]
        end
        subgraph "Limites Maximos ~14 GB"
            L1["redis 256 MB"]
            L2["postgres 512 MB"]
            L3["qdrant 1 GB"]
            L4["ollama 8 GB"]
            L5["openwebui 2 GB"]
            L6["n8n 1 GB"]
            L7["floowise 1 GB"]
        end
    end

    style R4 fill:#fab38723,stroke:#fab387
    style L4 fill:#fab38723,stroke:#fab387
```

## 8. Ciclo de Vida de un Workflow n8n

```mermaid
stateDiagram-v2
    [*] --> Inactivo: Importar workflow
    Inactivo --> Activo: activate-dev-workflows.sh
    Activo --> Esperando: Webhook configurado
    Esperando --> Ejecutando: POST a webhook
    Ejecutando --> Procesando: Node.js worker
    Procesando --> Completado: Exito
    Procesando --> Error: Falla
    Error --> Esperando: Reintentar
    Completado --> Esperando
    Activo --> Inactivo: Desactivar
    Inactivo --> [*]: Eliminar
```