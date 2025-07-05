# 🐳 Guía de Migración con Docker - PetACare

Esta guía te ayudará a migrar y ejecutar tu proyecto PetACare usando Docker en Ubuntu.

## 📋 Prerrequisitos en Ubuntu

### 1. Actualizar el sistema
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Docker
```bash
# Instalar dependencias
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Agregar clave GPG de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Agregar repositorio de Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizar e instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Verificar instalación
sudo docker --version
```

### 3. Instalar Docker Compose
```bash
# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Dar permisos de ejecución
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalación
docker-compose --version
```

### 4. Configurar Docker para usuario actual
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Reiniciar sesión o aplicar cambios
newgrp docker

# Verificar que funciona sin sudo
docker ps
```

### 5. Instalar Git (si no está instalado)
```bash
sudo apt install git -y
```

## 🚀 Migración del Proyecto

### Opción 1: Transferir archivos directamente

#### Paso 1: Crear directorio del proyecto
```bash
mkdir -p ~/PetaCare
cd ~/PetaCare
```

#### Paso 2: Transferir archivos
```bash
# Si usas SCP desde Windows (desde PowerShell o CMD)
scp -r C:\Users\jg153\PetaCare-1\* username@ubuntu-ip:~/PetaCare/
```

### Opción 2: Usar Git (recomendado)

#### Paso 1: Crear repositorio Git (desde Windows)
```bash
# En Windows, dentro del directorio del proyecto
git init
git add .
git commit -m "Initial commit - PetaCare project with Docker"

# Subir a GitHub/GitLab (opcional pero recomendado)
git remote add origin https://github.com/tuusuario/petacare.git
git push -u origin main
```

#### Paso 2: Clonar en Ubuntu
```bash
cd ~
git clone https://github.com/tuusuario/petacare.git PetaCare
cd PetaCare
```

## 🐳 Configuración y Ejecución con Docker

### Paso 1: Verificar archivos Docker
Asegúrate de que tienes estos archivos:
- `docker-compose.yml` (en la raíz)
- `crud-api/Dockerfile` (para backend)
- `frontend/Dockerfile` (para frontend)

### Paso 2: Construir y ejecutar contenedores
```bash
# Construir imágenes y ejecutar contenedores
docker-compose up --build

# O para ejecutar en segundo plano
docker-compose up --build -d
```

### Paso 3: Verificar que todo funciona
```bash
# Ver contenedores ejecutándose
docker ps

# Ver logs de todos los servicios
docker-compose logs

# Ver logs de un servicio específico
docker-compose logs backend
docker-compose logs frontend
docker-compose logs mongo
```

## 🌐 Acceso a la aplicación

Una vez iniciada la aplicación, podrás acceder a:

- **Frontend**: http://localhost:3002
- **Backend API**: http://localhost:3001/api
- **MongoDB**: localhost:27017 (para herramientas de administración)
- **Si accedes desde otra máquina**: http://IP-DE-TU-UBUNTU:3002

## 🔧 Comandos útiles de Docker

### Gestión de contenedores
```bash
# Iniciar servicios
docker-compose up

# Iniciar servicios en segundo plano
docker-compose up -d

# Detener servicios
docker-compose down

# Detener y eliminar volúmenes
docker-compose down -v

# Reconstruir imágenes
docker-compose build

# Reconstruir y reiniciar
docker-compose up --build

# Ver estado de contenedores
docker-compose ps

# Ver logs en tiempo real
docker-compose logs -f

# Acceder a un contenedor
docker exec -it petacare-backend /bin/sh
docker exec -it petacare-frontend /bin/sh
docker exec -it petacare-mongo mongosh
```

### Gestión de imágenes y volúmenes
```bash
# Ver imágenes
docker images

# Eliminar imágenes no utilizadas
docker image prune

# Ver volúmenes
docker volume ls

# Eliminar volúmenes no utilizados
docker volume prune

# Limpiar sistema Docker
docker system prune -a
```

## 🔥 Configuración de Firewall

```bash
# Permitir puertos necesarios
sudo ufw allow 3001/tcp  # Backend
sudo ufw allow 3002/tcp  # Frontend
sudo ufw allow 27017/tcp # MongoDB (solo si necesitas acceso externo)

# Habilitar firewall
sudo ufw enable
```

## 🛠️ Desarrollo con Docker

### Modo desarrollo con hot reload
El `docker-compose.yml` está configurado con volúmenes para desarrollo:
- Los cambios en el código se reflejan automáticamente
- No necesitas reconstruir la imagen para cambios menores

### Ejecutar comandos en contenedores
```bash
# Instalar nuevas dependencias en backend
docker-compose exec backend npm install nueva-dependencia

# Ejecutar comandos en el contenedor de MongoDB
docker-compose exec mongo mongosh

# Ver logs específicos
docker-compose exec backend npm run logs
```

## 🔧 Configuración avanzada

### Variables de entorno
Puedes crear un archivo `.env` en la raíz del proyecto:
```env
# .env
MONGODB_URI=mongodb://mongo:27017/petacare
JWT_SECRET=tu-jwt-secret-aqui
SESSION_SECRET=tu-session-secret-aqui
NODE_ENV=development
```

### Configuración de producción
Para producción, crea un `docker-compose.prod.yml`:
```yaml
version: '3.8'

services:
  backend:
    environment:
      - NODE_ENV=production
    restart: always
    
  frontend:
    environment:
      - NODE_ENV=production
    restart: always
    
  mongo:
    restart: always
    volumes:
      - mongo_data_prod:/data/db
```

Ejecutar en producción:
```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## 🆘 Solución de problemas comunes

### Puerto ya en uso
```bash
# Verificar qué está usando el puerto
sudo lsof -i :3001
sudo lsof -i :3002

# Detener servicios Docker
docker-compose down

# Eliminar contenedores si es necesario
docker-compose down --remove-orphans
```

### Problemas de permisos
```bash
# Cambiar propietario de archivos
sudo chown -R $USER:$USER ~/PetaCare

# Verificar permisos Docker
sudo usermod -aG docker $USER
newgrp docker
```

### Problemas de conexión a MongoDB
```bash
# Ver logs de MongoDB
docker-compose logs mongo

# Reiniciar solo MongoDB
docker-compose restart mongo

# Verificar conectividad
docker-compose exec backend ping mongo
```

### Limpiar y empezar de nuevo
```bash
# Detener todo
docker-compose down -v

# Eliminar imágenes del proyecto
docker rmi petacare-backend petacare-frontend

# Reconstruir todo
docker-compose up --build
```

## 📝 Notas importantes

1. **Persistencia de datos**: Los datos de MongoDB se guardan en un volumen Docker (`mongo_data`)
2. **Hot reload**: Los cambios en el código se reflejan automáticamente
3. **Networking**: Los servicios se comunican a través de la red Docker interna
4. **Logs**: Usa `docker-compose logs` para ver todos los logs
5. **Backup**: Considera hacer backup del volumen de MongoDB regularmente

## 🎯 Ventajas de usar Docker

- ✅ **Portabilidad**: Funciona igual en cualquier sistema
- ✅ **Consistencia**: Mismo entorno en desarrollo y producción
- ✅ **Aislamiento**: Cada servicio en su propio contenedor
- ✅ **Escalabilidad**: Fácil escalar servicios individualmente
- ✅ **Limpieza**: No "contamina" el sistema host
- ✅ **Versionado**: Controla versiones de dependencias

¡Tu aplicación PetACare debería estar funcionando perfectamente con Docker en Ubuntu! 🐳🎉
