FROM node:20-alpine

RUN apk update && apk add --no-cache \
    git \
    ffmpeg \
    bash \
    openssl \
    curl \
    python3 \
    make \
    g++

WORKDIR /evolution

# Clona a versão estável
RUN git clone --depth 1 --branch 2.3.7 https://github.com/EvolutionAPI/evolution-api.git .

# Instala dependências
RUN npm install

# Cria .env mínimo para o Prisma
RUN echo "DATABASE_PROVIDER=postgresql" > .env && \
    echo "DATABASE_CONNECTION_URI=postgresql://user:pass@localhost:5432/evolution" >> .env

# Gera o schema + Prisma Client
RUN chmod +x ./Docker/scripts/*.sh || true
RUN ./Docker/scripts/generate_database.sh

# Faz o build
RUN npm run build

# Remove dependências de desenvolvimento
RUN npm prune --omit=dev

EXPOSE 8080

# Roda a migração e depois inicia a API
CMD ["sh", "-c", "npx prisma db push --accept-data-loss && npm run start:prod"]
