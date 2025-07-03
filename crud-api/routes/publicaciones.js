import express from 'express';
import Publicacion from '../models/Publicacion.js';  // Asegúrate de que el modelo Publicacion esté correctamente importado
const router = express.Router();

// Crear publicación
router.post('/', async (req, res) => {
  try {
    const nuevaPublicacion = new Publicacion(req.body);
    const resultado = await nuevaPublicacion.save();
    res.status(201).json(resultado);  // Devuelve la publicación creada
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Listar publicaciones
router.get('/', async (req, res) => {
  try {
    const publicaciones = await Publicacion.find()
      .populate('usuario_id', 'primer_nombre apellido_pat correo_contacto')  // Obtener datos del usuario (opcional)
    res.json(publicaciones);  // Devuelve todas las publicaciones
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Obtener una publicación por ID
router.get('/:id', async (req, res) => {
  try {
    const publicacion = await Publicacion.findById(req.params.id)
      .populate('usuario_id', 'primer_nombre apellido_pat correo_contacto');  // Obtener datos del usuario

    if (!publicacion) return res.status(404).json({ error: 'Publicación no encontrada' });
    res.json(publicacion);  // Si se encuentra, devuelve la publicación
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Actualizar publicación
router.put('/:id', async (req, res) => {
  try {
    const actualizada = await Publicacion.findByIdAndUpdate(
      req.params.id,  // ID de la publicación a actualizar
      req.body,  // Nuevos datos de la publicación
      { new: true }  // Devuelve la publicación actualizada
    );
    res.json(actualizada);  // Devuelve la publicación actualizada
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Eliminar publicación
router.delete('/:id', async (req, res) => {
  try {
    await Publicacion.findByIdAndDelete(req.params.id);  // Elimina la publicación por ID
    res.json({ mensaje: 'Publicación eliminada' });  // Mensaje de confirmación
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

export default router;
