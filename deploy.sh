#!/bin/bash

clear

echo '-------------------------------------------------------'
echo 'Inicializando configuração do ambiente...'

# inicializa as cofiguracoes do ambiente
sh initialize.sh
echo '-------------------------------------------------------\n'

# install docker
echo '-------------------------------------------------------'
APT_UPDATED=false

DOCKER="docker"
DOCKER_COMPOSE="docker-compose"

DOCKER_PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $DOCKER|grep "install ok installed")
DOCKER_COMPOSE_PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $DOCKER_COMPOSE|grep "install ok installed")

echo "Verificando $DOCKER..."

if [ "" = "$DOCKER_PKG_OK" ]; then
  if [! $APT_UPDATED ]; then
    APT_UPDATED=true
    sudo apt update -y
    echo '\n'
  fi

  echo "$DOCKER não instalado. Instalando $DOCKER..."
  sudo apt-get --yes install $DOCKER

  echo '\n-------------------------------------------------------'
  echo 'Pacote docker instalado com sucesso.'
else
  echo "Pacote $DOCKER já instalado."
fi

echo '-------------------------------------------------------'
echo '\n-------------------------------------------------------'
echo "Verificando $DOCKER_COMPOSE..."

if [ "" = "$DOCKER_COMPOSE_PKG_OK" ]; then
  if [! $APT_UPDATED ]; then
    APT_UPDATED=true
    sudo apt update -y
    echo '\n'
  fi

  echo "$DOCKER_COMPOSE não instalado. Instalando $DOCKER_COMPOSE..."

  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  echo '\n-------------------------------------------------------'
  echo 'Pacote docker-compose instalado com sucesso.'
else
  echo "Pacote $DOCKER_COMPOSE já instalado."
fi

echo '-------------------------------------------------------'

# seta a permissão do socket
sudo chmod 775 /var/run/docker.sock

echo '\n-------------------------------------------------------'
echo 'Parando ambiente local (Apache + MySQL)...'
echo '-------------------------------------------------------\n'

sudo service apache2 stop 2>/dev/null && sudo service mysql stop 2>/dev/null

if [ ! -f '/usr/local/bin/php' ]; then
  echo '-------------------------------------------------------'
  echo 'Configurando executavel do PHP...'

  PHP_APP=php7.4
  if [ "$(docker ps -q -f name=$PHP_APP)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=$PHP_APP)" ]; then
      echo 'Subindo container PHP...'
      docker container rm $PHP_APP 2>/dev/null
      docker run -dit --name $PHP_APP php:7.4-alpine > /dev/null 2>&1
    fi
  else
    echo 'Subindo container PHP...'
    docker container rm $PHP_APP 2>/dev/null
    docker run -dit --name $PHP_APP php:7.4-alpine > /dev/null 2>&1
  fi

  sudo touch /usr/local/bin/php
  sudo chmod +x /usr/local/bin/php
  sudo bash -c "echo \"docker exec -i --user=1000:1000 ""$PHP_APP"' php \"\$@\"" > /usr/local/bin/php'
  
  PHP=$(php -v)

  echo "\nRodando $PHP!"
  echo '-------------------------------------------------------\n'
fi

echo '-------------------------------------------------------'
echo 'Subindo ambiente docker...\n'

# build e up do ambiente
sudo docker-compose build -q
docker-compose up -d 2>/dev/null

DEV_APP='dev-app'
DEV_DB='dev-db'

if [ "$(docker ps -q -f name=$DEV_APP)" ]; then
  if [ "$(docker ps -aq -f status=exited -f name=$DEV_APP)" ]; then
    echo "O container $DEV_APP não está rodando!"
  else
    echo "O container $DEV_APP está rodando..."
  fi
fi

if [ "$(docker ps -q -f name=$DEV_DB)" ]; then
  if [ "$(docker ps -aq -f status=exited -f name=$DEV_DB)" ]; then
    echo "O container $DEV_DB não está rodando!"
  else
    echo "O container $DEV_DB está rodando..."
  fi
fi

echo '\nAmbiente docker está rodando!'
echo '-------------------------------------------------------'