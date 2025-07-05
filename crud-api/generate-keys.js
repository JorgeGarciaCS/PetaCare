// Script para generar claves seguras para el .env
import crypto from 'crypto';

console.log('🔐 Generando claves seguras para PetACare...\n');

// Generar clave JWT
const jwtSecret = crypto.randomBytes(64).toString('hex');
console.log('JWT_SECRET=', jwtSecret);

// Generar clave de sesión
const sessionSecret = crypto.randomBytes(64).toString('hex');
console.log('SESSION_SECRET=', sessionSecret);

console.log('\n📝 Copia estas claves en tu archivo .env');
console.log('⚠️  IMPORTANTE: Nunca compartas estas claves públicamente');
