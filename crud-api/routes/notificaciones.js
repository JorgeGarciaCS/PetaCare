import express from 'express';
import Notificacion from '../models/Notificacion.js';  // Asegúrate de que el modelo Notificacion esté correctamente importado
const router = express.Router();

// Crear notificación
router.post('/', async (req, res) => {
  try {
    const nuevaNotificacion = new Notificacion(req.body);
    const resultado = await nuevaNotificacion.save();
    res.status(201).json(resultado);  // Devuelve la notificación creada
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Listar notificaciones
router.get('/', async (req, res) => {
  try {
    const notificaciones = await Notificacion.find();
    res.json(notificaciones);  // Devuelve todas las notificaciones
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Obtener una notificación por ID
router.get('/:id', async (req, res) => {
  try {
    const notificacion = await Notificacion.findById(req.params.id);  // Busca la notificación por ID
    if (!notificacion) return res.status(404).json({ error: 'Notificación no encontrada' });
    res.json(notificacion);  // Si se encuentra, devuelve la notificación
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Actualizar notificación
router.put('/:id', async (req, res) => {
  try {
    const actualizado = await Notificacion.findByIdAndUpdate(
      req.params.id,  // ID de la notificación a actualizar
      req.body,  // Nuevos datos de la notificación
      { new: true }  // Devuelve la notificación actualizada
    );
    res.json(actualizado);  // Devuelve la notificación actualizada
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Eliminar notificación
router.delete('/:id', async (req, res) => {
  try {
    await Notificacion.findByIdAndDelete(req.params.id);  // Elimina la notificación por ID
    res.json({ mensaje: 'Notificación eliminada' });  // Mensaje de confirmación
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

export default router;
