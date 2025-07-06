# 🚀 Guía de Instalación Rápida - PetaCare

## Proyecto ya disponible en GitHub: https://github.com/JorgeGarciaCS/PetaCare

## 🌍 Instalación con IP Pública (Acceso Externo)

### 🎯 Método Automático (Recomendado)
```bash
# 1. Clonar el proyecto
git clone https://github.com/JorgeGarciaCS/PetaCare.git
cd PetaCare

# 2. Configuración automática
chmod +x setup-public-ip.sh
./setup-public-ip.sh

# 3. ¡Listo! Accede desde cualquier PC:
# http://20.106.185.16:3002
```

### 🔧 Método Manual
```bash
# 1. Clonar el proyecto
git clone https://github.com/JorgeGarciaCS/PetaCare.git
cd PetaCare

# 2. Configurar firewall
sudo ufw allow 3001
sudo ufw allow 3002
sudo ufw enable

# 3. Instalar Docker (si no está instalado)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 4. Ejecutar aplicación
docker-compose up -d --build
```

## 🌐 Acceso

- **Frontend**: http://20.106.185.16:3002
- **Backend**: http://20.106.185.16:3001/api
- **Health Check**: http://20.106.185.16:3001/api/health

## 📋 Comandos útiles

```bash
# Verificar configuración
./verify-setup.sh

# Ver estado de contenedores
docker-compose ps

# Ver logs
docker-compose logs

# Ver logs en tiempo real
docker-compose logs -f

# Detener contenedores
docker-compose down

# Reiniciar contenedores
docker-compose restart

# Limpiar y reconstruir
docker-compose down
docker system prune -f
docker-compose up -d --build
```

## 🔍 Verificación

```bash
# Verificar backend
curl http://20.106.185.16:3001/api/health

# Verificar frontend
curl http://20.106.185.16:3002

# Verificación completa
./verify-setup.sh
```

## 📱 Acceso desde Cualquier Dispositivo

### Navegador Web
- Ve a: `http://20.106.185.16:3002`
- Funciona desde cualquier PC, móvil, tablet

### Desde tu PC/Móvil
- Misma URL desde cualquier red
- WiFi, datos móviles, cualquier ISP
- Acceso desde cualquier parte del mundo

## 🔧 Instalación Manual (Sin Docker)

### 1. Clonar el proyecto
```bash
cd ~
git clone https://github.com/JorgeGarciaCS/PetaCare.git
cd PetaCare
```

### 2. Configurar manualmente
```bash
# Hacer ejecutables los scripts
chmod +x *.sh

# Configurar Ubuntu (instala Node.js, MongoDB, etc.)
./ubuntu-setup.sh
```

### 3. Iniciar la aplicación
```bash
# Desarrollo
./ubuntu-start.sh

# Producción con PM2
./ubuntu-pm2.sh
```

## 🎯 Resumen de URLs

- **Repositorio**: https://github.com/JorgeGarciaCS/PetaCare
- **Frontend**: http://20.106.185.16:3002
- **Backend**: http://20.106.185.16:3001/api
- **Health Check**: http://20.106.185.16:3001/api/health

## 📚 Documentación completa

- **Acceso Externo**: `PUBLIC_IP_DEPLOYMENT.md`
- **Pruebas**: `TESTING_GUIDE.md`
- **Configuración IP**: `IP_CONFIG.md`
- **Docker**: `DOCKER_MIGRATION_GUIDE.md`
- **Manual**: `MIGRATION_GUIDE_UBUNTU.md`
- **Cambios**: `CHANGELOG.md`

## 🛠️ Scripts Disponibles

- `setup-public-ip.sh` - Configuración automática completa
- `verify-setup.sh` - Verificación de configuración
- `update-ip.sh` - Cambiar IP pública rápidamente

## 🆘 Solución de Problemas

### No puedo acceder desde fuera
1. Verifica firewall: `sudo ufw status`
2. Verifica Docker: `docker-compose ps`
3. Usa verificación: `./verify-setup.sh`

### Error de CORS
1. Verifica IP en `frontend/public/app.js`
2. Verifica CORS en `crud-api/app.js`
3. Reinicia: `docker-compose restart`

### Más ayuda
- Consulta `TESTING_GUIDE.md`
- Revisa logs: `docker-compose logs`
- Verifica `PUBLIC_IP_DEPLOYMENT.md`

¡Listo para usar! 🎉
