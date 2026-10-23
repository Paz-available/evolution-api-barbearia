FROM node:20-alpine

# Dependências do sistema necessárias
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

# Clona a versão estável da Evolution API
RUN git clone --depth 1 --branch 2.3.7 https://github.com/EvolutionAPI/evolution-api.git .

# Instala dependências
RUN npm ci --omit=dev

# Gera o Prisma Client e faz o build
RUN npx prisma generate || true
RUN npm run build

# Porta que a Evolution usa
EXPOSE 8080

# Comando de start
CMD ["npm", "run", "start:prod"]
