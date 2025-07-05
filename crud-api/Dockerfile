# Dockerfile para Backend (crud-api)
FROM node:18-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache git

# Crear usuario no-root
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Crear directorio de trabajo
WORKDIR /usr/src/app

# Copiar archivos de configuración
COPY package*.json ./

# Instalar dependencias
RUN npm ci --only=production && npm cache clean --force

# Copiar código fuente
COPY . .

# Cambiar propietario de archivos
RUN chown -R nodejs:nodejs /usr/src/app
USER nodejs

# Exponer puerto
EXPOSE 3001

# Comando de inicio
CMD ["npm", "start"]
