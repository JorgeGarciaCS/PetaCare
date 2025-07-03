import express from 'express';
import Usuario from '../models/Usuario.js';
import { authenticateToken } from '../middleware/auth.js';

const router = express.Router();

// Crear usuario (registro público - deprecado, usar /api/auth/register)
router.post('/', async (req, res) => {
  try {
    // Verificar si se está intentando crear un usuario con contraseña
    if (req.body.password) {
      return res.status(400).json({ 
        error: 'Use /api/auth/register para registrar usuarios con contraseña' 
      });
    }
    
    const nuevoUsuario = new Usuario(req.body);
    const resultado = await nuevoUsuario.save();
    res.status(201).json(resultado);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Listar usuarios (protegido)
router.get('/', authenticateToken, async (req, res) => {
  try {
    const usuarios = await Usuario.find().select('-password');
    res.json(usuarios);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Obtener un usuario por ID (protegido)
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const usuario = await Usuario.findById(req.params.id).select('-password');
    if (!usuario) return res.status(404).json({ error: 'Usuario no encontrado' });
    res.json(usuario);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Actualizar usuario (protegido - solo admin o el mismo usuario)
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    // Solo permitir que el usuario actualice su propio perfil
    if (req.usuario._id.toString() !== req.params.id) {
      return res.status(403).json({ error: 'No tienes permiso para actualizar este usuario' });
    }

    // No permitir actualizar contraseña por esta ruta
    delete req.body.password;
    delete req.body._id;
    delete req.body.fecha_registro;

    const actualizado = await Usuario.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    ).select('-password');
    
    res.json(actualizado);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Eliminar usuario (protegido - solo admin o el mismo usuario)
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    // Solo permitir que el usuario elimine su propio perfil
    if (req.usuario._id.toString() !== req.params.id) {
      return res.status(403).json({ error: 'No tienes permiso para eliminar este usuario' });
    }

    await Usuario.findByIdAndDelete(req.params.id);
    res.json({ mensaje: 'Usuario eliminado exitosamente' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

export default router;
