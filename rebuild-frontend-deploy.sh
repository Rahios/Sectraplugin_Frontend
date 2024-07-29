#!/bin/bash

# Bring down Docker services
docker compose down

# List all Docker images
docker rmi

# Remove the Docker image flutter-web-app:latest
docker rmi flutter-web-app:latest

# Execute the docker-build-image.sh script
bash docker-build-image.sh

# Bring up Docker services
docker compose up
