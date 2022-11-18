#!/bin/bash

# copy environment if not exist
if [ ! -f '.env' ]; then
    cp .env.example .env
fi

# copy hosts if not exist
if [ ! -f 'data/apache/hosts' ]; then
    cp data/apache/hosts.example data/apache/hosts
fi

# copy php.ini if not exist
if [ ! -f 'data/php/php.ini' ]; then
    cp data/php/php.ini.example data/php/php.ini
fi

# copy script to init database and users if not exist
if [ ! -f 'data/mysql/init/01-init-databases.sql' ]; then
    cp data/mysql/init-databases.example.sql data/mysql/init/01-init-databases.sql
fi

# copy script to export database if not exist
if [ ! -f 'data/mysql/export.sh' ]; then
    cp data/mysql/export.example.sh data/mysql/export.sh
fi

# copy script to import database if not exist
if [ ! -f 'data/mysql/import.sh' ]; then
    cp data/mysql/import.example.sh data/mysql/import.sh
fi

# copy virtual hosts if not exist
cp data/apache/sites-default/* data/apache/sites-enabled/

# copy index to html if not exist
if [ ! -f '/var/www/html/index.php' ]; then
    cp data/apache/index.php /var/www/html/index.php
fi

echo 'Arquivos de configuração inicialiazados!'