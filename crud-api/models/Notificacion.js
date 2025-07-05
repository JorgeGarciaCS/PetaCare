import mongoose from 'mongoose';

const notificacionSchema = new mongoose.Schema({
  mensaje: { type: String, required: true },  // El contenido del mensaje de la notificación
  fecha_envio: { type: Date, default: Date.now },  // Fecha de envío, por defecto la fecha y hora actual
  leido: { type: Boolean, default: false },  // Indica si la notificación ha sido leída
  usuario_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Usuario', required: true }  // Referencia al usuario que recibe la notificación
});

const Notificacion = mongoose.model('Notificacion', notificacionSchema);
export default Notificacion;
