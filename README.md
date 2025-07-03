# 🐾 PetACare - Sistema de Autenticación Completo

Este proyecto implementa un sistema completo de autenticación para PetACare con **Backend (Node.js + Express + MongoDB)** y **Frontend (React)**.

## 🚀 Inicio Rápido

### Para Windows:
```bash
# Ejecutar el script de inicio
start.bat
```

### Para Linux/Mac:
```bash
# Hacer ejecutable el script
chmod +x start.sh
# Ejecutar el script
./start.sh
```

### Manual:
```bash
# Terminal 1 - Backend
cd crud-api
npm start

# Terminal 2 - Frontend
cd frontend
npm start
```

## 🔧 Prerrequisitos

1. **Node.js** (v14 o superior)
2. **MongoDB** (corriendo en localhost:27017)
3. **npm** (viene con Node.js)

## 📁 Estructura del Proyecto

```
PetACare/
├── crud-api/                    # Backend (Node.js + Express)
│   ├── models/                  # Modelos de MongoDB
│   │   └── Usuario.js          # Modelo de Usuario con encriptación
│   ├── routes/                  # Rutas de la API
│   │   ├── auth.js             # Rutas de autenticación
│   │   └── usuarios.js         # Rutas de usuarios (protegidas)
│   ├── middleware/              # Middlewares
│   │   └── auth.js             # Middleware de autenticación JWT
│   ├── app.js                   # Aplicación principal
│   ├── package.json            # Dependencias del backend
│   └── .env                     # Variables de entorno
├── frontend/                    # Frontend (React)
│   ├── src/
│   │   ├── components/         # Componentes React
│   │   │   ├── Login.js        # Formulario de login
│   │   │   ├── Register.js     # Formulario de registro
│   │   │   ├── Dashboard.js    # Panel de usuario
│   │   │   └── Navigation.js   # Navegación
│   │   ├── contexts/           # Contextos de React
│   │   │   └── AuthContext.js  # Contexto de autenticación
│   │   ├── styles/             # Estilos CSS
│   │   │   └── Auth.css        # Estilos principales
│   │   └── App.js              # Aplicación principal
│   ├── package.json            # Dependencias del frontend
│   └── README.md               # Documentación del frontend
├── start.bat                   # Script de inicio para Windows
├── start.sh                    # Script de inicio para Linux/Mac
└── README.md                   # Este archivo
```

## 🌐 URLs de Acceso

- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:3000
- **Documentación API**: Consulta `crud-api/API_AUTHENTICATION.md`

## 🔐 Funcionalidades Implementadas

### Backend (Node.js + Express)
- ✅ Registro de usuarios con validación
- ✅ Login con JWT tokens
- ✅ Logout seguro
- ✅ Middleware de autenticación
- ✅ Encriptación de contraseñas (bcrypt)
- ✅ Rutas protegidas
- ✅ Actualización de perfil
- ✅ Cambio de contraseña
- ✅ Validación de datos

### Frontend (React)
- ✅ Interfaz de registro completa
- ✅ Formulario de login
- ✅ Dashboard de usuario
- ✅ Edición de perfil
- ✅ Cambio de contraseña
- ✅ Navegación reactiva
- ✅ Manejo de estados de autenticación
- ✅ Diseño responsive
- ✅ Manejo de errores

## 📋 Endpoints de la API

### Autenticación
- `POST /api/auth/register` - Registrar nuevo usuario
- `POST /api/auth/login` - Iniciar sesión
- `POST /api/auth/logout` - Cerrar sesión
- `GET /api/auth/me` - Obtener perfil del usuario
- `PUT /api/auth/me` - Actualizar perfil
- `PUT /api/auth/change-password` - Cambiar contraseña

### Usuarios (Protegidas)
- `GET /api/usuarios` - Listar usuarios
- `GET /api/usuarios/:id` - Obtener usuario por ID
- `PUT /api/usuarios/:id` - Actualizar usuario
- `DELETE /api/usuarios/:id` - Eliminar usuario

## 🧪 Pruebas

### Datos de Prueba para Registro
```json
{
  "primer_nombre": "Juan",
  "segundo_nombre": "Carlos",
  "apellido_pat": "Pérez",
  "apellido_mat": "García",
  "username": "juanperez",
  "correo_contacto": "juan.perez@email.com",
  "password": "password123",
  "dni": "12345678",
  "telefono": "987654321",
  "direccion": "Av. Principal 123",
  "fecha_nacimiento": "1990-05-15"
}
```

### Datos de Prueba para Login
```json
{
  "username": "juanperez",
  "password": "password123"
}
```

## 🛠️ Tecnologías Utilizadas

### Backend
- **Node.js** - Runtime de JavaScript
- **Express** - Framework web
- **MongoDB** - Base de datos NoSQL
- **Mongoose** - ODM para MongoDB
- **bcrypt** - Encriptación de contraseñas
- **jsonwebtoken** - Tokens JWT
- **express-session** - Manejo de sesiones
- **dotenv** - Variables de entorno

### Frontend
- **React** - Biblioteca de UI
- **axios** - Cliente HTTP
- **React Context** - Manejo de estado global
- **CSS3** - Estilos y animaciones
- **HTML5** - Estructura semántica

## 🔒 Seguridad

- **Contraseñas encriptadas** con bcrypt
- **Tokens JWT** con expiración
- **Validación de datos** en frontend y backend
- **Rutas protegidas** con middleware
- **Sanitización de entrada**
- **Manejo seguro de sesiones**

## 📚 Documentación Adicional

- **Backend**: `crud-api/API_AUTHENTICATION.md`
- **Frontend**: `frontend/README.md`
- **Variables de entorno**: `crud-api/.env.example`

## 🚨 Solución de Problemas

### MongoDB no se conecta
```bash
# Iniciar MongoDB
mongod

# O si usas MongoDB como servicio
net start MongoDB
```

### Error de CORS
El frontend está configurado con proxy, pero si tienes problemas:
```javascript
// En el backend app.js, agrega:
app.use(cors({
  origin: 'http://localhost:3001',
  credentials: true
}));
```

### Error de puertos ocupados
```bash
# Verificar qué proceso usa el puerto
netstat -ano | findstr :3000
netstat -ano | findstr :3001

# Terminar el proceso
taskkill /PID <PID> /F
```

## 🎯 Flujo de Uso

1. **Inicia los servidores** con `start.bat` o `start.sh`
2. **Abre el navegador** en http://localhost:3001
3. **Regístrate** con datos completos
4. **Inicia sesión** con tus credenciales
5. **Explora el dashboard**:
   - Ve tu perfil
   - Edita tu información
   - Cambia tu contraseña
   - Cierra sesión

## 🎨 Características del Diseño

- **Diseño moderno** con colores profesionales
- **Interfaz intuitiva** fácil de usar
- **Responsive** para desktop y móvil
- **Animaciones suaves** y transiciones
- **Mensajes informativos** claros
- **Estados de carga** para mejor UX

## 📈 Próximas Mejoras

- [ ] Confirmación de email
- [ ] Recuperación de contraseña
- [ ] Autenticación con redes sociales
- [ ] Roles y permisos
- [ ] Fotos de perfil
- [ ] Notificaciones en tiempo real
- [ ] Modo oscuro

## 💡 Contribuciones

Este proyecto es una demostración completa de un sistema de autenticación moderno. Siéntete libre de:

- Reportar bugs
- Sugerir mejoras
- Contribuir con código
- Usar como base para otros proyectos

## 📞 Soporte

Si tienes problemas:

1. Verifica que MongoDB esté corriendo
2. Asegúrate de que los puertos 3000 y 3001 estén libres
3. Revisa las variables de entorno en `.env`
4. Consulta la documentación específica de cada componente

---

**¡Disfruta explorando PetACare!** 🐾
