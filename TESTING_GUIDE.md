# 🧪 Pruebas de Acceso Externo - PetaCare

## 📋 URLs para Pruebas

### Producción (IP Pública)
- **Frontend**: http://20.106.185.16:3002
- **Backend Health**: http://20.106.185.16:3001/api/health
- **Backend API**: http://20.106.185.16:3001/api

### Desarrollo Local
- **Frontend**: http://localhost:3002
- **Backend Health**: http://localhost:3001/api/health
- **Backend API**: http://localhost:3001/api

## 🔍 Comandos de Verificación

### Desde la VM (Ubuntu)
```bash
# Verificar que los servicios estén corriendo
docker-compose ps

# Verificar backend localmente
curl http://localhost:3001/api/health

# Verificar frontend localmente  
curl http://localhost:3002

# Verificar backend desde IP pública
curl http://20.106.185.16:3001/api/health

# Verificar frontend desde IP pública
curl http://20.106.185.16:3002
```

### Desde tu PC (Windows/Mac/Linux)
```bash
# Verificar backend
curl http://20.106.185.16:3001/api/health

# Verificar frontend
curl http://20.106.185.16:3002

# O simplemente abrir en el navegador
# http://20.106.185.16:3002
```

## 🌐 Pruebas desde Navegador

### Paso 1: Acceder al Frontend
1. Abre tu navegador favorito
2. Ve a: `http://20.106.185.16:3002`
3. Deberías ver la página de login de PetaCare

### Paso 2: Verificar Funcionalidad
1. **Registro**: Crea una cuenta nueva
2. **Login**: Inicia sesión con tu cuenta
3. **Publicaciones**: Crea y visualiza publicaciones
4. **Productos**: Navega por los productos disponibles

### Paso 3: Verificar API
1. Abre las herramientas de desarrollador (F12)
2. Ve a la pestaña "Network"
3. Realiza acciones en la app
4. Verifica que las llamadas a la API vayan a `20.106.185.16:3001`

## 📱 Pruebas desde Móvil

### WiFi
1. Conecta tu móvil a la misma red o usa datos móviles
2. Abre el navegador en tu móvil
3. Ve a: `http://20.106.185.16:3002`
4. La app debería funcionar normalmente

### Datos Móviles
1. Desconecta el WiFi
2. Usa datos móviles
3. Accede a la URL desde cualquier lugar del mundo

## 🛠️ Resolución de Problemas

### "Cannot connect" o "Connection refused"
1. Verificar que Docker esté corriendo: `docker-compose ps`
2. Verificar firewall: `sudo ufw status`
3. Verificar que la VM esté encendida y accesible

### "CORS Error" en el navegador
1. Verificar que la IP en `app.js` sea correcta
2. Verificar configuración CORS en `crud-api/app.js`
3. Reiniciar contenedores: `docker-compose restart`

### Página carga pero no funciona
1. Verificar en herramientas de desarrollador si hay errores
2. Verificar que las llamadas a la API lleguen al backend
3. Verificar logs del backend: `docker-compose logs backend`

## 📊 Logs Útiles

```bash
# Ver logs de todos los servicios
docker-compose logs

# Ver logs del backend solamente
docker-compose logs backend

# Ver logs del frontend solamente
docker-compose logs frontend

# Ver logs de MongoDB
docker-compose logs mongo

# Seguir logs en tiempo real
docker-compose logs -f
```

## 🎯 Checklist de Verificación

- [ ] VM Ubuntu está encendida y accesible
- [ ] Docker y Docker Compose están instalados
- [ ] Puertos 3001 y 3002 están abiertos en el firewall
- [ ] Configuración de red del proveedor cloud permite acceso externo
- [ ] IP pública está configurada en `frontend/public/app.js`
- [ ] CORS está configurado en `crud-api/app.js`
- [ ] Contenedores están corriendo: `docker-compose ps`
- [ ] Backend responde: `curl http://20.106.185.16:3001/api/health`
- [ ] Frontend carga: navegador en `http://20.106.185.16:3002`
- [ ] Funcionalidad completa: registro, login, publicaciones funcionan
