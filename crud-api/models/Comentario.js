import mongoose from 'mongoose';

const comentarioSchema = new mongoose.Schema({
  usuario_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Usuario', required: true },  // Referencia al usuario que hace el comentario
  mensaje: { type: String, required: true },  // El contenido del comentario
  fecha_comentario: { type: Date, default: Date.now },  // Fecha actual por defecto
  publicacion_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Publicacion', required: true }  // Referencia a la publicación en la que se comenta
});

const Comentario = mongoose.model('Comentario', comentarioSchema);
export default Comentario;
