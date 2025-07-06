#!/bin/bash

# Script para cambiar la IP pública en todos los archivos necesarios
# Uso: ./update-ip.sh <nueva_ip>

if [ $# -eq 0 ]; then
    echo "❌ Error: Debes proporcionar la nueva IP pública"
    echo "Uso: ./update-ip.sh <nueva_ip>"
    echo "Ejemplo: ./update-ip.sh 20.106.185.16"
    exit 1
fi

NEW_IP=$1
OLD_IP="20.106.185.16"

echo "🔄 Actualizando IP pública de $OLD_IP a $NEW_IP..."

# Actualizar frontend/public/app.js
if [ -f "frontend/public/app.js" ]; then
    sed -i "s|http://$OLD_IP:3001|http://$NEW_IP:3001|g" frontend/public/app.js
    echo "✅ Actualizado frontend/public/app.js"
else
    echo "❌ No se encontró frontend/public/app.js"
fi

# Actualizar README.md
if [ -f "README.md" ]; then
    sed -i "s|http://$OLD_IP:300|http://$NEW_IP:300|g" README.md
    echo "✅ Actualizado README.md"
else
    echo "❌ No se encontró README.md"
fi

# Actualizar QUICK_INSTALL_GUIDE.md
if [ -f "QUICK_INSTALL_GUIDE.md" ]; then
    sed -i "s|http://$OLD_IP:300|http://$NEW_IP:300|g" QUICK_INSTALL_GUIDE.md
    echo "✅ Actualizado QUICK_INSTALL_GUIDE.md"
else
    echo "❌ No se encontró QUICK_INSTALL_GUIDE.md"
fi

# Actualizar IP_CONFIG.md
if [ -f "IP_CONFIG.md" ]; then
    sed -i "s|IP_PUBLICA=$OLD_IP|IP_PUBLICA=$NEW_IP|g" IP_CONFIG.md
    sed -i "s|http://$OLD_IP:300|http://$NEW_IP:300|g" IP_CONFIG.md
    echo "✅ Actualizado IP_CONFIG.md"
else
    echo "❌ No se encontró IP_CONFIG.md"
fi

echo "🎉 IP actualizada exitosamente a $NEW_IP"
echo "📋 Pasos siguientes:"
echo "1. Verifica que el firewall permita los puertos 3001 y 3002"
echo "2. Asegúrate de que la configuración de red permita el acceso externo"
echo "3. Reinicia Docker si es necesario: docker-compose down && docker-compose up -d"
