#!/bin/bash

# Script optimizado para iniciar PetACare en Ubuntu
# Ejecutar como: ./ubuntu-start.sh

echo "🐧 Iniciando PetACare en Ubuntu..."

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
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

show_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Verificar si Node.js está instalado
if ! command -v node &> /dev/null; then
    show_error "Node.js no está instalado. Ejecuta primero: ./ubuntu-setup.sh"
    exit 1
fi

# Verificar si MongoDB está corriendo
if ! pgrep -x "mongod" > /dev/null; then
    show_warning "MongoDB no está corriendo. Iniciando..."
    sudo systemctl start mongod
    sleep 3
    if ! pgrep -x "mongod" > /dev/null; then
        show_error "No se pudo iniciar MongoDB. Verifica la instalación."
        exit 1
    fi
fi

# Verificar directorios
if [ ! -d "crud-api" ]; then
    show_error "Directorio crud-api no encontrado"
    exit 1
fi

if [ ! -d "frontend" ]; then
    show_error "Directorio frontend no encontrado"
    exit 1
fi

# Función para limpiar procesos al salir
cleanup() {
    show_info "🛑 Deteniendo servidores..."
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
    fi
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID 2>/dev/null
    fi
    exit 0
}

# Capturar señal de interrupción
trap cleanup SIGINT SIGTERM

show_message "🚀 Iniciando Backend..."
cd crud-api
npm start &
BACKEND_PID=$!

# Esperar a que el backend inicie
show_info "Esperando a que el backend inicie..."
sleep 5

# Verificar si el backend está corriendo
if ! ps -p $BACKEND_PID > /dev/null; then
    show_error "El backend no se pudo iniciar. Verifica los logs."
    exit 1
fi

show_message "🌐 Iniciando Frontend..."
cd ../frontend
npm start &
FRONTEND_PID=$!

# Esperar a que el frontend inicie
sleep 3

# Verificar si el frontend está corriendo
if ! ps -p $FRONTEND_PID > /dev/null; then
    show_error "El frontend no se pudo iniciar. Verifica los logs."
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

show_message "✅ PetACare iniciado exitosamente!"
echo ""
show_info "🌐 URLs de acceso:"
echo "   Frontend: http://localhost:3002"
echo "   Backend API: http://localhost:3001/api"
echo ""
show_info "📊 PIDs de procesos:"
echo "   Backend PID: $BACKEND_PID"
echo "   Frontend PID: $FRONTEND_PID"
echo ""
show_info "Para detener los servidores, presiona Ctrl+C"

# Verificar conectividad
sleep 2
if curl -s http://localhost:3001/api/health > /dev/null 2>&1; then
    show_message "✅ Backend respondiendo correctamente"
else
    show_warning "⚠️  Backend puede no estar respondiendo en el puerto 3001"
fi

if curl -s http://localhost:3002 > /dev/null 2>&1; then
    show_message "✅ Frontend respondiendo correctamente"
else
    show_warning "⚠️  Frontend puede no estar respondiendo en el puerto 3002"
fi

# Mantener el script corriendo
show_info "Presiona Ctrl+C para detener los servidores..."
wait
