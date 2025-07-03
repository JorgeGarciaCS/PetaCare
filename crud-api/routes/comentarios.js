import express from 'express';
import Comentario from '../models/Comentario.js';  // Asegúrate de que el modelo Comentario esté correctamente importado
const router = express.Router();

// Crear comentario
router.post('/', async (req, res) => {
  try {
    const nuevoComentario = new Comentario(req.body);
    const resultado = await nuevoComentario.save();
    res.status(201).json(resultado);  // Devuelve el comentario creado
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Listar comentarios
router.get('/', async (req, res) => {
  try {
    const comentarios = await Comentario.find()
      .populate('usuario_id', 'primer_nombre apellido_pat correo_contacto')  // Obtener datos del usuario (opcional)
      .populate('publicacion_id', 'titulo contenido')  // Obtener datos de la publicación (opcional)
    res.json(comentarios);  // Devuelve todos los comentarios
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Obtener un comentario por ID
router.get('/:id', async (req, res) => {
  try {
    const comentario = await Comentario.findById(req.params.id)
      .populate('usuario_id', 'primer_nombre apellido_pat correo_contacto')  // Obtener datos del usuario
      .populate('publicacion_id', 'titulo contenido');  // Obtener datos de la publicación

    if (!comentario) return res.status(404).json({ error: 'Comentario no encontrado' });
    res.json(comentario);  // Si se encuentra, devuelve el comentario
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Actualizar un comentario
router.put('/:id', async (req, res) => {
  try {
    const comentarioActualizado = await Comentario.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!comentarioActualizado) return res.status(404).json({ error: 'Comentario no encontrado' });
    res.json(comentarioActualizado);  // Devuelve el comentario actualizado
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Eliminar un comentario
router.delete('/:id', async (req, res) => {
  try {
    const comentarioEliminado = await Comentario.findByIdAndDelete(req.params.id);
    if (!comentarioEliminado) return res.status(404).json({ error: 'Comentario no encontrado' });
    res.status(204).send();  // Devuelve un 204 sin contenido para indicar éxito
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

export default router;
