# Utiliser l'image officielle de Nginx comme base
FROM nginx:alpine

# Installer les dépendances nécessaires
RUN apk add --no-cache \
    curl \
    ca-certificates \
    openssl

# Créer le répertoire pour les certificats SSL
RUN mkdir -p /etc/nginx/ssl

# Copier les fichiers du site dans le répertoire de Nginx
COPY . /usr/share/nginx/html/

# Copier la configuration Nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Vérifier la configuration Nginx
RUN nginx -t

# Exposer le port 80
EXPOSE 80

# Commande pour démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
