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

# Define o provider
ENV DATABASE_PROVIDER=postgresql

# Gera o schema do Prisma (script oficial)
RUN chmod +x ./Docker/scripts/*.sh || true
RUN ./Docker/scripts/generate_database.sh || true

# Gera o client do Prisma
RUN npx prisma generate

# Faz o build
RUN npm run build

# Remove dependências de desenvolvimento
RUN npm prune --omit=dev

EXPOSE 8080

CMD ["npm", "run", "start:prod"]
