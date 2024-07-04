# Utiliser l'image officielle Flutter 3.22
FROM ghcr.io/cirruslabs/flutter:3.22.2

# Définir le répertoire de travail
WORKDIR /app

# Copier tous les fichiers dans le conteneur
COPY . .

# Exécuter la construction de l'application Flutter
RUN flutter build web

# Utiliser une image nginx pour servir l'application
FROM nginx:stable-alpine

# Copier les fichiers construits vers le répertoire de nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Copier les fichiers de configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl/cert.crt /etc/ssl/certs/
COPY ssl/cert.key /etc/ssl/private/

# Exposer les ports 80 et 443 pour HTTP et HTTPS
EXPOSE 80
EXPOSE 443

# Démarrer nginx en mode déconnecté
CMD ["nginx", "-g", "daemon off;"]