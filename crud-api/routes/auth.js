import express from 'express';
import jwt from 'jsonwebtoken';
import Usuario from '../models/Usuario.js';
import { authenticateToken } from '../middleware/auth.js';

const router = express.Router();

// Generar token JWT
const generateToken = (userId) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET, { expiresIn: '24h' });
};

// REGISTRO DE USUARIO
router.post('/register', async (req, res) => {
  try {
    const { 
      apellido_pat, 
      apellido_mat, 
      correo_contacto, 
      direccion, 
      dni, 
      fecha_nacimiento, 
      primer_nombre, 
      segundo_nombre, 
      telefono, 
      username, 
      password 
    } = req.body;

    // Validar que todos los campos requeridos estén presentes
    if (!apellido_pat || !apellido_mat || !correo_contacto || !direccion || 
        !dni || !fecha_nacimiento || !primer_nombre || !telefono || 
        !username || !password) {
      return res.status(400).json({ error: 'Todos los campos requeridos deben ser proporcionados' });
    }

    // Validar longitud de contraseña
    if (password.length < 6) {
      return res.status(400).json({ error: 'La contraseña debe tener al menos 6 caracteres' });
    }

    // Verificar si el usuario ya existe
    const usuarioExistente = await Usuario.findOne({
      $or: [
        { correo_contacto },
        { username },
        { dni }
      ]
    });

    if (usuarioExistente) {
      return res.status(400).json({ error: 'Usuario ya existe (correo, username o DNI duplicado)' });
    }

    // Crear nuevo usuario
    const nuevoUsuario = new Usuario({
      apellido_pat,
      apellido_mat,
      correo_contacto,
      direccion,
      dni,
      fecha_nacimiento,
      primer_nombre,
      segundo_nombre,
      telefono,
      username,
      password
    });

    await nuevoUsuario.save();

    // Generar token
    const token = generateToken(nuevoUsuario._id);

    // Responder con el usuario (sin contraseña) y token
    const usuarioRespuesta = { ...nuevoUsuario.toObject() };
    delete usuarioRespuesta.password;

    res.status(201).json({
      mensaje: 'Usuario registrado exitosamente',
      usuario: usuarioRespuesta,
      token
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// LOGIN DE USUARIO
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    // Validar campos requeridos
    if (!username || !password) {
      return res.status(400).json({ error: 'Username y contraseña son requeridos' });
    }

    // Buscar usuario por username o correo
    const usuario = await Usuario.findOne({
      $or: [
        { username },
        { correo_contacto: username }
      ]
    });

    if (!usuario) {
      return res.status(400).json({ error: 'Credenciales inválidas' });
    }

    // Verificar contraseña
    const passwordValida = await usuario.comparePassword(password);
    if (!passwordValida) {
      return res.status(400).json({ error: 'Credenciales inválidas' });
    }

    // Generar token
    const token = generateToken(usuario._id);

    // Responder con usuario (sin contraseña) y token
    const usuarioRespuesta = { ...usuario.toObject() };
    delete usuarioRespuesta.password;

    res.json({
      mensaje: 'Login exitoso',
      usuario: usuarioRespuesta,
      token
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// LOGOUT DE USUARIO (invalidar token del lado del cliente)
router.post('/logout', authenticateToken, async (req, res) => {
  try {
    // En un sistema JWT, el logout se maneja principalmente del lado del cliente
    // eliminando el token del almacenamiento local
    res.json({ mensaje: 'Logout exitoso' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// OBTENER PERFIL DEL USUARIO AUTENTICADO
router.get('/me', authenticateToken, async (req, res) => {
  try {
    res.json({
      usuario: req.usuario
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ACTUALIZAR PERFIL DEL USUARIO AUTENTICADO
router.put('/me', authenticateToken, async (req, res) => {
  try {
    const actualizaciones = req.body;
    
    // No permitir actualizar ciertos campos sensibles
    delete actualizaciones.password;
    delete actualizaciones._id;
    delete actualizaciones.fecha_registro;

    const usuarioActualizado = await Usuario.findByIdAndUpdate(
      req.usuario._id,
      actualizaciones,
      { new: true, runValidators: true }
    ).select('-password');

    res.json({
      mensaje: 'Perfil actualizado exitosamente',
      usuario: usuarioActualizado
    });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// CAMBIAR CONTRASEÑA
router.put('/change-password', authenticateToken, async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({ error: 'Contraseña actual y nueva contraseña son requeridas' });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({ error: 'La nueva contraseña debe tener al menos 6 caracteres' });
    }

    // Buscar usuario con contraseña
    const usuario = await Usuario.findById(req.usuario._id);
    
    // Verificar contraseña actual
    const passwordValida = await usuario.comparePassword(currentPassword);
    if (!passwordValida) {
      return res.status(400).json({ error: 'Contraseña actual incorrecta' });
    }

    // Actualizar contraseña
    usuario.password = newPassword;
    await usuario.save();

    res.json({ mensaje: 'Contraseña cambiada exitosamente' });

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
