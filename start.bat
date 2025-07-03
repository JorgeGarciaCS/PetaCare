@echo off
REM Script para iniciar PetACare - Backend y Frontend

echo 🐾 Iniciando PetACare...

REM Verificar si Node.js está instalado
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js no está instalado. Por favor, instálalo desde https://nodejs.org/
    pause
    exit /b 1
)

echo 🚀 Iniciando Backend...
cd crud-api
start /b npm start

REM Esperar un poco para que el backend inicie
timeout /t 5 /nobreak >nul

echo 🌐 Iniciando Frontend...
cd ..\frontend
start /b npm start

echo ✅ PetACare iniciado exitosamente!
echo    Backend: http://localhost:3000
echo    Frontend: http://localhost:3001
echo.
echo Para detener los servidores, cierra esta ventana o presiona Ctrl+C
echo.

pause
