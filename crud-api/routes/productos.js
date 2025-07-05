import express from 'express';
import Producto from '../models/Producto.js';  // Asegúrate de que el modelo Producto esté correctamente importado
const router = express.Router();

// Crear producto
router.post('/', async (req, res) => {
  try {
    const nuevoProducto = new Producto(req.body);
    const resultado = await nuevoProducto.save();
    res.status(201).json(resultado);  // Se devuelve el producto creado
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Listar productos
router.get('/', async (req, res) => {
  try {
    const productos = await Producto.find();
    res.json(productos);  // Devuelve todos los productos
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Obtener un producto por ID
router.get('/:id', async (req, res) => {
  try {
    const producto = await Producto.findById(req.params.id);  // Busca el producto por ID
    if (!producto) return res.status(404).json({ error: 'Producto no encontrado' });
    res.json(producto);  // Si se encuentra, se devuelve el producto
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Actualizar producto
router.put('/:id', async (req, res) => {
  try {
    const actualizado = await Producto.findByIdAndUpdate(
      req.params.id,  // ID del producto a actualizar
      req.body,  // Nuevos datos del producto
      { new: true }  // Devuelve el producto actualizado
    );
    res.json(actualizado);  // Devuelve el producto actualizado
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

// Eliminar producto
router.delete('/:id', async (req, res) => {
  try {
    await Producto.findByIdAndDelete(req.params.id);  // Elimina el producto por ID
    res.json({ mensaje: 'Producto eliminado' });  // Mensaje de confirmación
  } catch (error) {
    res.status(400).json({ error: error.message });  // En caso de error, se devuelve el mensaje
  }
});

export default router;
