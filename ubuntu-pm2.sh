#!/bin/bash

# Script para usar PM2 en producción - PetACare Ubuntu
# Ejecutar como: ./ubuntu-pm2.sh

echo "🔧 Configurando PetACare con PM2 para producción..."

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

# Verificar si PM2 está instalado
if ! command -v pm2 &> /dev/null; then
    show_error "PM2 no está instalado. Ejecuta: sudo npm install -g pm2"
    exit 1
fi

# Detener procesos existentes si están corriendo
show_message "Deteniendo procesos existentes..."
pm2 delete petacare-backend 2>/dev/null || true
pm2 delete petacare-frontend 2>/dev/null || true

# Iniciar backend
show_message "Iniciando Backend con PM2..."
cd crud-api
pm2 start app.js --name "petacare-backend" --watch --ignore-watch="node_modules"

# Iniciar frontend
show_message "Iniciando Frontend con PM2..."
cd ../frontend
pm2 start server.js --name "petacare-frontend" --watch --ignore-watch="node_modules"

# Mostrar estado
show_message "Estado de los procesos:"
pm2 status

# Configurar para inicio automático
show_message "Configurando inicio automático..."
pm2 startup
pm2 save

show_message "✅ PetACare configurado con PM2!"
echo ""
echo "📋 Comandos útiles de PM2:"
echo "   pm2 status          - Ver estado de procesos"
echo "   pm2 logs            - Ver logs de todos los procesos"
echo "   pm2 logs petacare-backend - Ver logs del backend"
echo "   pm2 logs petacare-frontend - Ver logs del frontend"
echo "   pm2 restart all     - Reiniciar todos los procesos"
echo "   pm2 stop all        - Detener todos los procesos"
echo "   pm2 delete all      - Eliminar todos los procesos"
echo "   pm2 monit           - Monitor en tiempo real"
echo ""
echo "🌐 URLs de acceso:"
echo "   Frontend: http://localhost:3002"
echo "   Backend: http://localhost:3001"
