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

# Instala todas as dependências (incluindo as de build)
RUN npm install

# Gera o Prisma Client e faz o build
RUN npx prisma generate || true
RUN npm run build

# Remove dependências de desenvolvimento para deixar a imagem menor
RUN npm prune --omit=dev

EXPOSE 8080

CMD ["npm", "run", "start:prod"]
