#!/bin/bash

# Nom de l'image Docker sur Docker Hub
IMAGE="zezols/banaleweb:latest"

echo "Téléchargement de l'image $IMAGE ..."
docker pull $IMAGE

echo "Arrêt et suppression d'un conteneur existant nommé 'banaleweb' (si présent)..."
docker rm -f banaleweb 2>/dev/null || true

echo "Lancement d'un nouveau conteneur 'banaleweb' exposant le port 8080 ..."
docker run -d -p 8080:80 --name banaleweb $IMAGE

echo "Terminé ! Tu peux accéder à l'application sur http://localhost:8080"
