#!/bin/bash

# Script de verificación final para PetaCare
# Verifica que todo esté configurado correctamente para acceso externo

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PUBLIC_IP="20.106.185.16"
BACKEND_PORT="3001"
FRONTEND_PORT="3002"

echo -e "${BLUE}🔍 Verificación Final - PetaCare${NC}"
echo "=================================="

# 1. Verificar estructura de archivos
echo -e "\n${YELLOW}1. Verificando estructura de archivos...${NC}"
check_file() {
    if [ -f "$1" ]; then
        echo -e "   ✅ $1"
    else
        echo -e "   ❌ $1 - FALTA"
        return 1
    fi
}

check_file "docker-compose.yml"
check_file "frontend/public/app.js"
check_file "frontend/public/index.html"
check_file "crud-api/app.js"
check_file "PUBLIC_IP_DEPLOYMENT.md"
check_file "TESTING_GUIDE.md"
check_file "setup-public-ip.sh"

# 2. Verificar configuración de IP en app.js
echo -e "\n${YELLOW}2. Verificando configuración de IP...${NC}"
if grep -q "http://$PUBLIC_IP:$BACKEND_PORT" frontend/public/app.js; then
    echo -e "   ✅ IP pública configurada en app.js"
else
    echo -e "   ❌ IP pública NO configurada en app.js"
    echo -e "   📝 Debe contener: http://$PUBLIC_IP:$BACKEND_PORT"
fi

# 3. Verificar CORS en backend
echo -e "\n${YELLOW}3. Verificando configuración CORS...${NC}"
if grep -q "http://$PUBLIC_IP:$FRONTEND_PORT" crud-api/app.js; then
    echo -e "   ✅ CORS configurado para IP pública"
else
    echo -e "   ❌ CORS NO configurado para IP pública"
    echo -e "   📝 Debe incluir: http://$PUBLIC_IP:$FRONTEND_PORT"
fi

# 4. Verificar endpoint de salud
echo -e "\n${YELLOW}4. Verificando endpoint de salud...${NC}"
if grep -q "/api/health" crud-api/app.js; then
    echo -e "   ✅ Endpoint de salud configurado"
else
    echo -e "   ❌ Endpoint de salud NO configurado"
fi

# 5. Verificar Docker
echo -e "\n${YELLOW}5. Verificando Docker...${NC}"
if command -v docker &> /dev/null; then
    echo -e "   ✅ Docker instalado"
    if docker ps &> /dev/null; then
        echo -e "   ✅ Docker daemon corriendo"
    else
        echo -e "   ❌ Docker daemon NO está corriendo"
    fi
else
    echo -e "   ❌ Docker NO instalado"
fi

if command -v docker-compose &> /dev/null; then
    echo -e "   ✅ Docker Compose instalado"
else
    echo -e "   ❌ Docker Compose NO instalado"
fi

# 6. Verificar firewall
echo -e "\n${YELLOW}6. Verificando firewall...${NC}"
if command -v ufw &> /dev/null; then
    if ufw status | grep -q "Status: active"; then
        echo -e "   ✅ UFW está activo"
        if ufw status | grep -q "$BACKEND_PORT"; then
            echo -e "   ✅ Puerto $BACKEND_PORT permitido"
        else
            echo -e "   ❌ Puerto $BACKEND_PORT NO permitido"
        fi
        if ufw status | grep -q "$FRONTEND_PORT"; then
            echo -e "   ✅ Puerto $FRONTEND_PORT permitido"
        else
            echo -e "   ❌ Puerto $FRONTEND_PORT NO permitido"
        fi
    else
        echo -e "   ⚠️ UFW está inactivo"
    fi
else
    echo -e "   ⚠️ UFW no instalado"
fi

# 7. Verificar contenedores (si están corriendo)
echo -e "\n${YELLOW}7. Verificando contenedores...${NC}"
if command -v docker-compose &> /dev/null; then
    if docker-compose ps | grep -q "Up"; then
        echo -e "   ✅ Contenedores ejecutándose"
        docker-compose ps
    else
        echo -e "   ⚠️ Contenedores NO están ejecutándose"
        echo -e "   📝 Ejecuta: docker-compose up -d"
    fi
else
    echo -e "   ❌ No se puede verificar contenedores"
fi

# 8. Verificar conectividad (si los servicios están corriendo)
echo -e "\n${YELLOW}8. Verificando conectividad...${NC}"
if curl -s -o /dev/null -w "%{http_code}" "http://localhost:$BACKEND_PORT/api/health" 2>/dev/null | grep -q "200"; then
    echo -e "   ✅ Backend responde localmente"
else
    echo -e "   ❌ Backend NO responde localmente"
fi

if curl -s -o /dev/null -w "%{http_code}" "http://localhost:$FRONTEND_PORT" 2>/dev/null | grep -q "200"; then
    echo -e "   ✅ Frontend responde localmente"
else
    echo -e "   ❌ Frontend NO responde localmente"
fi

# 9. Verificar conectividad externa (si es posible)
echo -e "\n${YELLOW}9. Verificando conectividad externa...${NC}"
if curl -s -o /dev/null -w "%{http_code}" "http://$PUBLIC_IP:$BACKEND_PORT/api/health" 2>/dev/null | grep -q "200"; then
    echo -e "   ✅ Backend accesible externamente"
else
    echo -e "   ❌ Backend NO accesible externamente"
    echo -e "   📝 Verifica firewall y configuración de red"
fi

if curl -s -o /dev/null -w "%{http_code}" "http://$PUBLIC_IP:$FRONTEND_PORT" 2>/dev/null | grep -q "200"; then
    echo -e "   ✅ Frontend accesible externamente"
else
    echo -e "   ❌ Frontend NO accesible externamente"
    echo -e "   📝 Verifica firewall y configuración de red"
fi

# Resumen final
echo -e "\n${BLUE}📋 Resumen de Verificación${NC}"
echo "========================="
echo -e "IP Pública: $PUBLIC_IP"
echo -e "Frontend: http://$PUBLIC_IP:$FRONTEND_PORT"
echo -e "Backend: http://$PUBLIC_IP:$BACKEND_PORT/api"
echo -e "Health Check: http://$PUBLIC_IP:$BACKEND_PORT/api/health"

echo -e "\n${GREEN}🚀 Próximos Pasos:${NC}"
echo "1. Si hay errores, corrígelos siguiendo las indicaciones"
echo "2. Ejecuta: docker-compose up -d --build"
echo "3. Prueba desde tu navegador: http://$PUBLIC_IP:$FRONTEND_PORT"
echo "4. Consulta TESTING_GUIDE.md para más pruebas"

echo -e "\n${BLUE}📚 Documentación:${NC}"
echo "- PUBLIC_IP_DEPLOYMENT.md - Guía completa"
echo "- TESTING_GUIDE.md - Guía de pruebas"
echo "- CHANGELOG.md - Historial de cambios"

echo -e "\n${GREEN}✅ Verificación completada${NC}"
