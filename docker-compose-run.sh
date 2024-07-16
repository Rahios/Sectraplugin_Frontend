#VERSION 1 - Classique :
docker compose up -d

#VERSION 2 - Manuelle :
#docker run -d -p 80:80 -p 443:443 --name flutter-web-container flutter-web-app
# -d : Execute le conteneur en arriere-plan (detache).
# -p 80:80 : Mappe le port 80 du conteneur au port 80 de l'hote (HTTP).
# -p 443:443 : Mappe le port 443 du conteneur au port 443 de l'hote (HTTPS).
# --name flutter-web-container : Donne un nom au conteneur.
# flutter-web-app : Nom de l'image Docker que vous avez construite.



