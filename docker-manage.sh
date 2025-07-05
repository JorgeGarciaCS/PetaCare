#!/bin/bash

# Script para gestionar PetaCare con Docker
# Ejecutar como: ./docker-manage.sh [comando]

echo "🐳 Gestor de PetaCare con Docker"

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

# Función para mostrar ayuda
show_help() {
    echo "Uso: ./docker-manage.sh [comando]"
    echo ""
    echo "Comandos disponibles:"
    echo "  start     - Iniciar contenedores"
    echo "  stop      - Detener contenedores"
    echo "  restart   - Reiniciar contenedores"
    echo "  rebuild   - Reconstruir imágenes y reiniciar"
    echo "  logs      - Ver logs de todos los servicios"
    echo "  logs-f    - Ver logs en tiempo real"
    echo "  status    - Ver estado de contenedores"
    echo "  clean     - Limpiar contenedores e imágenes"
    echo "  backup    - Hacer backup de la base de datos"
    echo "  shell     - Acceder a shell del backend"
    echo "  mongo     - Acceder a MongoDB shell"
    echo "  help      - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  ./docker-manage.sh start"
    echo "  ./docker-manage.sh logs-f"
    echo "  ./docker-manage.sh rebuild"
}

# Verificar si Docker está disponible
check_docker() {
    if ! command -v docker &> /dev/null; then
        show_error "Docker no está instalado"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        show_error "Docker Compose no está instalado"
        exit 1
    fi
    
    if ! docker ps &> /dev/null; then
        show_error "No puedes ejecutar Docker sin sudo"
        exit 1
    fi
}

# Comando: start
start_containers() {
    show_message "🚀 Iniciando contenedores..."
    docker-compose up -d
    show_message "✅ Contenedores iniciados"
    docker-compose ps
}

# Comando: stop
stop_containers() {
    show_message "🛑 Deteniendo contenedores..."
    docker-compose down
    show_message "✅ Contenedores detenidos"
}

# Comando: restart
restart_containers() {
    show_message "🔄 Reiniciando contenedores..."
    docker-compose restart
    show_message "✅ Contenedores reiniciados"
    docker-compose ps
}

# Comando: rebuild
rebuild_containers() {
    show_message "🏗️  Reconstruyendo imágenes..."
    docker-compose down
    docker-compose build --no-cache
    docker-compose up -d
    show_message "✅ Contenedores reconstruidos e iniciados"
    docker-compose ps
}

# Comando: logs
show_logs() {
    show_message "📋 Logs de todos los servicios:"
    docker-compose logs --tail=50
}

# Comando: logs-f
show_logs_follow() {
    show_message "📋 Logs en tiempo real (Ctrl+C para salir):"
    docker-compose logs -f
}

# Comando: status
show_status() {
    show_message "📊 Estado de contenedores:"
    docker-compose ps
    echo ""
    show_message "🔍 Recursos utilizados:"
    docker stats --no-stream
}

# Comando: clean
clean_docker() {
    show_warning "🧹 Limpiando contenedores e imágenes..."
    read -p "¿Estás seguro? Esto eliminará todos los contenedores e imágenes del proyecto (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down -v
        docker-compose rm -f
        docker rmi $(docker images -q petacare-*)
        docker volume prune -f
        show_message "✅ Limpieza completada"
    else
        show_message "❌ Limpieza cancelada"
    fi
}

# Comando: backup
backup_database() {
    show_message "💾 Creando backup de la base de datos..."
    BACKUP_DIR="./backups"
    mkdir -p $BACKUP_DIR
    BACKUP_FILE="$BACKUP_DIR/petacare_backup_$(date +%Y%m%d_%H%M%S).gz"
    
    docker-compose exec -T mongo mongodump --db petacare --archive | gzip > $BACKUP_FILE
    show_message "✅ Backup creado: $BACKUP_FILE"
}

# Comando: shell
access_shell() {
    show_message "🔧 Accediendo al shell del backend..."
    docker-compose exec backend /bin/sh
}

# Comando: mongo
access_mongo() {
    show_message "🍃 Accediendo a MongoDB shell..."
    docker-compose exec mongo mongosh petacare
}

# Verificar Docker
check_docker

# Procesar comandos
case "$1" in
    start)
        start_containers
        ;;
    stop)
        stop_containers
        ;;
    restart)
        restart_containers
        ;;
    rebuild)
        rebuild_containers
        ;;
    logs)
        show_logs
        ;;
    logs-f)
        show_logs_follow
        ;;
    status)
        show_status
        ;;
    clean)
        clean_docker
        ;;
    backup)
        backup_database
        ;;
    shell)
        access_shell
        ;;
    mongo)
        access_mongo
        ;;
    help|--help|-h)
        show_help
        ;;
    "")
        show_error "Comando requerido"
        show_help
        exit 1
        ;;
    *)
        show_error "Comando desconocido: $1"
        show_help
        exit 1
        ;;
esac
