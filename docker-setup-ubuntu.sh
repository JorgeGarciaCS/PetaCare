#!/bin/bash

# Script de configuración Docker para Ubuntu - PetaCare
# Ejecutar como: ./docker-setup-ubuntu.sh

echo "🐳 Configuración de Docker para PetaCare en Ubuntu"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

show_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

show_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

show_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Verificar si se ejecuta como root
if [[ $EUID -eq 0 ]]; then
   show_error "No ejecutes este script como root. Usa sudo cuando sea necesario."
   exit 1
fi

show_message "Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

show_message "Instalando Docker..."
# Verificar si Docker ya está instalado
if ! command -v docker &> /dev/null; then
    # Instalar dependencias
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    
    # Agregar clave GPG de Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Agregar repositorio de Docker
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Actualizar e instalar Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    
    show_message "Docker instalado: $(docker --version)"
else
    show_message "Docker ya está instalado: $(docker --version)"
fi

show_message "Instalando Docker Compose..."
# Verificar si Docker Compose ya está instalado
if ! command -v docker-compose &> /dev/null; then
    # Instalar Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    
    # Dar permisos de ejecución
    sudo chmod +x /usr/local/bin/docker-compose
    
    show_message "Docker Compose instalado: $(docker-compose --version)"
else
    show_message "Docker Compose ya está instalado: $(docker-compose --version)"
fi

show_message "Configurando Docker para usuario actual..."
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

show_message "Instalando dependencias adicionales..."
sudo apt install -y git curl wget

show_message "Configurando firewall..."
# Configurar UFW si está instalado
if command -v ufw &> /dev/null; then
    sudo ufw allow 3001/tcp
    sudo ufw allow 3002/tcp
    show_message "Puertos 3001 y 3002 habilitados en firewall"
fi

show_message "Verificando archivos Docker..."
# Verificar archivos Docker necesarios
if [ ! -f "docker-compose.yml" ]; then
    show_error "docker-compose.yml no encontrado"
    exit 1
fi

if [ ! -f "crud-api/Dockerfile" ]; then
    show_error "crud-api/Dockerfile no encontrado"
    exit 1
fi

if [ ! -f "frontend/Dockerfile" ]; then
    show_error "frontend/Dockerfile no encontrado"
    exit 1
fi

show_message "Creando archivo .env para Docker..."
if [ ! -f ".env" ]; then
    cat > .env << 'EOF'
# Variables de entorno para Docker - PetaCare
MONGODB_URI=mongodb://mongo:27017/petacare
JWT_SECRET=21b8cd697d74b71bf5e1f57c499858be9f58acb93bf1adf0e1001e31b368089f
SESSION_SECRET=2d84d0c5fe89d67d9e4c48b3b38df8e422900f9f2fa2c844d55d9865b5ece3a5
NODE_ENV=development
EOF
    show_message "Archivo .env creado para Docker"
else
    show_message "Archivo .env ya existe"
fi

show_message "Haciendo ejecutables los scripts Docker..."
chmod +x docker-*.sh 2>/dev/null || true

show_message "Verificando instalación..."
echo "📋 Resumen de instalación:"
echo "   Docker: $(docker --version)"
echo "   Docker Compose: $(docker-compose --version)"
echo "   Git: $(git --version)"

show_warning "⚠️  IMPORTANTE: Debes cerrar sesión y volver a iniciar sesión para que los cambios del grupo Docker tomen efecto."
show_warning "⚠️  O ejecuta: newgrp docker"

echo ""
show_message "🎉 ¡Configuración de Docker completada!"
echo ""
echo "Próximos pasos:"
echo "1. Cerrar sesión y volver a iniciar sesión (o ejecutar: newgrp docker)"
echo "2. Ejecutar: ./docker-start.sh"
echo ""
echo "URLs de acceso:"
echo "   Frontend: http://localhost:3002"
echo "   Backend: http://localhost:3001"
echo ""
echo "Comandos útiles:"
echo "   docker-compose up -d      # Iniciar en segundo plano"
echo "   docker-compose down       # Detener contenedores"
echo "   docker-compose logs       # Ver logs"
echo "   docker ps                 # Ver contenedores activos"
