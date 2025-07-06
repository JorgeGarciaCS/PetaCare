#!/bin/bash

# Script de configuración automática para PetaCare con IP pública
# Uso: ./setup-public-ip.sh [IP_PUBLICA]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Obtener IP pública
get_public_ip() {
    if [ -n "$1" ]; then
        echo "$1"
    else
        # Intentar obtener IP pública automáticamente
        IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipecho.net/plain 2>/dev/null || echo "")
        if [ -n "$IP" ]; then
            echo "$IP"
        else
            show_error "No se pudo obtener la IP pública automáticamente"
            echo "Por favor, proporciona la IP pública manualmente:"
            echo "Uso: ./setup-public-ip.sh <IP_PUBLICA>"
            exit 1
        fi
    fi
}

# Función principal
main() {
    show_message "🚀 Configurando PetaCare para acceso externo..."
    
    # Obtener IP pública
    PUBLIC_IP=$(get_public_ip "$1")
    show_message "IP pública detectada: $PUBLIC_IP"
    
    # Verificar que estamos en el directorio correcto
    if [ ! -f "docker-compose.yml" ]; then
        show_error "No se encontró docker-compose.yml. ¿Estás en el directorio correcto?"
        exit 1
    fi
    
    # Crear directorio frontend/public si no existe
    if [ ! -d "frontend/public" ]; then
        show_message "Creando directorio frontend/public..."
        mkdir -p frontend/public
    fi
    
    # Verificar que app.js existe
    if [ ! -f "frontend/public/app.js" ]; then
        show_error "No se encontró frontend/public/app.js"
        show_message "Asegúrate de que la estructura del proyecto sea correcta"
        exit 1
    fi
    
    # Actualizar IP en app.js
    show_message "Actualizando IP en frontend/public/app.js..."
    sed -i "s|const API_BASE_URL = 'http://[0-9.]*:[0-9]*|const API_BASE_URL = 'http://$PUBLIC_IP:3001|g" frontend/public/app.js
    
    # Actualizar CORS en backend
    show_message "Actualizando CORS en crud-api/app.js..."
    if [ -f "crud-api/app.js" ]; then
        # Crear backup
        cp crud-api/app.js crud-api/app.js.backup
        
        # Actualizar CORS
        sed -i "s|origin: \[.*\]|origin: ['http://localhost:3002', 'http://localhost:3000', 'http://$PUBLIC_IP:3002', 'http://$PUBLIC_IP:3001']|g" crud-api/app.js
    fi
    
    # Configurar firewall
    show_message "Configurando firewall..."
    if command -v ufw &> /dev/null; then
        sudo ufw allow 3001/tcp
        sudo ufw allow 3002/tcp
        sudo ufw allow 22/tcp
        sudo ufw --force enable
        show_message "Firewall configurado correctamente"
    else
        show_warning "UFW no está instalado. Configura el firewall manualmente."
    fi
    
    # Verificar Docker
    show_message "Verificando Docker..."
    if ! command -v docker &> /dev/null; then
        show_error "Docker no está instalado. Instalando Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        show_message "Docker instalado. Reinicia la sesión para que los cambios tomen efecto."
    fi
    
    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        show_error "Docker Compose no está instalado. Instalando..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        show_message "Docker Compose instalado"
    fi
    
    # Detener servicios previos
    show_message "Deteniendo servicios previos..."
    docker-compose down 2>/dev/null || true
    
    # Limpiar contenedores e imágenes previas
    show_message "Limpiando contenedores previos..."
    docker system prune -f
    
    # Construir y ejecutar
    show_message "Construyendo y ejecutando contenedores..."
    docker-compose up -d --build
    
    # Esperar a que los servicios estén listos
    show_message "Esperando a que los servicios estén listos..."
    sleep 30
    
    # Verificar estado
    show_message "Verificando estado de los servicios..."
    docker-compose ps
    
    # Mostrar información de acceso
    echo
    echo -e "${BLUE}🎉 ¡Configuración completada!${NC}"
    echo
    echo -e "${GREEN}📋 URLs de Acceso:${NC}"
    echo -e "   Frontend: http://$PUBLIC_IP:3002"
    echo -e "   Backend:  http://$PUBLIC_IP:3001/api"
    echo
    echo -e "${GREEN}🔍 Verificación:${NC}"
    echo -e "   curl http://$PUBLIC_IP:3001/api/health"
    echo -e "   curl http://$PUBLIC_IP:3002"
    echo
    echo -e "${GREEN}🌐 Prueba desde tu navegador:${NC}"
    echo -e "   http://$PUBLIC_IP:3002"
    echo
    
    # Verificar conectividad
    show_message "Verificando conectividad..."
    if curl -s -o /dev/null -w "%{http_code}" "http://localhost:3001/api/health" | grep -q "200"; then
        show_message "✅ Backend responde correctamente"
    else
        show_warning "⚠️ Backend no responde. Verifica los logs: docker-compose logs backend"
    fi
    
    if curl -s -o /dev/null -w "%{http_code}" "http://localhost:3002" | grep -q "200"; then
        show_message "✅ Frontend responde correctamente"
    else
        show_warning "⚠️ Frontend no responde. Verifica los logs: docker-compose logs frontend"
    fi
    
    # Mostrar información adicional
    echo
    echo -e "${BLUE}📚 Documentación:${NC}"
    echo -e "   - PUBLIC_IP_DEPLOYMENT.md  - Guía de despliegue"
    echo -e "   - TESTING_GUIDE.md         - Guía de pruebas"
    echo -e "   - IP_CONFIG.md             - Configuración IP"
    echo
    echo -e "${BLUE}🛠️ Comandos útiles:${NC}"
    echo -e "   docker-compose logs        - Ver logs"
    echo -e "   docker-compose restart     - Reiniciar"
    echo -e "   docker-compose down        - Detener"
    echo
}

# Ejecutar función principal
main "$@"
