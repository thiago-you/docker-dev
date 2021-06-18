# Instruções de uso do Docker Compose

# build dos containers completos (PHP + Apache + Mysql)
- sudo docker-compose build

# build dos containers individuais
- sudo docker-compose build -f containers/php-apache.yml -f containers/database.yml build

# rodando o container completo
- docker-compose up -d

# rodando containers individuais
- docker-compose -f containers/php-apache.yml up -d

# também é possível rodar com a flag para remover os containers não utilizados (se tiver rodado todos)
- docker-compose -f containers/php-apache.yml up -d --remove-orphans