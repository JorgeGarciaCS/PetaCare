# Dockerfile para el proyecto completo PetaCare
# Este archivo está siendo reemplazado por dockerfiles específicos
# Ver: crud-api/Dockerfile y frontend/Dockerfile

FROM node:18-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache git

# Crear directorio de trabajo
WORKDIR /usr/src/app

# Copiar archivos de configuración
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar código fuente
COPY . .

# Exponer puerto
EXPOSE 3001

# Comando por defecto
CMD ["npm", "start"]
