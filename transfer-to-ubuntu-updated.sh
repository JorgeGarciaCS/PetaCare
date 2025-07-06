#!/bin/bash

# Script para transferir archivos desde Windows a Ubuntu
# NOTA: Ya no es necesario usar este script - el proyecto está en GitHub

echo "📂 Transferencia de archivos PetaCare: Windows → Ubuntu"

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

show_warning "🎯 RECOMENDACIÓN: Usar GitHub en lugar de transferencia manual"
echo ""
show_info "El proyecto ya está disponible en GitHub:"
echo "   https://github.com/JorgeGarciaCS/PetaCare"
echo ""
show_info "Pasos recomendados en Ubuntu:"
echo "   1. git clone https://github.com/JorgeGarciaCS/PetaCare.git"
echo "   2. cd PetaCare"
echo "   3. ./docker-setup-ubuntu.sh"
echo "   4. ./docker-start.sh"
echo ""
read -p "¿Continuar con transferencia manual? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    show_message "Usa mejor GitHub para obtener la versión más actualizada"
    exit 0
fi

echo ""
show_warning "⚠️  IMPORTANTE: La transferencia manual puede no incluir las últimas actualizaciones"
echo ""

# Configuración (CAMBIAR ESTOS VALORES)
UBUNTU_USER="tu_usuario"
UBUNTU_IP="tu_ip_ubuntu"
UBUNTU_PATH="/home/$UBUNTU_USER/PetaCare"
WINDOWS_PATH="/c/Users/jg153/PetaCare-1"  # Ruta en formato Git Bash

# Función para mostrar mensajes
show_message() {
    echo "[INFO] $1"
}

show_error() {
    echo "[ERROR] $1"
}

# Verificar si SSH está disponible
if ! command -v ssh &> /dev/null; then
    show_error "SSH no está disponible. Instala OpenSSH o usa otro método de transferencia."
    exit 1
fi

show_message "Configuración:"
echo "   Origen: $WINDOWS_PATH"
echo "   Destino: $UBUNTU_USER@$UBUNTU_IP:$UBUNTU_PATH"
echo ""

# Confirmar configuración
read -p "¿La configuración es correcta? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    show_error "Configura las variables en el script antes de ejecutar."
    exit 1
fi

# Crear directorio en Ubuntu
show_message "Creando directorio en Ubuntu..."
ssh $UBUNTU_USER@$UBUNTU_IP "mkdir -p $UBUNTU_PATH"

# Transferir archivos
show_message "Transfiriendo archivos..."
scp -r $WINDOWS_PATH/* $UBUNTU_USER@$UBUNTU_IP:$UBUNTU_PATH/

# Hacer ejecutables los scripts
show_message "Configurando permisos..."
ssh $UBUNTU_USER@$UBUNTU_IP "chmod +x $UBUNTU_PATH/*.sh"

show_message "✅ Transferencia completada!"
echo ""
echo "Próximos pasos en Ubuntu:"
echo "1. ssh $UBUNTU_USER@$UBUNTU_IP"
echo "2. cd $UBUNTU_PATH"
echo "3. ./docker-setup-ubuntu.sh (recomendado)"
echo "4. ./docker-start.sh"
echo ""
echo "O para instalación manual:"
echo "3. ./ubuntu-setup.sh"
echo "4. ./ubuntu-start.sh"
