# Utiliser l'image officielle Flutter 3.22
FROM ghcr.io/cirruslabs/flutter:3.22.2 AS build

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

# Générer des certificats SSL auto-signés dans le conteneur
RUN apk add openssl && \
    mkdir -p /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/cert.key -out /etc/ssl/certs/cert.crt -subj "/CN=localhost"


# Copier les fichiers de configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Exposer les ports 80 et 443 pour HTTP et HTTPS
EXPOSE 80
EXPOSE 443

# Démarrer nginx en mode déconnecté
CMD ["nginx", "-g", "daemon off;"]