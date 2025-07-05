# API de Autenticación - PetACare

## Endpoints disponibles

### 1. Registro de Usuario
**POST** `/api/auth/register`

**Body:**
```json
{
  "primer_nombre": "Juan",
  "segundo_nombre": "Carlos",
  "apellido_pat": "Pérez",
  "apellido_mat": "García",
  "username": "juanperez",
  "correo_contacto": "juan.perez@email.com",
  "password": "miPassword123",
  "dni": "12345678",
  "telefono": "987654321",
  "direccion": "Av. Principal 123",
  "fecha_nacimiento": "1990-05-15"
}
```

**Respuesta exitosa:**
```json
{
  "mensaje": "Usuario registrado exitosamente",
  "usuario": {
    "_id": "...",
    "primer_nombre": "Juan",
    "segundo_nombre": "Carlos",
    "apellido_pat": "Pérez",
    "apellido_mat": "García",
    "username": "juanperez",
    "correo_contacto": "juan.perez@email.com",
    "dni": "12345678",
    "telefono": "987654321",
    "direccion": "Av. Principal 123",
    "fecha_nacimiento": "1990-05-15T00:00:00.000Z",
    "fecha_registro": "2025-07-03T..."
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 2. Inicio de Sesión
**POST** `/api/auth/login`

**Body:**
```json
{
  "username": "juanperez",
  "password": "miPassword123"
}
```

**Respuesta exitosa:**
```json
{
  "mensaje": "Login exitoso",
  "usuario": {
    "_id": "...",
    "primer_nombre": "Juan",
    "username": "juanperez",
    "correo_contacto": "juan.perez@email.com",
    ...
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 3. Cerrar Sesión
**POST** `/api/auth/logout`

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Respuesta:**
```json
{
  "mensaje": "Logout exitoso"
}
```

### 4. Obtener Perfil del Usuario Autenticado
**GET** `/api/auth/me`

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Respuesta:**
```json
{
  "usuario": {
    "_id": "...",
    "primer_nombre": "Juan",
    "username": "juanperez",
    "correo_contacto": "juan.perez@email.com",
    ...
  }
}
```

### 5. Actualizar Perfil
**PUT** `/api/auth/me`

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Body:**
```json
{
  "telefono": "987654322",
  "direccion": "Nueva Dirección 456"
}
```

### 6. Cambiar Contraseña
**PUT** `/api/auth/change-password`

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Body:**
```json
{
  "currentPassword": "miPassword123",
  "newPassword": "nuevaPassword456"
}
```

## Cómo usar el token JWT

1. **Registro/Login:** Guarda el token que recibes en la respuesta
2. **Requests autenticados:** Incluye el token en el header `Authorization` como `Bearer TOKEN`
3. **Logout:** Elimina el token del almacenamiento local del cliente

## Ejemplo de uso en JavaScript (Frontend)

```javascript
// Registro
const registro = async (userData) => {
  const response = await fetch('/api/auth/register', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData)
  });
  
  const data = await response.json();
  if (data.token) {
    localStorage.setItem('token', data.token);
  }
  return data;
};

// Login
const login = async (username, password) => {
  const response = await fetch('/api/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ username, password })
  });
  
  const data = await response.json();
  if (data.token) {
    localStorage.setItem('token', data.token);
  }
  return data;
};

// Hacer requests autenticados
const getProfile = async () => {
  const token = localStorage.getItem('token');
  const response = await fetch('/api/auth/me', {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  
  return await response.json();
};

// Logout
const logout = async () => {
  const token = localStorage.getItem('token');
  await fetch('/api/auth/logout', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  
  localStorage.removeItem('token');
};
```

## Configuración del archivo .env

Crea un archivo `.env` en la raíz del proyecto con:

```env
MONGODB_URI=mongodb://localhost:27017/petacare
PORT=3000
JWT_SECRET=tu-clave-jwt-muy-secreta-y-larga-para-produccion
SESSION_SECRET=tu-clave-de-sesion-muy-secreta-para-produccion
NODE_ENV=development
```

## Notas importantes

- Las contraseñas se encriptan automáticamente antes de guardarse
- Los tokens JWT expiran en 24 horas
- Los endpoints protegidos requieren el token en el header Authorization
- Las rutas de usuarios ahora están protegidas y solo permiten acceso al propio perfil
- Para registrar usuarios, usa `/api/auth/register` en lugar de `/api/usuarios`
