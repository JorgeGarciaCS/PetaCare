#!/bin/bash

# Script de configuración inicial para Ubuntu - PetACare
# Ejecutar como: ./ubuntu-setup.sh

echo "🐧 Configuración inicial de PetACare en Ubuntu"

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para mostrar mensajes
show_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

show_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

show_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si se ejecuta con sudo para algunas operaciones
if [[ $EUID -eq 0 ]]; then
   show_error "No ejecutes este script como root. Usa sudo cuando sea necesario."
   exit 1
fi

show_message "Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

show_message "Instalando Node.js..."
# Verificar si Node.js ya está instalado
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
    show_message "Node.js instalado: $(node --version)"
else
    show_message "Node.js ya está instalado: $(node --version)"
fi

show_message "Instalando MongoDB..."
# Verificar si MongoDB ya está instalado
if ! command -v mongod &> /dev/null; then
    # Importar clave GPG
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
    
    # Agregar repositorio
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    
    # Actualizar e instalar
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    
    # Iniciar MongoDB
    sudo systemctl start mongod
    sudo systemctl enable mongod
    
    show_message "MongoDB instalado y configurado"
else
    show_message "MongoDB ya está instalado"
    sudo systemctl start mongod
    sudo systemctl enable mongod
fi

show_message "Instalando dependencias adicionales..."
sudo apt install -y git curl wget build-essential

show_message "Instalando PM2 (gestor de procesos)..."
if ! command -v pm2 &> /dev/null; then
    sudo npm install -g pm2
    show_message "PM2 instalado"
else
    show_message "PM2 ya está instalado"
fi

show_message "Configurando firewall..."
# Configurar UFW si está instalado
if command -v ufw &> /dev/null; then
    sudo ufw allow 3001/tcp
    sudo ufw allow 3002/tcp
    show_message "Puertos 3001 y 3002 habilitados en firewall"
fi

show_message "Instalando dependencias del proyecto..."

# Instalar dependencias del backend
if [ -d "crud-api" ]; then
    show_message "Instalando dependencias del backend..."
    cd crud-api
    npm install
    cd ..
    show_message "Dependencias del backend instaladas"
else
    show_warning "Directorio crud-api no encontrado"
fi

# Instalar dependencias del frontend
if [ -d "frontend" ]; then
    show_message "Instalando dependencias del frontend..."
    cd frontend
    npm install
    cd ..
    show_message "Dependencias del frontend instaladas"
else
    show_warning "Directorio frontend no encontrado"
fi

show_message "Configurando permisos..."
# Hacer ejecutables los scripts
chmod +x start.sh
chmod +x ubuntu-start.sh 2>/dev/null || true

show_message "Verificando instalación..."
echo "📋 Resumen de instalación:"
echo "   Node.js: $(node --version)"
echo "   NPM: $(npm --version)"
echo "   MongoDB: $(mongod --version | head -1)"
echo "   PM2: $(pm2 --version)"

# Verificar estado de MongoDB
if sudo systemctl is-active --quiet mongod; then
    show_message "MongoDB está corriendo"
else
    show_warning "MongoDB no está corriendo. Iniciando..."
    sudo systemctl start mongod
fi

show_message "Creando archivo de configuración .env..."
if [ -f "crud-api/.env" ]; then
    show_message "Archivo .env ya existe"
else
    cat > crud-api/.env << 'EOF'
# Variables de entorno para la aplicación PetACare

# Base de datos MongoDB
MONGODB_URI=mongodb://localhost:27017/petacare

# Puerto del servidor
PORT=3001

# Clave secreta para JWT
JWT_SECRET=21b8cd697d74b71bf5e1f57c499858be9f58acb93bf1adf0e1001e31b368089f

# Clave secreta para sesiones
SESSION_SECRET=2d84d0c5fe89d67d9e4c48b3b38df8e422900f9f2fa2c844d55d9865b5ece3a5

# Configuración de entorno
NODE_ENV=development
EOF
    show_message "Archivo .env creado"
fi

echo ""
echo "🎉 ¡Configuración completada!"
echo ""
echo "Para iniciar la aplicación:"
echo "   ./start.sh"
echo ""
echo "Para usar PM2 (producción):"
echo "   pm2 start crud-api/app.js --name petacare-backend"
echo "   pm2 start frontend/server.js --name petacare-frontend"
echo ""
echo "URLs de acceso:"
echo "   Frontend: http://localhost:3002"
echo "   Backend: http://localhost:3001"
echo ""
echo "Para ver esta guía completa: cat MIGRATION_GUIDE_UBUNTU.md"
