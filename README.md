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
Para executar a migration é necessário conectar no container da aplicação e então executar o comando normalmente:
- docker exec -it cpn-app /bin/bash
- cd cconetphalcon
- vendor/bin/phinx migrate

### criando usuario do MYSQL
- sudo userdel mysql
- sudo useradd -u 999 mysql

### ATENÇÂO: no arquivo .env o user e o password não podem utilizar o valor "root"

### Utilize este comando para exibir logs de error
- docker logs --tail 50 --follow --timestamps cpn-db

### Adicionando um ambiente/extensão PHP
Primeiro, rodamos um novo container PHP:
- docker run -dit --name php7.4 php:7-4-alpine

Após isso, criamos um arquivo path do PHP que vai encaminhar todas as chamadas para serem executadas neste container, para isso:
Crie um arquivo executável chamado "php":
- sudo touch /usr/local/bin/php
- sudo chmod +x /usr/local/bin/php

Dentro deste arquivo, adicione o seguinte conteudo:
- docker exec -i --user=1000:1000 php7.4 php "$@"

isso pode ser reliazado com o comando:
- echo "docker exec -i --user=1000:1000 php7.4 php \"\$@\"" >> /usr/local/bin/php

Agora basta testar os comandos PHP:
- php -v

### Atenção: o network mode "host" não funciona no WSL, sendo então necessário rodar com o modo default "bridge".

### Atenção: no WSL do windows também é necessário adicionar os sites locais no /etc/hosts do windows (C:\Windows\system32\drives\etc\hosts).