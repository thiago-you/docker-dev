# Guia Rápido

Instruções básicas para realizar o build e utilizar o ambiente docker.

### Instalando Ambiente

```
cd /var/www/
mkdir docker
cd docker
git clone https://github.com/thiago-you/docker-dev.git dev
```

# Deploy do ambiente

Para fazer o deploy automático do ambiente é possível executar o arquivo "deploy.sh". Esse arquivo vai instalar o "Docker" e o "Docker Compose", fazer a inicialização dos arquivos de configuração e também vai subir o ambiente.

**Atenção:** Também é possível fazer todo o processo de deploy manualmente conforme as demais instruções nestes arquivo.

```shell
sudo sh deploy.sh
```

### Install Docker

```shell
sudo apt update && sudo apt install -y docker
sudo apt autoremove
```

### Install Docker-Compose

```shell
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Configuração do Ambiente

Para realizar a configuração do ambiente execute o arquivo de inicialização:

```shell
sh initialize.sh
```

### Criando volume

Use o comando abaixo para criar um volume externo de dados compartilhados no docker. Assim todos os dados de database do MySQL serão armazenados separadamente dos containers, evitando a perca de dados quando trabalhando com os containers.

```shell
docker volume create --name=mysql-data
```

### Build dos Containers

```
sudo docker-compose build
```

**Obs.:** Não é necessário realizar o build quando estiver utilizando apenas imagens.

### Rodando os Containers

Antes de rodar os containers, pare os serviços de Apache e MySQL (se existirem):

```
sudo service apache2 stop && sudo service mysql stop
```

Suba os containers em background (detached mode):

```
docker-compose up -d
```

### Rodando Containers Individuais
```
docker-compose up -d app
docker-compose up -d db
```

### Conectando em um Container
```
docker exec -it dev-app bash
```

### Executar Migration
Para executar a migration é necessário conectar no container da aplicação e então executar o comando normalmente:

```
docker exec -it dev-app bash
cd project
vendor/bin/phinx migrate
```

Também é possível executar o comando de fora do container:

```
docker exec dev-app ./project/vendor/bin/phinx migrate --configuration project/phinx.php
```

Também podemos criar um script que execute este comando (dentro do container):

```
docker exec -it dev-app bash

echo “./project/vendor/bin/phinx migrate --configuration project/phinx.php” >> /var/www/html/migrate.sh
sudo chmod +x migrate.sh
```

Após isso, podemos simplesmente executar esse script dentro do nosso container:

```
docker exec dev-app ./migrate.sh
```

### Criando Usuário do MySQL
Em alguns casos também é recomendado criar um usuário para o serviço de MySql, caso já não exista:

```
# deleta o usuário mysql
sudo userdel mysql

# adiciona o usuário mysql
sudo useradd -u 999 mysql
```

### Logs de Erro do Container
```
docker logs --tail 50 --follow --timestamps dev-app
```

### Adicionando um ambiente/extensão PHP
Primeiro, rodamos um novo container PHP:

```
docker run -dit --name php7.4 php:7.4-alpine
```

Após isso, criamos um arquivo path do PHP que vai encaminhar todas as chamadas para serem executadas neste container, para isso:
Crie um arquivo executável chamado "php":

```
sudo touch /usr/local/bin/php
sudo chmod +x /usr/local/bin/php
```

Dentro deste arquivo temos que adicionar o comando para redirecionar a chamada para o container criado:

```
echo "docker exec -i --user=1000:1000 php7.4 php \"\$@\"" >> /usr/local/bin/php
```

Agora basta testar os comandos PHP:

```
php -v
```

### Configurações no Windows
Para utilizarmos o docker no Windows (com WSL2) é necessário que seja instalado o Docker Desktop diretamente na camada do Windows. Neste caso, podemos baixar e instalar pelo [site oficial](https://docs.docker.com/docker-for-windows/install/):

Outro detalhe é que para os “virtual host” funcionarem também é necessário que seja realizado a configuração do arquivo “hosts” tanto no WSL quanto no Windows. Segue o caminho do arquivo no Windows:

```
C:\Windows\system32\drives\etc\hosts
```

Ou, acessando pelo WSL:

```
/mnt/c/Windows/system32/drives/etc/hosts
```

**Atenção:** Caso esteja configurando o “network mode” em algum docker-compose no Windows, o modo “host” não funciona devido a camada de abstração da virtualização, neste caso é necessário utiliza o modo default “bridge“.

### Parando o Apache2 e o MySQL
Parando o Apache2 eo MySQL de forma permanente:

```
sudo service apache2 stop
sudo update-rc.d apache2 disable
sudo service mysql stop
sudo update-rc.d mysql disable
```
