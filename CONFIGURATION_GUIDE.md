# 🔧 Guía de Configuración - PetACare

## 📁 Ubicación de archivos de configuración

```
PetACare/
├── crud-api/
│   ├── .env                 # ← ARCHIVO PRINCIPAL DE CONFIGURACIÓN
│   ├── .env.example         # ← Ejemplo de configuración
│   ├── check-users.js       # ← Script para ver usuarios
│   └── generate-keys.js     # ← Script para generar claves
```

## 🔐 Configuración del archivo .env

### Ubicación: `crud-api/.env`

```env
# Variables de entorno para la aplicación PetACare

# Base de datos MongoDB
# Opción 1: MongoDB local
MONGODB_URI=mongodb://localhost:27017/petacare

# Opción 2: MongoDB Atlas (cloud) - Descomenta y usa tu URL
# MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/petacare?retryWrites=true&w=majority

# Puerto del servidor
PORT=3000

# Clave secreta para JWT (¡CAMBIAR EN PRODUCCIÓN!)
JWT_SECRET=tu-clave-jwt-generada-con-el-script

# Clave secreta para sesiones (¡CAMBIAR EN PRODUCCIÓN!)
SESSION_SECRET=tu-clave-de-sesion-generada-con-el-script

# Configuración de entorno
NODE_ENV=development
```

## 🚀 Comandos útiles

### Generar claves seguras:
```bash
cd crud-api
node generate-keys.js
```

### Ver usuarios registrados:
```bash
cd crud-api
node check-users.js
```

### Iniciar el servidor:
```bash
cd crud-api
npm start
```

## 🗄️ Opciones de MongoDB

### Opción 1: MongoDB Local
```env
MONGODB_URI=mongodb://localhost:27017/petacare
```

### Opción 2: MongoDB Atlas (Cloud)
1. Ve a [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Crea una cuenta gratuita
3. Crea un cluster
4. Obtén la cadena de conexión
5. Reemplaza en el .env:
```env
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/petacare?retryWrites=true&w=majority
```

### Opción 3: MongoDB con autenticación local
```env
MONGODB_URI=mongodb://username:password@localhost:27017/petacare
```

## 🔒 Seguridad de las claves

### ⚠️ IMPORTANTE:
- **Nunca** compartas tu archivo `.env`
- **Nunca** subas el `.env` a Git
- **Cambia** las claves en producción
- **Usa** claves largas y complejas

### Generar claves manualmente:
```bash
# En Node.js
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"

# En PowerShell
[System.Web.Security.Membership]::GeneratePassword(64, 10)
```

## 🛠️ Verificación de configuración

### 1. Verificar que MongoDB está corriendo:
```bash
# Verificar proceso de MongoDB
tasklist | findstr mongod
```

### 2. Verificar conexión:
```bash
# Probar conexión a MongoDB
mongo --eval "db.adminCommand('ismaster')"
```

### 3. Verificar usuarios:
```bash
cd crud-api
node check-users.js
```

## 🔧 Solución de problemas

### Error: "MongoNetworkError"
- Verifica que MongoDB esté corriendo
- Comprueba la URL de conexión
- Verifica firewall y permisos

### Error: "JWT_SECRET is required"
- Verifica que el archivo `.env` esté en `crud-api/`
- Comprueba que la clave JWT esté definida
- Reinicia el servidor después de cambios

### Error: "Cannot connect to MongoDB"
- Verifica que MongoDB esté instalado
- Comprueba que el servicio esté corriendo
- Revisa la URL de conexión

## 📱 Ejemplo de uso completo

1. **Configura el .env**:
   ```bash
   cd crud-api
   cp .env.example .env
   node generate-keys.js
   # Copia las claves generadas al .env
   ```

2. **Inicia MongoDB**:
   ```bash
   mongod
   ```

3. **Inicia el servidor**:
   ```bash
   npm start
   ```

4. **Verifica usuarios**:
   ```bash
   node check-users.js
   ```

## 🎯 Variables de entorno explicadas

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `MONGODB_URI` | Conexión a MongoDB | `mongodb://localhost:27017/petacare` |
| `PORT` | Puerto del servidor | `3000` |
| `JWT_SECRET` | Clave para tokens JWT | `clave-muy-larga-y-secreta` |
| `SESSION_SECRET` | Clave para sesiones | `otra-clave-muy-larga` |
| `NODE_ENV` | Entorno de ejecución | `development` o `production` |

## 🔄 Reiniciar servicios

Después de cambiar el `.env`, reinicia:
```bash
# Detener el servidor (Ctrl+C)
# Volver a iniciar
npm start
```
