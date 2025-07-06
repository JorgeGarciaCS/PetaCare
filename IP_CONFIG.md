# Configuración de IP Pública para PetaCare

## IP Pública Actual
IP_PUBLICA=20.106.185.16

## URLs de Acceso
FRONTEND_URL=http://20.106.185.16:3002
BACKEND_URL=http://20.106.185.16:3001/api

## Puertos
FRONTEND_PORT=3002
BACKEND_PORT=3001
MONGO_PORT=27017

## Configuración de Red
# Asegúrate de que el firewall permita estos puertos:
# sudo ufw allow 3001
# sudo ufw allow 3002

## Configuración de Azure (si aplica)
# En Azure Portal, asegúrate de que los puertos estén abiertos en:
# - Network Security Group
# - VM Network Settings

## Notas
# Si cambias la IP pública, actualiza:
# 1. frontend/public/app.js (línea 2)
# 2. Esta documentación
# 3. README.md y guías de instalación
