// Script para verificar usuarios registrados en la base de datos
import mongoose from 'mongoose';
import Usuario from './models/Usuario.js';
import dotenv from 'dotenv';

dotenv.config();

const checkUsers = async () => {
  try {
    console.log('🔍 Conectando a MongoDB...');
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Conectado a MongoDB');

    console.log('\n👥 Usuarios registrados:');
    console.log('=' .repeat(50));

    const usuarios = await Usuario.find({}).select('-password');
    
    if (usuarios.length === 0) {
      console.log('❌ No hay usuarios registrados');
    } else {
      console.log(`📊 Total de usuarios: ${usuarios.length}\n`);
      
      usuarios.forEach((usuario, index) => {
        console.log(`${index + 1}. ${usuario.primer_nombre} ${usuario.apellido_pat}`);
        console.log(`   👤 Usuario: ${usuario.username}`);
        console.log(`   📧 Email: ${usuario.correo_contacto}`);
        console.log(`   🆔 DNI: ${usuario.dni}`);
        console.log(`   📱 Teléfono: ${usuario.telefono}`);
        console.log(`   📅 Registro: ${usuario.fecha_registro.toLocaleDateString()}`);
        console.log(`   🏠 Dirección: ${usuario.direccion}`);
        console.log('   ' + '-'.repeat(40));
      });
    }

    await mongoose.disconnect();
    console.log('\n🔌 Desconectado de MongoDB');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
};

checkUsers();
