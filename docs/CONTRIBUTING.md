# Guía de Desarrollo y Contribución

## 🔧 Configuración del Entorno de Desarrollo

### Requisitos Previos
- Git
- Docker y Docker Compose
- Node.js 20 o superior
- VSCode (recomendado)
- Sistema operativo Linux (recomendado Ubuntu 22.04 o superior)

### Extensiones Recomendadas de VSCode
- Docker
- Remote Development
- Python
- JavaScript and TypeScript
- Git Lens

## 🚀 Primeros Pasos

1. **Clonar el Repositorio**
```bash
git clone https://github.com/EdissonGirald0/laboratorioAI.git
cd laboratorioAI
```

2. **Configurar el Entorno**
```bash
# Generar archivo .env
./scripts/init-env.sh

# Validar configuración
./scripts/validate-env.sh
```

3. **Iniciar en Modo Desarrollo**
```bash
# Construir imágenes
docker-compose build

# Iniciar servicios
docker-compose up -d
```

## 📝 Guías de Contribución

### Flujo de Trabajo Git

1. **Crear una Nueva Rama**
```bash
git checkout -b feature/nombre-feature
```

2. **Convenciones de Commits**
- feat: Nueva característica
- fix: Corrección de bug
- docs: Cambios en documentación
- style: Cambios de formato
- refactor: Refactorización de código
- test: Añadir o modificar tests
- chore: Cambios en build o herramientas

Ejemplo:
```bash
git commit -m "feat: Añadir nuevo endpoint para procesamiento de imágenes"
```

3. **Pull Requests**
- Usar la plantilla proporcionada
- Incluir tests
- Actualizar documentación
- Añadir descripción detallada

### Estándares de Código

#### JavaScript/Node.js
- Usar ESLint con configuración proporcionada
- Seguir estilo Airbnb
- Documentar funciones con JSDoc

#### Python
- Seguir PEP 8
- Usar Black para formateo
- Documentar con docstrings

#### Docker
- Usar multi-stage builds cuando sea posible
- Minimizar capas
- Incluir healthchecks

## 🧪 Testing

### Tests Unitarios
```bash
# Ejecutar tests
npm test

# Coverage
npm run test:coverage
```

### Tests de Integración
```bash
# Iniciar ambiente de test
docker-compose -f docker-compose.test.yml up -d

# Ejecutar tests
npm run test:integration
```

## 📊 Monitoreo y Debugging

### Logs
- Usar logging estructurado (JSON)
- Incluir contexto relevante
- Niveles: ERROR, WARN, INFO, DEBUG

### Métricas
- Prometheus para métricas
- Grafana para visualización
- Custom metrics para lógica de negocio

## 🔐 Seguridad

### Mejores Prácticas
- No commitear secretos
- Usar variables de entorno
- Implementar rate limiting
- Validar inputs
- Mantener dependencias actualizadas

### Escaneo de Vulnerabilidades
```bash
# Escanear imágenes
docker scan <imagen>

# Verificar dependencias
npm audit
```

## 📚 Recursos Adicionales

### Documentación
- [Ollama API](docs/OLLAMA.md)
- [Floowise API](docs/FLOOWISE.md)
- [Arquitectura](docs/ARCHITECTURE.md)

### Enlaces Útiles
- [Guía de Docker](https://docs.docker.com/)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Conventional Commits](https://www.conventionalcommits.org/)
