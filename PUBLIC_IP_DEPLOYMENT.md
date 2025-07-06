# 🌐 Guía de Despliegue con IP Pública - PetaCare

## 📋 Requisitos Previos

1. **Máquina Virtual Ubuntu** con IP pública
2. **Docker y Docker Compose** instalados
3. **Puertos abiertos** en el firewall (3001, 3002)
4. **Acceso SSH** a la VM

## 🚀 Instalación Rápida

### 1. Clonar el Repositorio
```bash
git clone https://github.com/JorgeGarciaCS/PetaCare.git
cd PetaCare
```

### 2. Configurar IP Pública
```bash
# Editar la IP en el archivo de configuración del frontend
nano frontend/public/app.js
# Cambiar: const API_BASE_URL = 'http://20.106.185.16:3001/api';
# Por tu IP pública
```

### 3. Configurar Firewall
```bash
# Permitir puertos necesarios
sudo ufw allow 3001
sudo ufw allow 3002
sudo ufw allow 22
sudo ufw enable
```

### 4. Ejecutar con Docker
```bash
# Construir y ejecutar
docker-compose up -d --build

# Verificar estado
docker-compose ps
```

## 🌐 Acceso Externo

- **Frontend**: http://TU_IP_PUBLICA:3002
- **Backend API**: http://TU_IP_PUBLICA:3001/api

## 🛡️ Configuración de Seguridad

### Azure VM (si aplica)
1. Ve a **Network Security Group**
2. Agregar reglas de entrada:
   - Puerto 3001 (TCP)
   - Puerto 3002 (TCP)
   - Origen: Internet o IP específica

### AWS EC2 (si aplica)
1. Ve a **Security Groups**
2. Agregar reglas de entrada:
   - Puerto 3001 (TCP, 0.0.0.0/0)
   - Puerto 3002 (TCP, 0.0.0.0/0)

## 🔧 Comandos Útiles

```bash
# Ver logs
docker-compose logs -f

# Reiniciar servicios
docker-compose restart

# Detener servicios
docker-compose down

# Limpiar y reconstruir
docker-compose down
docker system prune -f
docker-compose up -d --build
```

## 🔍 Verificación

### Verificar Backend
```bash
curl http://TU_IP_PUBLICA:3001/api/health
```

### Verificar Frontend
```bash
curl http://TU_IP_PUBLICA:3002
```

## 📱 Probar desde Navegador

1. Abre tu navegador web
2. Ve a `http://TU_IP_PUBLICA:3002`
3. Deberías ver la página de login de PetaCare

## 🐛 Solución de Problemas

### No se puede acceder desde fuera
1. Verificar firewall: `sudo ufw status`
2. Verificar puertos Docker: `docker-compose ps`
3. Verificar configuración de red del proveedor cloud

### Error de CORS
1. Verificar que la IP en `app.js` coincida con la IP pública
2. Reiniciar contenedores: `docker-compose restart`

### Base de datos no conecta
1. Verificar logs: `docker-compose logs mongo`
2. Verificar espacio en disco: `df -h`
3. Reiniciar MongoDB: `docker-compose restart mongo`

## 📚 Documentación Adicional

- `QUICK_INSTALL_GUIDE.md` - Guía rápida de instalación
- `DOCKER_MIGRATION_GUIDE.md` - Guía completa de Docker
- `IP_CONFIG.md` - Configuración de IP pública
- `API_AUTHENTICATION.md` - Documentación de la API
