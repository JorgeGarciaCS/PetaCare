# 🎯 PetaCare - Pasos de Instalación Actualizados

## 📍 Repositorio GitHub
**https://github.com/JorgeGarciaCS/PetaCare**

## 🚀 Instalación en Ubuntu - Pasos Exactos

### 1. Preparar Ubuntu
```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Git (si no está instalado)
sudo apt install git -y
```

### 2. Clonar el proyecto
```bash
# Ir al directorio home
cd ~

# Clonar desde GitHub
git clone https://github.com/JorgeGarciaCS/PetaCare.git

# Entrar al directorio
cd PetaCare
```

### 3. Configurar permisos
```bash
# Hacer ejecutables todos los scripts
chmod +x *.sh
```

### 4. Instalar con Docker (Recomendado)
```bash
# Instalar Docker y configurar todo
./docker-setup-ubuntu.sh

# IMPORTANTE: Cerrar sesión y volver a abrir
exit
# (Volver a conectar a Ubuntu)

# O aplicar cambios del grupo Docker
newgrp docker
```

### 5. Iniciar la aplicación
```bash
# Entrar al directorio del proyecto
cd ~/PetaCare

# Iniciar con Docker
./docker-start.sh

# Ver estado
./docker-manage.sh status
```

## 🌐 URLs de Acceso

- **Frontend**: http://localhost:3002
- **Backend**: http://localhost:3001/api

## 📋 Comandos de Gestión

```bash
# Ver estado de contenedores
./docker-manage.sh status

# Ver logs
./docker-manage.sh logs

# Ver logs en tiempo real
./docker-manage.sh logs-f

# Detener contenedores
./docker-manage.sh stop

# Reiniciar contenedores
./docker-manage.sh restart

# Hacer backup
./docker-manage.sh backup

# Acceder al shell del backend
./docker-manage.sh shell

# Acceder a MongoDB
./docker-manage.sh mongo
```

## 🔄 Instalación Manual (Sin Docker)

Si prefieres no usar Docker:

```bash
# Después de clonar el proyecto
cd ~/PetaCare

# Configurar Ubuntu manualmente
./ubuntu-setup.sh

# Iniciar en desarrollo
./ubuntu-start.sh

# O iniciar en producción
./ubuntu-pm2.sh
```

## 🛠️ Comandos de Desarrollo

```bash
# Actualizar el proyecto
git pull origin main

# Reconstruir contenedores si hay cambios
./docker-manage.sh rebuild

# Ver logs específicos
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mongo
```

## 🆘 Solución de Problemas

### Si Docker no funciona
```bash
# Verificar instalación
docker --version
docker-compose --version

# Verificar permisos
docker ps

# Si da error de permisos
newgrp docker
```

### Si los puertos están ocupados
```bash
# Ver qué usa los puertos
sudo lsof -i :3001
sudo lsof -i :3002

# Detener contenedores
./docker-manage.sh stop
```

### Para empezar de nuevo
```bash
# Detener y limpiar todo
./docker-manage.sh clean

# Volver a iniciar
./docker-start.sh
```

## 📚 Documentación

- **Guía completa Docker**: `DOCKER_MIGRATION_GUIDE.md`
- **Comandos rápidos**: `DOCKER_QUICK_COMMANDS.md`
- **Instalación manual**: `MIGRATION_GUIDE_UBUNTU.md`

## ✅ Verificación Final

Una vez todo instalado, deberías poder:

1. Acceder a http://localhost:3002 (Frontend)
2. Acceder a http://localhost:3001/api (Backend)
3. Ver contenedores corriendo: `docker ps`
4. Crear usuarios, publicaciones, comentarios
5. Subir imágenes en publicaciones y productos

¡Listo! 🎉
