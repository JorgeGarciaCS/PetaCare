import mongoose from 'mongoose';
import bcrypt from 'bcrypt';

const usuarioSchema = new mongoose.Schema({
  apellido_pat: { type: String, required: true },
  apellido_mat: { type: String, required: true },
  correo_contacto: { type: String, required: true, unique: true },
  direccion: { type: String, required: true },
  dni: { type: String, required: true, unique: true },
  fecha_nacimiento: { type: Date, required: true },
  fecha_registro: { type: Date, default: Date.now },
  primer_nombre: { type: String, required: true },
  segundo_nombre: { type: String, required: false },
  telefono: { type: String, required: true },
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true }
});

// Middleware para encriptar la contraseña antes de guardar
usuarioSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

// Método para comparar contraseñas
usuarioSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

const Usuario = mongoose.model('Usuario', usuarioSchema);
export default Usuario;
