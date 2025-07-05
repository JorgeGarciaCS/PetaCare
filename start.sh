#!/bin/bash

# Script para iniciar PetACare - Backend y Frontend

echo "🐾 Iniciando PetACare..."

# Verificar si Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado. Por favor, instálalo desde https://nodejs.org/"
    exit 1
fi

# Verificar si MongoDB está corriendo
if ! pgrep -x "mongod" > /dev/null; then
    echo "⚠️  MongoDB no está corriendo. Asegúrate de tenerlo iniciado."
    echo "   Puedes iniciarlo con: mongod"
fi

echo "🚀 Iniciando Backend..."
cd crud-api
npm start &
BACKEND_PID=$!

# Esperar un poco para que el backend inicie
sleep 5

echo "🌐 Iniciando Frontend..."
cd ../frontend
npm start &
FRONTEND_PID=$!

echo "✅ PetACare iniciado exitosamente!"
echo "   Backend: http://localhost:3001"
echo "   Frontend: http://localhost:3002"
echo ""
echo "Para detener los servidores, presiona Ctrl+C"

# Función para limpiar procesos al salir
cleanup() {
    echo "🛑 Deteniendo servidores..."
    kill $BACKEND_PID $FRONTEND_PID
    exit 0
}

# Capturar señal de interrupción
trap cleanup SIGINT

# Mantener el script corriendo
wait
