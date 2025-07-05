import mongoose from 'mongoose';

const publicacionSchema = new mongoose.Schema({
  titulo: { type: String, required: true },
  contenido: { type: String, required: true },
  imagen: { type: String, required: false },  // Base64 de la imagen
  fecha_publicacion: { type: Date, default: Date.now },  // Fecha actual por defecto
  usuario_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Usuario', required: true }  // Referencia a la colección Usuario
});

const Publicacion = mongoose.model('Publicacion', publicacionSchema);
export default Publicacion;
