import express from 'express';
import Publicacion from '../models/Publicacion.js';
import { authenticateToken } from '../middleware/auth.js';
const router = express.Router();

// Crear publicación (requiere autenticación)
router.post('/', authenticateToken, async (req, res) => {
  try {
    const nuevaPublicacion = new Publicacion(req.body);
    const resultado = await nuevaPublicacion.save();
    res.status(201).json(resultado);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Listar publicaciones (requiere autenticación)
router.get('/', authenticateToken, async (req, res) => {
  try {
    const publicaciones = await Publicacion.find()
      .populate('usuario_id', 'primer_nombre apellido_pat correo_contacto')
      .sort({ fecha_publicacion: -1 }); // Ordenar por fecha más reciente
    res.json(publicaciones);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Obtener una publicación por ID (requiere autenticación)
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    console.log('Obteniendo publicación con ID:', req.params.id);
    
    const publicacion = await Publicacion.findById(req.params.id)
      .populate('usuario_id', 'primer_nombre apellido_pat correo_contacto');

    if (!publicacion) {
      console.log('Publicación no encontrada');
      return res.status(404).json({ error: 'Publicación no encontrada' });
    }
    
    console.log('Publicación encontrada:', publicacion);
    res.json(publicacion);
  } catch (error) {
    console.error('Error al obtener publicación:', error);
    res.status(400).json({ error: error.message });
  }
});

// Actualizar publicación (solo el autor puede editar)
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    console.log('Actualizando publicación:', req.params.id);
    console.log('Datos recibidos:', req.body);
    console.log('Usuario autenticado:', req.usuario._id);
    
    const publicacion = await Publicacion.findById(req.params.id);
    
    if (!publicacion) {
      console.log('Publicación no encontrada');
      return res.status(404).json({ error: 'Publicación no encontrada' });
    }
    
    console.log('Autor de la publicación:', publicacion.usuario_id);
    console.log('Usuario actual:', req.usuario._id);
    
    // Verificar que el usuario actual es el autor de la publicación
    if (publicacion.usuario_id.toString() !== req.usuario._id.toString()) {
      console.log('Sin permisos para editar');
      return res.status(403).json({ error: 'No tienes permisos para editar esta publicación' });
    }
    
    const actualizada = await Publicacion.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    ).populate('usuario_id', 'primer_nombre apellido_pat correo_contacto');
    
    console.log('Publicación actualizada:', actualizada);
    res.json(actualizada);
  } catch (error) {
    console.error('Error al actualizar publicación:', error);
    res.status(400).json({ error: error.message });
  }
});

// Eliminar publicación (solo el autor puede eliminar)
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    console.log('Eliminando publicación:', req.params.id);
    console.log('Usuario autenticado:', req.usuario._id);
    
    const publicacion = await Publicacion.findById(req.params.id);
    
    if (!publicacion) {
      console.log('Publicación no encontrada');
      return res.status(404).json({ error: 'Publicación no encontrada' });
    }
    
    console.log('Autor de la publicación:', publicacion.usuario_id);
    console.log('Usuario actual:', req.usuario._id);
    
    // Verificar que el usuario actual es el autor de la publicación
    if (publicacion.usuario_id.toString() !== req.usuario._id.toString()) {
      console.log('Sin permisos para eliminar');
      return res.status(403).json({ error: 'No tienes permisos para eliminar esta publicación' });
    }
    
    await Publicacion.findByIdAndDelete(req.params.id);
    console.log('Publicación eliminada exitosamente');
    res.json({ mensaje: 'Publicación eliminada exitosamente' });
  } catch (error) {
    console.error('Error al eliminar publicación:', error);
    res.status(400).json({ error: error.message });
  }
});

export default router;
