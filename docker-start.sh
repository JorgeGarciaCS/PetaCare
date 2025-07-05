#!/bin/bash

# Script para iniciar PetaCare con Docker
# Ejecutar como: ./docker-start.sh

echo "🐳 Iniciando PetaCare con Docker..."

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

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    show_error "Docker no está instalado. Ejecuta primero: ./docker-setup-ubuntu.sh"
    exit 1
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    show_error "Docker Compose no está instalado. Ejecuta primero: ./docker-setup-ubuntu.sh"
    exit 1
fi

# Verificar si el usuario puede ejecutar Docker
if ! docker ps &> /dev/null; then
    show_error "No puedes ejecutar Docker sin sudo. Ejecuta: sudo usermod -aG docker $USER"
    show_error "Luego cierra sesión y vuelve a iniciar sesión, o ejecuta: newgrp docker"
    exit 1
fi

# Verificar archivos necesarios
if [ ! -f "docker-compose.yml" ]; then
    show_error "docker-compose.yml no encontrado"
    exit 1
fi

# Función para limpiar al salir
cleanup() {
    show_info "🛑 Deteniendo contenedores..."
    docker-compose down
    exit 0
}

# Capturar señal de interrupción
trap cleanup SIGINT SIGTERM

show_message "🏗️  Construyendo imágenes Docker..."
docker-compose build

show_message "🚀 Iniciando contenedores..."
docker-compose up -d

# Esperar a que los contenedores se inicien
show_info "⏳ Esperando a que los servicios se inicien..."
sleep 10

# Verificar estado de los contenedores
show_message "📊 Estado de los contenedores:"
docker-compose ps

# Verificar logs
show_message "📋 Logs de inicio:"
docker-compose logs --tail=5

# Verificar conectividad
show_info "🔍 Verificando conectividad..."
sleep 5

# Verificar backend
if curl -s http://localhost:3001/api/health > /dev/null 2>&1; then
    show_message "✅ Backend respondiendo correctamente"
else
    show_warning "⚠️  Backend puede no estar listo aún"
fi

# Verificar frontend
if curl -s http://localhost:3002 > /dev/null 2>&1; then
    show_message "✅ Frontend respondiendo correctamente"
else
    show_warning "⚠️  Frontend puede no estar listo aún"
fi

show_message "🎉 PetaCare iniciado con Docker!"
echo ""
show_info "🌐 URLs de acceso:"
echo "   Frontend: http://localhost:3002"
echo "   Backend API: http://localhost:3001/api"
echo ""
show_info "🔧 Comandos útiles:"
echo "   docker-compose logs        # Ver todos los logs"
echo "   docker-compose logs -f     # Ver logs en tiempo real"
echo "   docker-compose ps          # Ver estado de contenedores"
echo "   docker-compose down        # Detener contenedores"
echo "   docker-compose restart     # Reiniciar contenedores"
echo ""
show_info "📊 Para ver logs en tiempo real ejecuta: docker-compose logs -f"
show_info "🛑 Para detener los contenedores ejecuta: docker-compose down"

# Opción de mostrar logs en tiempo real
echo ""
read -p "¿Quieres ver los logs en tiempo real? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    show_info "Mostrando logs en tiempo real (Ctrl+C para salir)..."
    docker-compose logs -f
fi
