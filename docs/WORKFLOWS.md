# Workflows n8n del LaboratorioAI

## Modelo configurado

Todos los workflows usan **Ollama** con el modelo **`gemma4:latest`** corriendo localmente en `http://ollama:11434`.

## Diagrama General

```mermaid
graph TB
    subgraph "Entradas"
        WEB1["Webhook<br/>/code-review"]
        WEB2["Webhook<br/>/git-commit"]
        WEB3["Webhook<br/>/bug-report"]
        WEB4["Webhook<br/>/generate-api-docs"]
        WEB5["Webhook<br/>/generate-tests"]
        WEB6["Webhook<br/>/chat"]
        WEB7["Webhook<br/>/process-document"]
        WEB8["Webhook<br/>/sentiment"]
        WEB9["Webhook<br/>/query"]
        WEB10["Webhook<br/>/health-check"]
    end

    subgraph "n8n Workflows"
        W1["Revisor de Código"]
        W2["Generador de Commits"]
        W3["Analizador de Bugs"]
        W4["Generador de Documentación"]
        W5["Generador de Pruebas"]
        W6["Chatbot con Memoria"]
        W7["Procesador de Documentos"]
        W8["Análisis de Sentimientos"]
        W9["Consultas Inteligentes"]
        W10["Monitoreo de Salud"]
    end

    subgraph "Backend"
        OLL["Ollama<br/>gemma4:latest"]
        PG[("PostgreSQL<br/>ailab")]
        QD[("Qdrant<br/>Vector DB")]
        RD[("Redis<br/>Cache")]
    end

    WEB1 --> W1
    WEB2 --> W2
    WEB3 --> W3
    WEB4 --> W4
    WEB5 --> W5
    WEB6 --> W6
    WEB7 --> W7
    WEB8 --> W8
    WEB9 --> W9
    WEB10 --> W10

    W1 --> OLL
    W2 --> OLL
    W3 --> OLL
    W4 --> OLL
    W5 --> OLL
    W6 --> OLL
    W7 --> OLL
    W8 --> OLL
    W9 --> OLL

    W1 --> PG
    W2 --> PG
    W3 --> PG
    W6 --> QD
    W7 --> PG
    W7 --> QD
    W9 --> QD
    W10 --> PG
```

---

## 1. Chatbot con Memoria

```mermaid
sequenceDiagram
    actor U as Usuario
    participant WH as Webhook /chat
    participant QD as Qdrant
    participant CTX as Preparar Contexto
    participant OLL as Ollama gemma4
    participant RESP as Responder

    U->>WH: POST {question, session_id}
    WH->>QD: Buscar historial (session_id)
    QD-->>WH: Mensajes anteriores
    WH->>CTX: Historial + pregunta actual
    CTX->>OLL: Prompt con contexto
    OLL-->>CTX: Respuesta generada
    CTX->>QD: Guardar user + assistant
    CTX->>RESP: Respuesta final
    RESP-->>U: {response, session_id}
```

**Webhook:** `POST http://localhost:5678/webhook/chat`
```json
{ "question": "¿Qué es Docker?", "session_id": "user-123" }
```

---

## 2. Asistente de Revisión de Código

```mermaid
sequenceDiagram
    actor DEV as Desarrollador
    participant WH as Webhook /code-review
    participant OLL as Ollama gemma4
    participant FMT as Formatear
    participant PG as PostgreSQL

    DEV->>WH: POST {language, code}
    WH->>OLL: Prompt: analiza el código
    OLL-->>WH: Revisión detallada
    WH->>FMT: Extraer severidad, timestamp
    FMT->>PG: Guardar en code_reviews
    FMT-->>DEV: {status, review, severity}
```

**Webhook:** `POST http://localhost:5678/webhook/code-review`
```json
{ "language": "python", "code": "def hello():\n    print('world')" }
```

---

## 3. Generador de Mensajes de Commit

```mermaid
sequenceDiagram
    actor DEV as Desarrollador
    participant WH as Webhook /git-commit
    participant OLL as Ollama gemma4
    participant PARSE as Parsear
    participant PG as PostgreSQL

    DEV->>WH: POST {diff}
    WH->>OLL: Prompt: genera commit convencional
    OLL-->>WH: Mensaje de commit
    WH->>PARSE: Extraer tipo, scope, breaking changes
    PARSE->>PG: Guardar en git_commits
    PARSE-->>DEV: {type, scope, description, body}
```

**Webhook:** `POST http://localhost:5678/webhook/git-commit`
```json
{ "diff": "--- a/main.py\n+++ b/main.py\n@@ -1 +1 @@\n-print('hello')\n+print('hola')" }
```

---

## 4. Analizador de Reportes de Bug

```mermaid
sequenceDiagram
    actor QA as QA/Tester
    participant WH as Webhook /bug-report
    participant OLL as Ollama gemma4
    participant PG as PostgreSQL

    QA->>WH: POST {title, description, stacktrace}
    WH->>OLL: Prompt: analiza el bug
    OLL-->>WH: Análisis con causa raíz y solución
    WH->>PG: Guardar en bug_reports
    WH-->>QA: {analysis, root_cause, suggested_fix}
```

**Webhook:** `POST http://localhost:5678/webhook/bug-report`

---

## 5. Generador de Documentación API

```mermaid
sequenceDiagram
    actor DEV as Desarrollador
    participant WH as Webhook /generate-api-docs
    participant OLL as Ollama gemma4
    participant FMT as Formatear

    DEV->>WH: POST {endpoint, method, params, response}
    WH->>OLL: Prompt: genera documentación
    OLL-->>WH: Documentación OpenAPI/Markdown
    WH->>FMT: Estructurar respuesta
    FMT-->>DEV: {markdown, openapi_spec}
```

**Webhook:** `POST http://localhost:5678/webhook/generate-api-docs`

---

## 6. Generador de Casos de Prueba

```mermaid
sequenceDiagram
    actor DEV as Desarrollador
    participant WH as Webhook /generate-tests
    participant OLL as Ollama gemma4
    participant PG as PostgreSQL

    DEV->>WH: POST {language, code, test_framework}
    WH->>OLL: Prompt: genera tests unitarios
    OLL-->>WH: Código de pruebas
    WH->>PG: Guardar en test_cases
    WH-->>DEV: {test_code, coverage_suggestions}
```

**Webhook:** `POST http://localhost:5678/webhook/generate-tests`

---

## 7. Procesamiento de Documentos

```mermaid
sequenceDiagram
    actor U as Usuario
    participant WH as Webhook /process-document
    participant TXT as Extraer Texto
    participant QD as Qdrant
    participant OLL as Ollama gemma4
    participant PG as PostgreSQL

    U->>WH: POST {document, metadata}
    WH->>TXT: Extraer contenido
    TXT->>QD: Indexar embeddings
    TXT->>OLL: Generar resumen
    OLL-->>TXT: Resumen del documento
    TXT->>PG: Guardar metadatos
    TXT-->>U: {summary, chunks, document_id}
```

**Webhook:** `POST http://localhost:5678/webhook/process-document`

---

## 8. Análisis de Sentimientos

```mermaid
sequenceDiagram
    actor U as Usuario
    participant WH as Webhook /sentiment
    participant OLL as Ollama gemma4
    participant PG as PostgreSQL

    U->>WH: POST {text}
    WH->>OLL: Prompt: analiza sentimiento
    OLL-->>WH: Análisis {score, label, keywords}
    WH->>PG: Guardar en sentiment_analyses
    WH-->>U: {sentiment, confidence, entities}
```

**Webhook:** `POST http://localhost:5678/webhook/sentiment`

---

## 9. Sistema de Consultas Inteligentes

```mermaid
sequenceDiagram
    actor U as Usuario
    participant WH as Webhook /query
    participant QD as Qdrant
    participant OLL as Ollama gemma4

    U->>WH: POST {question, language}
    WH->>QD: Buscar documentos relevantes
    QD-->>WH: Contexto de documentos
    WH->>OLL: Prompt: responde con contexto
    OLL-->>WH: Respuesta fundamentada
    WH-->>U: {answer, sources, confidence}
```

**Webhook:** `POST http://localhost:5678/webhook/query`

---

## 10. Monitoreo de Salud del Sistema

```mermaid
sequenceDiagram
    participant CRON as Cron/Manual
    participant WH as Webhook /health-check
    participant SVC as Verificar Servicios
    participant PG as PostgreSQL
    participant ALERTA as Alertas

    CRON->>WH: GET /health-check
    WH->>SVC: Verificar 7 servicios
    SVC->>PG: Guardar en system_health_logs
    SVC-->>WH: Estado de servicios
    alt servicio caído
        WH->>ALERTA: Generar alerta
        ALERTA->>PG: Guardar en system_alerts
        ALERTA-->>WH: Alerta generada
    end
    WH-->>CRON: {status, services, alerts}
```

**Webhook:** `GET http://localhost:5678/webhook/health-check`

---

## Activar workflows

```bash
# Activar todos los workflows de desarrollo
./scripts/activate-dev-workflows.sh

# O activar uno por uno desde la UI de n8n
```

## Probar workflows

```bash
# Code Review
curl -X POST http://localhost:5678/webhook/code-review \
  -H "Content-Type: application/json" \
  -d '{"language":"python","code":"def suma(a,b): return a+b"}'

# Git Commit  
curl -X POST http://localhost:5678/webhook/git-commit \
  -H "Content-Type: application/json" \
  -d '{"diff":"---\n+++\n@@ -1 +1 @@\n-old\n+new"}'

# Chat
curl -X POST http://localhost:5678/webhook/chat \
  -H "Content-Type: application/json" \
  -d '{"question":"¿Qué es un contenedor Docker?","session_id":"test-1"}'
```
