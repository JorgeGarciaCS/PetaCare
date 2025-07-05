import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import session from 'express-session';
import cors from 'cors';

// Importar las rutas de cada colección
import usuariosRoutes from './routes/usuarios.js';
import publicacionesRoutes from './routes/publicaciones.js';
import comentariosRoutes from './routes/comentarios.js';
import notificacionesRoutes from './routes/notificaciones.js';
import productosRoutes from './routes/productos.js';
import authRoutes from './routes/auth.js';

dotenv.config();
const app = express();

// Middleware
app.use(cors({
  origin: ['http://localhost:3002', 'http://localhost:3000'],
  credentials: true
}));
app.use(express.json({ limit: '50mb' }));  // Aumentar límite para imágenes
app.use(express.urlencoded({ limit: '50mb', extended: true }));  // Para manejar las solicitudes con cuerpo JSON

// Configuración de sesiones
app.use(session({
  secret: process.env.SESSION_SECRET || 'tu-clave-secreta-muy-segura',
  resave: false,
  saveUninitialized: false,
  cookie: { 
    secure: false, // Cambiar a true en producción con HTTPS
    maxAge: 24 * 60 * 60 * 1000 // 24 horas
  }
}));

// Rutas
app.use('/api/auth', authRoutes);  // Rutas de autenticación
app.use('/api/usuarios', usuariosRoutes);  // Rutas para usuarios
app.use('/api/publicaciones', publicacionesRoutes);  // Rutas para publicaciones
app.use('/api/comentarios', comentariosRoutes);  // Rutas para comentarios
app.use('/api/notificaciones', notificacionesRoutes);  // Rutas para notificaciones
app.use('/api/productos', productosRoutes);  // Rutas para productos

// Conectar a MongoDB y arrancar servidor
const PORT = process.env.PORT || 3000;

mongoose.connect(process.env.MONGODB_URI)
  .then(() => {
    console.log('MongoDB conectado');
    app.listen(PORT, () => console.log(`Servidor en http://localhost:${PORT}`));
  })
  .catch(err => console.error('Error al conectar a MongoDB', err));
