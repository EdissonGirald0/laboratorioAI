FROM node:20-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache \
    python3 \
    py3-pip \
    build-base \
    git \
    openssh-client \
    postgresql-client

# Crear directorio de la aplicación
WORKDIR /app

# Instalar flowise globalmente
RUN npm install -g flowise

# Configurar directorios de datos
RUN mkdir -p /root/.flowise/.apikeys /root/.flowise/.secrets /root/.flowise/logs /root/.flowise/components
VOLUME ["/root/.flowise"]

# Variables de entorno por defecto
ENV PORT=3000 \
    FLOWISE_USERNAME=user \
    FLOWISE_PASSWORD=password \
    DATABASE_TYPE=postgres \
    APIKEY_PATH=/root/.flowise/.apikeys \
    SECRETKEY_PATH=/root/.flowise/.secrets \
    LOG_LEVEL=info \
    LOG_PATH=/root/.flowise/logs

# Copiar archivos de configuración
COPY config.json /root/.flowise/
COPY components/ /root/.flowise/components/

# Exponer el puerto
EXPOSE 3000

# Script de healthcheck
COPY healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD [ "/usr/local/bin/healthcheck.sh" ]

# Comando para iniciar Flowise
CMD ["flowise", "start"] 