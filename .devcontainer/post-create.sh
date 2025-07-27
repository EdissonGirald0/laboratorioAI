#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Array de directorios necesarios
directories=(
    "/workspaces/laboratorioAI/data"
    "/workspaces/laboratorioAI/data/flowise"
    "/workspaces/laboratorioAI/data/ollama"
    "/workspaces/laboratorioAI/data/postgres"
)

# Función para manejar errores
handle_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# Función para verificar el resultado del último comando
check_result() {
    if [ $? -ne 0 ]; then
        handle_error "$1"
    fi
}

# Función para crear directorio si no existe
create_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        check_result "No se pudo crear el directorio $1"
        echo -e "${GREEN}Directorio creado: $1${NC}"
    else
        echo -e "${YELLOW}El directorio ya existe: $1${NC}"
    fi
    
    # Asegurar permisos correctos
    chmod 755 "$1"
    check_result "No se pudieron establecer los permisos para $1"
}

echo -e "${YELLOW}Configurando entorno de desarrollo...${NC}"

# Detectar el entorno
IS_CODESPACE=false
if [ -n "${CODESPACES}" ]; then
    IS_CODESPACE=true
    echo -e "${YELLOW}Detectado entorno GitHub Codespaces${NC}"
fi

# Verificar sistema operativo
if [[ "$(uname -s)" != "Linux" ]]; then
    handle_error "Este script está diseñado para sistemas Linux. Sistema detectado: $(uname -s)"
fi

# Verificar que estamos en el directorio correcto
if [ ! -f "docker-compose.yml" ]; then
    if [ "$IS_CODESPACE" = true ]; then
        cd /workspaces/laboratorioAI || handle_error "No se pudo encontrar el directorio del proyecto"
    else
        handle_error "No se encuentra docker-compose.yml. Ejecuta el script desde el directorio raíz del proyecto."
    fi
fi

echo -e "${YELLOW}Verificando requisitos del sistema...${NC}"

# En Codespaces, algunas herramientas ya están instaladas
if [ "$IS_CODESPACE" = false ]; then
    # Verificar si tenemos sudo
    if ! command -v sudo &> /dev/null; then
        handle_error "El comando 'sudo' no está instalado. Por favor, instálalo primero."
    fi

    # Verificar si apt-get está disponible
    if ! command -v apt-get &> /dev/null; then
        echo -e "${YELLOW}AVISO: apt-get no está disponible. Se omitirá la instalación de paquetes del sistema.${NC}"
    fi
fi

echo -e "${GREEN}✓ Requisitos del sistema verificados${NC}"

# Instalar dependencias generales
if [ "$IS_CODESPACE" = false ] && command -v apt-get &> /dev/null; then
    echo -e "${YELLOW}Instalando dependencias necesarias...${NC}"
    sudo apt-get update || handle_error "No se pudo actualizar la lista de paquetes"
    sudo apt-get install -y \
        jq \
        curl \
        wget \
        netcat \
        bc \
        postgresql-client \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        gnupg \
        lsb-release
else
    echo -e "${YELLOW}Verificando dependencias necesarias...${NC}"
    for cmd in jq curl wget nc bc psql; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "${YELLOW}AVISO: $cmd no está instalado${NC}"
        else
            echo -e "${GREEN}✓ $cmd encontrado${NC}"
        fi
    done
fi

# Instalar Docker si no está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Instalando Docker...${NC}"
    
    # Crear directorio para la clave GPG si no existe
    sudo mkdir -p /usr/share/keyrings
    
    # Descargar e instalar la clave GPG de Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    check_result "Error al obtener la clave GPG de Docker"
    
    # Verificar la clave GPG
    if [ ! -f /usr/share/keyrings/docker-archive-keyring.gpg ]; then
        handle_error "No se pudo crear el archivo de clave GPG de Docker"
    fi

    # Configurar el repositorio de Docker
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    check_result "Error al configurar el repositorio de Docker"

    sudo apt-get update
    check_result "Error al actualizar los repositorios"

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    check_result "Error al instalar Docker"

    # Iniciar y habilitar el servicio de Docker
    sudo systemctl start docker
    sudo systemctl enable docker
    check_result "Error al iniciar el servicio de Docker"
else
    echo -e "${GREEN}Docker ya está instalado${NC}"
fi

# Instalar Docker Compose si no está instalado
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Instalando Docker Compose...${NC}"
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
    check_result "Error al obtener la última versión de Docker Compose"

    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    check_result "Error al descargar Docker Compose"

    sudo chmod +x /usr/local/bin/docker-compose
    check_result "Error al establecer permisos de Docker Compose"

    # Verificar la instalación
    docker-compose --version
    check_result "Error al verificar la instalación de Docker Compose"
else
    echo -e "${GREEN}Docker Compose ya está instalado${NC}"
fi

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Verificar si Node.js está instalado
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Instalando Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    check_result "Error al instalar Node.js"
fi

# Instalar Node.js herramientas globales
echo -e "${YELLOW}Instalando herramientas de Node.js...${NC}"
for package in n8n typescript ts-node; do
    echo -e "Instalando $package..."
    sudo npm install -g $package
    check_result "Error al instalar $package"
done

# Configurar git
echo -e "${YELLOW}Configurando Git...${NC}"
git config --global pull.rebase false
git config --global core.editor "code --wait"
check_result "Error al configurar Git"

# Crear directorios necesarios con el manejo adecuado de permisos
echo -e "${YELLOW}Creando directorios necesarios...${NC}"
directories=(
    "postgres/data"
    "qdrant/data"
    "ollama/data"
    "n8n/data"
    "floowise/data"
    "openwebui/data"
    "redis/data"
)

for dir in "${directories[@]}"; do
    mkdir -p "$dir"
    check_result "Error al crear directorio $dir"
    sudo chown -R $USER:$USER "$dir"
    check_result "Error al establecer permisos para $dir"
done

# Verificar y ejecutar scripts necesarios
if [ -d "scripts" ]; then
    # Establecer permisos de ejecución
    find scripts -name "*.sh" -type f -exec chmod +x {} \;
    check_result "Error al establecer permisos de scripts"

    # Generar archivo .env si no existe
    if [ ! -f .env ]; then
        echo -e "${YELLOW}Generando archivo .env...${NC}"
        if [ -f "scripts/init-env.sh" ]; then
            ./scripts/init-env.sh
            check_result "Error al generar archivo .env"
        else
            handle_error "No se encontró el script init-env.sh"
        fi
    fi
else
    handle_error "No se encontró el directorio de scripts"
fi

# Establecer permisos para scripts de prueba si existen
if [ -d "tests" ]; then
    find tests -name "*.sh" -type f -exec chmod +x {} \;
    check_result "Error al establecer permisos de scripts de prueba"
fi

# Verificar la instalación
echo -e "\n${YELLOW}=== Verificando la instalación ===${NC}"

# Verificar instalación de Docker
echo -e "\n${YELLOW}Verificando Docker:${NC}"
if docker --version; then
    echo -e "${GREEN}✓ Docker instalado correctamente${NC}"
    docker version --format "Versión del cliente: {{.Client.Version}}\nVersión del servidor: {{.Server.Version}}"
else
    handle_error "Docker no está instalado correctamente"
fi

# Verificar instalación de Docker Compose
echo -e "\n${YELLOW}Verificando Docker Compose:${NC}"
if docker-compose --version; then
    echo -e "${GREEN}✓ Docker Compose instalado correctamente${NC}"
else
    handle_error "Docker Compose no está instalado correctamente"
fi

# Verificar permisos de Docker
if groups $USER | grep -q docker; then
    echo -e "${GREEN}✓ El usuario tiene permisos de Docker correctamente configurados${NC}"
else
    echo -e "${YELLOW}⚠️ AVISO: Es necesario cerrar sesión y volver a entrar para activar los permisos de Docker${NC}"
fi

# Verificar directorios necesarios
echo -e "\n${YELLOW}Verificando directorios del proyecto:${NC}"
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓ Directorio $dir: OK${NC}"
    else
        echo -e "${RED}✗ Error: Falta el directorio $dir${NC}"
        create_directory "$dir"
    fi
done

echo -e "\n${GREEN}¡Configuración completada con éxito!${NC}"
echo -e "\n${YELLOW}Pasos para iniciar el entorno:${NC}"
echo -e "1. Verificar estado de Docker:${NC}"
echo "   sudo systemctl status docker"
echo -e "2. Si el servicio está detenido, iniciarlo:${NC}"
echo "   sudo systemctl restart docker"
echo -e "3. Levantar los servicios:${NC}"
echo "   docker-compose up -d"
echo -e "\n${YELLOW}Si encuentras problemas de permisos:${NC}"
echo "1. Ejecuta: newgrp docker"
echo "2. Si persisten los problemas: sudo chmod 666 /var/run/docker.sock"
