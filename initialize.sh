#!/bin/bash

# copy environment if not exist
if [ ! -f '.env' ]; then
    cp .env.example .env
fi

# copy hosts if not exist
if [ ! -f 'docker-compose/apache/hosts' ]; then
    cp docker-compose/apache/hosts.example docker-compose/apache/hosts
fi

# copy php.ini if not exist
if [ ! -f 'docker-compose/php/php.ini' ]; then
    cp docker-compose/php/php.ini.example docker-compose/php/php.ini
fi

# copy script to init database and users if not exist
if [ ! -f 'docker-compose/mysql/init/01-init-databases.sql' ]; then
    cp docker-compose/mysql/init-databases.example.sql docker-compose/mysql/init/01-init-databases.sql
fi

# copy script to export database if not exist
if [ ! -f 'docker-compose/mysql/export.sh' ]; then
    cp docker-compose/mysql/export.example.sh docker-compose/mysql/export.sh
fi

# copy script to import database if not exist
if [ ! -f 'docker-compose/mysql/import.sh' ]; then
    cp docker-compose/mysql/import.example.sh docker-compose/mysql/import.sh
fi

# copi virtual hosts if not exist
cp docker-compose/apache/sites-default/* docker-compose/apache/sites-available/

echo 'Arquivos de configuração inicialiazados!'