#!/bin/bash

# Script para clonar e instalar PetaCare desde GitHub
# Ejecutar como: ./clone-and-install.sh

echo "🐾 Clonando e instalando PetaCare desde GitHub..."

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

# Verificar si Git está instalado
if ! command -v git &> /dev/null; then
    show_error "Git no está instalado. Instalando..."
    sudo apt update
    sudo apt install git -y
fi

# Verificar si el directorio ya existe
if [ -d "PetaCare" ]; then
    show_warning "El directorio PetaCare ya existe."
    read -p "¿Quieres eliminarlo y clonar de nuevo? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf PetaCare
        show_message "Directorio eliminado"
    else
        show_error "Instalación cancelada"
        exit 1
    fi
fi

show_message "Clonando proyecto desde GitHub..."
git clone https://github.com/JorgeGarciaCS/PetaCare.git

# Verificar si el clone fue exitoso
if [ ! -d "PetaCare" ]; then
    show_error "Error al clonar el repositorio"
    exit 1
fi

cd PetaCare

show_message "Configurando permisos..."
chmod +x *.sh

show_message "✅ Proyecto clonado exitosamente!"
echo ""
show_info "📋 Próximos pasos:"
echo ""
echo "🐳 Para usar Docker (recomendado):"
echo "   cd PetaCare"
echo "   ./docker-setup-ubuntu.sh"
echo "   # Cerrar sesión y volver a abrir"
echo "   ./docker-start.sh"
echo ""
echo "🔧 Para instalación manual:"
echo "   cd PetaCare"
echo "   ./ubuntu-setup.sh"
echo "   ./ubuntu-start.sh"
echo ""
echo "📖 Documentación:"
echo "   - Docker: DOCKER_MIGRATION_GUIDE.md"
echo "   - Manual: MIGRATION_GUIDE_UBUNTU.md"
echo "   - Rápido: QUICK_INSTALL_GUIDE.md"
echo ""
echo "🌐 URLs finales:"
echo "   - Frontend: http://localhost:3002"
echo "   - Backend: http://localhost:3001/api"
