import mongoose from 'mongoose';

const productoSchema = new mongoose.Schema({
  nombre: { type: String, required: true },  // Nombre del producto
  descripcion: { type: String, required: true },  // Descripción detallada del producto
  precio: { type: Number, required: true },  // Precio del producto
  stock: { type: Number, required: true, default: 0 },  // Cantidad disponible en stock (por defecto 0)
  imagen_prod: { type: String, required: false },  // Base64 de la imagen del producto
  id_inv: { type: String, required: true, unique: true }  // Identificador único para el inventario
});

const Producto = mongoose.model('Producto', productoSchema);
export default Producto;
