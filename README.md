# Instruções de uso do Docker Compose

# build dos containers completos (PHP + Apache + Mysql)
- sudo docker-compose build

# rodando todos os containers (PHP + Apache + Mysql)
- docker-compose up -d

# rodando containers individuais
- docker-compose up -d app
- docker-compose up -d db