# Dockerfile pour la construction et le déploiement d'une application Flutter pour le web

# Étapes en résumé :
# 1. Utiliser une image Flutter officielle pour la phase de build.
# 2. Créer un utilisateur non-root avec sudo sans mot de passe pour des raisons de sécurité et ajuster les permissions du SDK Flutter.
# 3. Configurer Git et définir le répertoire de travail, puis copier les fichiers du projet dans le conteneur. (evite des erreurs de permissions)
# 4. Installer les dépendances Flutter et vérifier la structure des fichiers.
# 5. Construire l'application Flutter pour le web.
# 6. Utiliser une image nginx pour servir les fichiers web construits et configurer HTTPS avec des certificats SSL auto-signés.

# Pourquoi un utilisateur non-root est nécessaire :
# Utiliser un utilisateur non-root améliore la sécurité en limitant les privilèges des processus exécutés dans le conteneur.

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

# Exécuter la construction de l'application Flutter pour le web.
# Attribut --Release pour une version de production optimisée.
RUN timeout 3600s flutter build web --release 2>&1

# Utiliser une image nginx pour servir les fichiers web construits
FROM nginx:stable-alpine

# Copier les fichiers construits à partir de l'étape de build vers le répertoire par défaut de nginx
COPY --from=build /home/user/app/build/web /usr/share/nginx/html

# Générer des certificats SSL auto-signés dans le conteneur
# Suggestions : Modifier ce code pour ne pas stocker un secret dans l'image & Supprimer le cache après l'installation des paquets.
#RUN apk add openssl && \
#    mkdir -p /etc/ssl/private && \
#    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/cert.key -out /etc/ssl/certs/cert.crt -subj "/CN=localhost"

# Copier les certificats SSL dans le conteneur
COPY web/sslCertificates/vlbeltbsectra.hevs.ch.key /etc/ssl/private/cert.key
COPY web/sslCertificates/vlbeltbsectra.hevs.ch.crt /etc/ssl/certs/cert.crt


# Copier les fichiers de configuration nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Exposer les ports 80 et 443 pour HTTP et HTTPS
EXPOSE 80
EXPOSE 443

# Démarrer nginx en mode déconnecté
CMD ["nginx", "-g", "daemon off;"]
