FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

COPY . .

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app ./

USER node

EXPOSE 3000

CMD ["npm", "start"]