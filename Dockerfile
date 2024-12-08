# Etapa de construcción
FROM node:20-alpine3.18 AS builder

WORKDIR /app

# Copia los archivos de package y instala las dependencias
COPY package*.json ./
RUN npm install

# Copia el resto de la aplicación
COPY . .

# Compila la aplicación si es necesario (por ejemplo, para aplicaciones TypeScript)
 RUN npm run build

# Etapa de despliegue
FROM node:20-alpine3.18 AS deploy

WORKDIR /app

# Copia las dependencias instaladas y los archivos de la aplicación desde la etapa de construcción
COPY --from=builder /app /app

# Exponer el puerto que usa tu aplicación
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["npm", "start"]
