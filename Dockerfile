# Etapa 1: builder
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

COPY . .

# Etapa 2: runtime
FROM node:20-alpine AS runtime

WORKDIR /app

COPY --from=builder /app ./

# Ejecuta el contenedor con un usuario no root
USER node

EXPOSE 3000

# Verifica que la API responda en /health
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
	CMD node -e "fetch('http://127.0.0.1:3000/health').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"

CMD ["npm", "start"]