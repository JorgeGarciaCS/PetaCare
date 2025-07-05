import express from 'express';
import Comentario from '../models/Comentario.js';
import Notificacion from '../models/Notificacion.js';
import Publicacion from '../models/Publicacion.js';
import { authenticateToken } from '../middleware/auth.js';
const router = express.Router();

// Crear comentario (requiere autenticación)
router.post('/', authenticateToken, async (req, res) => {
  try {
    console.log('Creando comentario con datos:', req.body);
    console.log('Usuario autenticado:', req.usuario._id);
    
    const nuevoComentario = new Comentario(req.body);
    const resultado = await nuevoComentario.save();
    
    console.log('Comentario creado:', resultado);
    
    // Crear notificación para el autor de la publicación
    if (req.body.publicacion_id && req.body.usuario_id) {
      // Obtener la publicación para saber quién es el autor
      const publicacion = await Publicacion.findById(req.body.publicacion_id);
      
      if (publicacion && publicacion.usuario_id.toString() !== req.body.usuario_id) {
        // Solo crear notificación si el comentario no es del mismo autor de la publicación
        const nuevaNotificacion = new Notificacion({
          mensaje: `Tu publicación "${publicacion.titulo}" ha recibido un nuevo comentario`,
          usuario_id: publicacion.usuario_id,
          tipo: 'comentario',
          leido: false
        });
        await nuevaNotificacion.save();
        console.log('Notificación creada para el autor de la publicación');
      }
    }
    
    res.status(201).json(resultado);
  } catch (error) {
    console.error('Error al crear comentario:', error);
    res.status(400).json({ error: error.message });
  }
});

// Listar comentarios (requiere autenticación)
router.get('/', authenticateToken, async (req, res) => {
  try {
    const comentarios = await Comentario.find()
      .populate('usuario_id', 'primer_nombre apellido_pat correo_contacto')
      .populate('publicacion_id', 'titulo contenido')
      .sort({ fecha_comentario: -1 }); // Ordenar por más reciente
    res.json(comentarios);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Obtener comentarios por publicación (requiere autenticación)
router.get('/publicacion/:publicacionId', authenticateToken, async (req, res) => {
  try {
    console.log('Obteniendo comentarios para publicación:', req.params.publicacionId);
    
    const comentarios = await Comentario.find({ publicacion_id: req.params.publicacionId })
      .populate('usuario_id', 'primer_nombre apellido_pat correo_contacto')
      .sort({ fecha_comentario: 1 }); // Ordenar por más antiguo primero
    
    console.log('Comentarios encontrados:', comentarios.length);
    console.log('Comentarios:', comentarios);
    
    res.json(comentarios);
  } catch (error) {
    console.error('Error al obtener comentarios:', error);
    res.status(400).json({ error: error.message });
  }
});

// Obtener un comentario por ID (requiere autenticación)
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const comentario = await Comentario.findById(req.params.id)
      .populate('usuario_id', 'primer_nombre apellido_pat correo_contacto')
      .populate('publicacion_id', 'titulo contenido');

    if (!comentario) return res.status(404).json({ error: 'Comentario no encontrado' });
    res.json(comentario);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Actualizar un comentario (solo el autor puede editar)
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    const comentario = await Comentario.findById(req.params.id);
    
    if (!comentario) {
      return res.status(404).json({ error: 'Comentario no encontrado' });
    }
    
    // Verificar que el usuario actual es el autor del comentario
    if (comentario.usuario_id.toString() !== req.usuario._id.toString()) {
      return res.status(403).json({ error: 'No tienes permisos para editar este comentario' });
    }
    
    const comentarioActualizado = await Comentario.findByIdAndUpdate(
      req.params.id, 
      req.body, 
      { new: true }
    ).populate('usuario_id', 'primer_nombre apellido_pat correo_contacto');
    
    res.json(comentarioActualizado);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Eliminar un comentario (solo el autor puede eliminar)
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const comentario = await Comentario.findById(req.params.id);
    
    if (!comentario) {
      return res.status(404).json({ error: 'Comentario no encontrado' });
    }
    
    // Verificar que el usuario actual es el autor del comentario
    if (comentario.usuario_id.toString() !== req.usuario._id.toString()) {
      return res.status(403).json({ error: 'No tienes permisos para eliminar este comentario' });
    }
    
    await Comentario.findByIdAndDelete(req.params.id);
    res.json({ mensaje: 'Comentario eliminado exitosamente' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

export default router;
