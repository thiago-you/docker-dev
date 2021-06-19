## Instruções de uso do Docker Compose

### build dos containers completos (PHP + Apache + Mysql)
- sudo docker-compose build

### rodando todos os containers (PHP + Apache + Mysql)
- docker-compose up -d

### rodando containers individuais
- docker-compose up -d app
- docker-compose up -d db

### conectando em um container
- docker exec -it cpn-app /bin/bash

### executar migration
- para executar a migration é necessário conectar no container da aplicação e então executar o comando normalmente:
- docker exec -it cpn-app /bin/bash
- cd cconetphalcon
- vendor/bin/phinx migrate

### criando usuario do MYSQL
- sudo userdel mysql
- sudo useradd -u 999 mysql

### ATENÇÂO: no arquivo .env o user e o password não podem utilizar o valor "root"