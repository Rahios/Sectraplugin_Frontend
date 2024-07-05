# Utiliser l'image officielle Flutter 3.22.2 pour la phase de build
FROM ghcr.io/cirruslabs/flutter:3.22.2 AS build

# Construire l'ID utilisateur et l'ID groupe comme arguments
ARG USER_ID
ARG GROUP_ID

# Installer sudo et créer un utilisateur non-root avec sudo sans mot de passe
RUN apt-get update && \
    apt-get install -y sudo && \
    addgroup --gid ${GROUP_ID} user && \
    adduser --uid ${USER_ID} --gid ${GROUP_ID} --disabled-password --gecos "Default user" user && \
    echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Changer les permissions du répertoire Flutter SDK
#RUN chown -R user:user /sdks/flutter
RUN chown -R ${USER_ID}:${GROUP_ID} /sdks/flutter


# Passer à l'utilisateur non-root
USER user

# Configurer Git pour autoriser le répertoire Flutter SDK
RUN git config --global --add safe.directory /sdks/flutter

# Définir le répertoire de travail à l'intérieur du conteneur
WORKDIR /home/user/app

# Copier les fichiers du projet dans le répertoire de travail du conteneur
COPY --chown=user:user . .

# Vérifier les permissions et la structure des fichiers
RUN ls -l /home/user/app
RUN ls -l /home/user/app/lib
RUN cat /home/user/app/pubspec.yaml

# Installer les dépendances Flutter
RUN flutter pub get

# Analyser le code pour détecter les erreurs et avertissements potentiels
#RUN flutter analyze

# Exécuter les tests unitaires (optionnel, mais recommandé)
#RUN flutter test

# Exécuter la construction de l'application Flutter pour le web
RUN timeout 3600s flutter build web 2>&1

# Utiliser une image nginx pour servir les fichiers web construits
FROM nginx:stable-alpine

# Copier les fichiers construits à partir de l'étape de build vers le répertoire par défaut de nginx
COPY --from=build /home/user/app/build/web /usr/share/nginx/html

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
