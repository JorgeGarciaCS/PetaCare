import express from 'express';
import Notificacion from '../models/Notificacion.js';
import { authenticateToken } from '../middleware/auth.js';
const router = express.Router();

// Crear notificación
router.post('/', authenticateToken, async (req, res) => {
  try {
    const nuevaNotificacion = new Notificacion(req.body);
    const resultado = await nuevaNotificacion.save();
    res.status(201).json(resultado);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Listar notificaciones del usuario actual
router.get('/', authenticateToken, async (req, res) => {
  try {
    const notificaciones = await Notificacion.find({ 
      usuario_id: req.usuario._id 
    }).sort({ fecha_envio: -1 });
    res.json(notificaciones);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Obtener una notificación por ID
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const notificacion = await Notificacion.findById(req.params.id);
    if (!notificacion) return res.status(404).json({ error: 'Notificación no encontrada' });
    
    // Verificar que la notificación pertenece al usuario actual
    if (notificacion.usuario_id.toString() !== req.usuario._id.toString()) {
      return res.status(403).json({ error: 'No tienes permisos para ver esta notificación' });
    }
    
    res.json(notificacion);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Marcar notificación como leída
router.put('/:id/leer', authenticateToken, async (req, res) => {
  try {
    const notificacion = await Notificacion.findById(req.params.id);
    if (!notificacion) {
      return res.status(404).json({ error: 'Notificación no encontrada' });
    }
    
    // Verificar que la notificación pertenece al usuario actual
    if (notificacion.usuario_id.toString() !== req.usuario._id.toString()) {
      return res.status(403).json({ error: 'No tienes permisos para modificar esta notificación' });
    }
    
    const actualizada = await Notificacion.findByIdAndUpdate(
      req.params.id,
      { leido: true },
      { new: true }
    );
    
    res.json(actualizada);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Marcar todas las notificaciones como leídas
router.put('/leer-todas', authenticateToken, async (req, res) => {
  try {
    await Notificacion.updateMany(
      { usuario_id: req.usuario._id, leido: false },
      { leido: true }
    );
    
    res.json({ mensaje: 'Todas las notificaciones marcadas como leídas' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Actualizar notificación
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    const notificacion = await Notificacion.findById(req.params.id);
    if (!notificacion) {
      return res.status(404).json({ error: 'Notificación no encontrada' });
    }
    
    // Verificar que la notificación pertenece al usuario actual
    if (notificacion.usuario_id.toString() !== req.usuario._id.toString()) {
      return res.status(403).json({ error: 'No tienes permisos para modificar esta notificación' });
    }
    
    const actualizada = await Notificacion.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    
    res.json(actualizada);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Eliminar notificación
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const notificacion = await Notificacion.findById(req.params.id);
    if (!notificacion) {
      return res.status(404).json({ error: 'Notificación no encontrada' });
    }
    
    // Verificar que la notificación pertenece al usuario actual
    if (notificacion.usuario_id.toString() !== req.usuario._id.toString()) {
      return res.status(403).json({ error: 'No tienes permisos para eliminar esta notificación' });
    }
    
    await Notificacion.findByIdAndDelete(req.params.id);
    res.json({ mensaje: 'Notificación eliminada' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

export default router;
