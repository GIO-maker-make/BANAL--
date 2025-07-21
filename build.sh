#!/bin/bash

# Couleurs pour les messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Début du build Docker...${NC}"

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker n'est pas installé. Veuillez l'installer d'abord.${NC}"
    exit 1
fi

# Vérifier si le port 80 est disponible
if lsof -Pi :80 -sTCP:LISTEN -t >/dev/null ; then
    echo -e "${RED}Le port 80 est déjà utilisé. Veuillez libérer le port ou utiliser un autre port.${NC}"
    exit 1
fi

# Build de l'image Docker
echo -e "${BLUE}Construction de l'image Docker...${NC}"
docker build -t banale-web .

# Vérification du build
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build réussi !${NC}"
    
    # Arrêt du conteneur existant s'il existe
    echo -e "${BLUE}Arrêt des conteneurs existants...${NC}"
    docker stop banale-web-container 2>/dev/null
    docker rm banale-web-container 2>/dev/null
    
    # Démarrage du nouveau conteneur
    echo -e "${BLUE}Démarrage du conteneur...${NC}"
    docker run -d -p 80:80 --name banale-web-container banale-web
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Conteneur démarré avec succès !${NC}"
        echo -e "${BLUE}Le site est accessible à l'adresse : http://localhost${NC}"
        
        # Vérifier que le conteneur répond
        echo -e "${BLUE}Vérification de l'accès au site...${NC}"
        if curl -s http://localhost > /dev/null; then
            echo -e "${GREEN}Le site est accessible !${NC}"
        else
            echo -e "${RED}Le site n'est pas accessible. Vérifiez les logs avec : docker logs banale-web-container${NC}"
        fi
    else
        echo -e "${RED}Erreur lors du démarrage du conteneur${NC}"
        exit 1
    fi
else
    echo -e "${RED}Erreur lors du build${NC}"
    exit 1
fi 