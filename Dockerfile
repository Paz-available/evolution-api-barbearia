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

# Define o provider do banco (mesmo que não vamos usar banco agora)
ENV DATABASE_PROVIDER=postgresql

# Gera o schema e o client do Prisma
RUN node runWithProvider.js generate
RUN npx prisma generate

# Faz o build
RUN npm run build

# Remove dependências de desenvolvimento
RUN npm prune --omit=dev

EXPOSE 8080

CMD ["npm", "run", "start:prod"]
