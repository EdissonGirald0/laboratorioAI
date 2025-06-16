FROM node:18-alpine

# Instalar dependencias necesarias
RUN apk add --no-cache python3 py3-pip

# Crear directorio de la aplicación
WORKDIR /app

# Copiar archivos de configuración
COPY package*.json ./
COPY . .

# Instalar dependencias
RUN npm install

# Exponer el puerto de Floowise
EXPOSE 3000

# Configurar el directorio de datos
VOLUME ["/app/data"]

# Comando para iniciar Floowise
CMD ["npm", "run", "dev"] 