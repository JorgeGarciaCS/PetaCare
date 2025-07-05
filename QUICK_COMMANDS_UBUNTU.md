# 🐧 Comandos Rápidos para Ubuntu - PetACare

## 📋 Configuración Inicial (ejecutar una sola vez)
```bash
# 1. Hacer ejecutables los scripts
chmod +x *.sh

# 2. Ejecutar configuración inicial
./ubuntu-setup.sh

# 3. Verificar que todo esté instalado
node --version
npm --version
mongod --version
pm2 --version
```

## 🚀 Inicio Rápido

### Desarrollo (con logs visibles)
```bash
./ubuntu-start.sh
```

### Producción (con PM2)
```bash
./ubuntu-pm2.sh
```

## 🔧 Comandos de Gestión

### MongoDB
```bash
# Iniciar MongoDB
sudo systemctl start mongod

# Ver estado
sudo systemctl status mongod

# Reiniciar
sudo systemctl restart mongod

# Ver logs
sudo journalctl -u mongod -f
```

### PM2 (Producción)
```bash
# Ver estado
pm2 status

# Ver logs
pm2 logs

# Reiniciar aplicación
pm2 restart all

# Detener aplicación
pm2 stop all

# Monitor en tiempo real
pm2 monit
```

### Troubleshooting
```bash
# Ver procesos Node.js
ps aux | grep node

# Ver puertos en uso
netstat -tlnp | grep :3001
netstat -tlnp | grep :3002

# Terminar proceso por puerto
sudo lsof -i :3001
sudo kill -9 PID

# Ver logs del sistema
journalctl -f
```

## 🌐 URLs de Acceso

- **Frontend**: http://localhost:3002
- **Backend**: http://localhost:3001/api
- **Desde otra máquina**: http://IP-UBUNTU:3002

## 📁 Estructura de Archivos

```
PetaCare/
├── ubuntu-setup.sh          # Configuración inicial
├── ubuntu-start.sh          # Inicio en desarrollo
├── ubuntu-pm2.sh            # Inicio en producción
├── transfer-to-ubuntu.sh    # Script de transferencia
├── MIGRATION_GUIDE_UBUNTU.md # Guía completa
├── QUICK_COMMANDS_UBUNTU.md # Esta guía
├── crud-api/
│   ├── .env.ubuntu          # Variables de entorno para Ubuntu
│   └── ...
└── frontend/
    └── ...
```

## 🔥 Configuración de Firewall

```bash
# Habilitar puertos
sudo ufw allow 3001/tcp
sudo ufw allow 3002/tcp

# Ver reglas
sudo ufw status

# Habilitar firewall
sudo ufw enable
```

## 📦 Actualización del Proyecto

```bash
# Si usas Git
git pull origin main

# Reinstalar dependencias si es necesario
cd crud-api && npm install
cd ../frontend && npm install

# Reiniciar aplicación
pm2 restart all
```
