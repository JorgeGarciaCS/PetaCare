# 🐧 Guía de Migración a Ubuntu - PetACare

Esta guía te ayudará a migrar tu proyecto PetACare desde Windows a Ubuntu paso a paso.

## � RECOMENDADO: Usar Docker (Más Fácil)

**Para una migración más fácil y portable, te recomendamos usar Docker:**
- 📖 **Guía completa**: `DOCKER_MIGRATION_GUIDE.md`
- ⚡ **Comandos rápidos**: `DOCKER_QUICK_COMMANDS.md`

### Resumen rápido con Docker:
```bash
# 1. Instalar Docker
./docker-setup-ubuntu.sh

# 2. Iniciar aplicación
./docker-start.sh

# 3. Gestionar contenedores
./docker-manage.sh start
```

---

## 📋 Instalación Manual (Sin Docker)

### 1. Actualizar el sistema
```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Node.js y npm
```bash
# Instalar Node.js (v18 LTS recomendado)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verificar instalación
node --version
npm --version
```

### 3. Instalar MongoDB
```bash
# Importar clave GPG
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

# Agregar repositorio
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Actualizar e instalar
sudo apt-get update
sudo apt-get install -y mongodb-org

# Iniciar MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Verificar estado
sudo systemctl status mongod
```

### 4. Instalar Git (si no está instalado)
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
Usa SCP, SFTP o cualquier método de transferencia de archivos para copiar todos los archivos del proyecto desde Windows a Ubuntu.

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
git commit -m "Initial commit - PetaCare project"

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

## 🔧 Configuración en Ubuntu

### Paso 1: Instalar dependencias del backend
```bash
cd crud-api
npm install
```

### Paso 2: Instalar dependencias del frontend
```bash
cd ../frontend
npm install
```

### Paso 3: Configurar variables de entorno
```bash
cd ../crud-api
cp .env.example .env  # Si existe, sino crear .env
nano .env
```

Configurar el archivo `.env` con las siguientes variables:
```properties
# Variables de entorno para la aplicación PetACare

# Base de datos MongoDB
MONGODB_URI=mongodb://localhost:27017/petacare

# Puerto del servidor
PORT=3001

# Clave secreta para JWT
JWT_SECRET=21b8cd697d74b71bf5e1f57c499858be9f58acb93bf1adf0e1001e31b368089f

# Clave secreta para sesiones
SESSION_SECRET=2d84d0c5fe89d67d9e4c48b3b38df8e422900f9f2fa2c844d55d9865b5ece3a5

# Configuración de entorno
NODE_ENV=development
```

### Paso 4: Hacer ejecutable el script de inicio
```bash
chmod +x start.sh
chmod +x ubuntu-setup.sh  # Si existe
```

## 🚀 Iniciar la aplicación

### Opción 1: Usar el script de inicio
```bash
./start.sh
```

### Opción 2: Iniciar manualmente
```bash
# Terminal 1 - Backend
cd crud-api
npm start

# Terminal 2 - Frontend (nueva terminal)
cd frontend
npm start
```

### Opción 3: Usar PM2 (para producción)
```bash
# Instalar PM2
sudo npm install -g pm2

# Iniciar backend
cd crud-api
pm2 start app.js --name "petacare-backend"

# Iniciar frontend
cd ../frontend
pm2 start server.js --name "petacare-frontend"

# Ver estado
pm2 status

# Configurar para que inicie automáticamente
pm2 startup
pm2 save
```

## 🔥 Configuración de Firewall (si es necesario)

```bash
# Permitir puertos necesarios
sudo ufw allow 3001/tcp  # Backend
sudo ufw allow 3002/tcp  # Frontend
sudo ufw allow 27017/tcp # MongoDB (solo si necesitas acceso externo)

# Habilitar firewall
sudo ufw enable
```

## 🌐 Acceso a la aplicación

Una vez iniciada la aplicación, podrás acceder a:

- **Frontend**: http://localhost:3002
- **Backend API**: http://localhost:3001/api
- **Si accedes desde otra máquina**: http://IP-DE-TU-UBUNTU:3002

## 🔧 Comandos útiles para troubleshooting

```bash
# Ver logs de MongoDB
sudo journalctl -u mongod

# Verificar procesos Node.js
ps aux | grep node

# Verificar puertos en uso
netstat -tlnp | grep :3001
netstat -tlnp | grep :3002

# Verificar estado de MongoDB
sudo systemctl status mongod

# Reiniciar MongoDB
sudo systemctl restart mongod

# Ver logs de la aplicación
tail -f crud-api/logs/app.log  # Si tienes logging configurado
```

## 📝 Notas importantes

1. **Cambiar la IP en .env**: Si tu MongoDB está en otra máquina, actualiza `MONGODB_URI` en el archivo `.env`

2. **Permisos**: Asegúrate de que los archivos tengan los permisos correctos:
   ```bash
   chmod 755 start.sh
   chmod 644 *.js
   ```

3. **Variables de entorno**: Verifica que todas las variables estén configuradas correctamente

4. **Versiones de Node.js**: Asegúrate de usar una versión compatible (v14 o superior)

## 🆘 Solución de problemas comunes

### MongoDB no se conecta
```bash
# Verificar estado
sudo systemctl status mongod

# Reiniciar
sudo systemctl restart mongod

# Ver logs
sudo journalctl -u mongod -f
```

### Puerto ocupado
```bash
# Encontrar proceso usando el puerto
sudo lsof -i :3001

# Terminar proceso
sudo kill -9 PID
```

### Permisos negados
```bash
# Cambiar propietario
sudo chown -R $USER:$USER ~/PetaCare

# Cambiar permisos
chmod -R 755 ~/PetaCare
```

¡Tu aplicación PetACare debería estar funcionando correctamente en Ubuntu! 🎉
