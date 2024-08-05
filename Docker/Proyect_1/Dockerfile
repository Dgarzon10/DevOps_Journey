# Usa una imagen oficial de Node.js como base
FROM node:18

# Establecer el directorio de trabajo en el contenedor
WORKDIR /home/miapp

# Copiar los archivos de package.json y package-lock.json al contenedor
COPY package*.json ./

# Instalar las dependencias de la aplicación
RUN npm install

# Copiar el código fuente de la aplicación al contenedor
COPY . .

# Exponer el puerto en el que la aplicación se ejecutará
EXPOSE 3000

# Comando por defecto para ejecutar la aplicación
CMD ["npm", "start"]
