# 🐳 Comandos Rápidos Docker - PetaCare

## 📋 Configuración Inicial (ejecutar una sola vez)
```bash
# 1. Hacer ejecutables los scripts
chmod +x docker-*.sh

# 2. Ejecutar configuración inicial de Docker
./docker-setup-ubuntu.sh

# 3. Cerrar sesión y volver a iniciar (o ejecutar: newgrp docker)
```

## 🚀 Inicio Rápido con Docker

### Usar el gestor de Docker
```bash
# Iniciar contenedores
./docker-manage.sh start

# Ver estado
./docker-manage.sh status

# Ver logs
./docker-manage.sh logs

# Detener contenedores
./docker-manage.sh stop
```

### Comandos directos
```bash
# Iniciar todos los servicios
docker-compose up -d

# Detener todos los servicios
docker-compose down

# Ver logs
docker-compose logs

# Reconstruir imágenes
docker-compose build --no-cache
```

## 🔧 Gestión de Contenedores

### Comandos básicos
```bash
# Ver contenedores activos
docker ps

# Ver todos los contenedores
docker ps -a

# Ver logs de un servicio específico
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mongo

# Seguir logs en tiempo real
docker-compose logs -f

# Reiniciar un servicio específico
docker-compose restart backend
```

### Acceso a contenedores
```bash
# Acceder al shell del backend
docker-compose exec backend /bin/sh

# Acceder al shell del frontend
docker-compose exec frontend /bin/sh

# Acceder a MongoDB shell
docker-compose exec mongo mongosh petacare
```

## 🛠️ Desarrollo

### Instalar nuevas dependencias
```bash
# En backend
docker-compose exec backend npm install nueva-dependencia

# En frontend
docker-compose exec frontend npm install nueva-dependencia

# Reconstruir después de cambios en package.json
docker-compose build
```

### Debugging
```bash
# Ver logs detallados
docker-compose logs --tail=100

# Inspeccionar configuración
docker-compose config

# Ver recursos utilizados
docker stats

# Información detallada de un contenedor
docker inspect petacare-backend
```

## 🗄️ Gestión de Datos

### Backup de MongoDB
```bash
# Crear backup
docker-compose exec mongo mongodump --db petacare --out /tmp/backup

# Copiar backup al host
docker cp petacare-mongo:/tmp/backup ./backup_$(date +%Y%m%d)
```

### Restaurar datos
```bash
# Restaurar desde backup
docker-compose exec mongo mongorestore --db petacare /tmp/backup/petacare
```

### Limpiar volúmenes
```bash
# Detener contenedores y eliminar volúmenes
docker-compose down -v

# Eliminar volúmenes específicos
docker volume rm petacare_mongo_data
```

## 🔄 Ciclo de Desarrollo

### Desarrollo activo
```bash
# 1. Iniciar en modo desarrollo
docker-compose up

# 2. Hacer cambios en el código (se reflejan automáticamente)

# 3. Ver logs en tiempo real
docker-compose logs -f

# 4. Reiniciar servicios si es necesario
docker-compose restart backend
```

### Actualización de dependencias
```bash
# 1. Actualizar package.json
# 2. Reconstruir imágenes
docker-compose build --no-cache

# 3. Reiniciar servicios
docker-compose up -d
```

## 🌐 URLs y Puertos

- **Frontend**: http://localhost:3002
- **Backend**: http://localhost:3001/api
- **MongoDB**: localhost:27017

## 🧹 Limpieza

### Limpieza básica
```bash
# Detener y eliminar contenedores
docker-compose down

# Eliminar imágenes no utilizadas
docker image prune

# Eliminar volúmenes no utilizados
docker volume prune
```

### Limpieza completa
```bash
# Usar el gestor
./docker-manage.sh clean

# O manualmente
docker-compose down -v
docker rmi $(docker images -q petacare-*)
docker volume prune -f
docker system prune -a
```

## 📊 Monitoreo

### Logs y estado
```bash
# Estado de contenedores
docker-compose ps

# Uso de recursos
docker stats

# Logs por servicio
docker-compose logs backend --tail=50
docker-compose logs frontend --tail=50
docker-compose logs mongo --tail=50
```

### Healthcheck
```bash
# Verificar conectividad
curl http://localhost:3001/api/health
curl http://localhost:3002

# Verificar MongoDB
docker-compose exec mongo mongosh --eval "db.runCommand('ping')"
```

## 🔧 Configuración Avanzada

### Variables de entorno
```bash
# Editar .env
nano .env

# Aplicar cambios
docker-compose down
docker-compose up -d
```

### Configuración de red
```bash
# Ver redes Docker
docker network ls

# Inspeccionar red del proyecto
docker network inspect petacare_petacare-network
```

## 🆘 Troubleshooting

### Problemas comunes
```bash
# Puerto ocupado
docker-compose down
sudo lsof -i :3001
sudo kill -9 PID

# Problemas de permisos
sudo chown -R $USER:$USER .
newgrp docker

# Contenedor no inicia
docker-compose logs nombre-servicio
docker-compose up nombre-servicio

# MongoDB no conecta
docker-compose restart mongo
docker-compose logs mongo
```

### Reinicio completo
```bash
# Detener todo
docker-compose down -v

# Limpiar imágenes
docker-compose build --no-cache

# Iniciar de nuevo
docker-compose up -d
```

## 🎯 Comandos de Producción

### Configuración de producción
```bash
# Usar archivo de producción
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Backup automático
./docker-manage.sh backup

# Monitoreo
docker-compose logs -f --tail=100
```
