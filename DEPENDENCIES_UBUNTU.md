# 📦 Instalación de Dependencias - Ubuntu

## Backend (crud-api)
```json
{
  "name": "petacare-backend",
  "version": "1.0.0",
  "description": "Backend API para PetACare",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "dev": "nodemon app.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.5.0",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "express-rate-limit": "^6.10.0",
    "helmet": "^7.0.0",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
```

## Frontend
```json
{
  "name": "petacare-frontend",
  "version": "1.0.0",
  "description": "Frontend para PetACare",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "path": "^0.12.7"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
```

## Instalación Manual

### Ubuntu - Dependencias del Sistema
```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js 18 LTS
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar herramientas de desarrollo
sudo apt-get install -y build-essential curl git

# Instalar MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Iniciar MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod

# Instalar PM2 globalmente
sudo npm install -g pm2
```

### Verificar Instalación
```bash
# Verificar versiones
node --version    # Debe ser v18.x.x o superior
npm --version     # Debe ser 9.x.x o superior
mongod --version  # Debe ser 6.x.x o superior
pm2 --version     # Debe estar instalado

# Verificar MongoDB
sudo systemctl status mongod
```

### Instalar Dependencias del Proyecto
```bash
# Backend
cd crud-api
npm install

# Frontend
cd ../frontend
npm install
```

## Posibles Problemas y Soluciones

### Error: EACCES permission denied
```bash
# Cambiar propietario de directorio npm
sudo chown -R $USER:$USER ~/.npm
```

### Error: MongoDB connection failed
```bash
# Verificar estado de MongoDB
sudo systemctl status mongod

# Reiniciar MongoDB
sudo systemctl restart mongod

# Ver logs
sudo journalctl -u mongod
```

### Error: Port already in use
```bash
# Encontrar proceso usando el puerto
sudo lsof -i :3001
sudo lsof -i :3002

# Terminar proceso
sudo kill -9 PID
```

### Error: npm packages missing
```bash
# Limpiar cache e instalar de nuevo
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```
