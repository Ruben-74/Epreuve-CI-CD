# Multi-stage Build
FROM node:20-alpine AS builder

LABEL maintainer="DevSecOps ARZ "
LABEL version="1.0.0"

WORKDIR /app

# Installation des dépendances uniquement
COPY src/package*.json ./
RUN npm ci --only=production


# Multi-stage Runtime
FROM node:20-alpine

# Récupération des fichiers depuis le builder
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY src/server.js .
COPY src/package.json .

# Création d'un utilisateur non-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app
USER appuser

# Port exposé
EXPOSE 3000

# Healthcheck : 
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:3000/health').then(r => r.ok ? process.exit(0) : process.exit(1))"

# Lancement de l'application
CMD ["node", "server.js"]
