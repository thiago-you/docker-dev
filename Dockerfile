FROM thiagoyou/cpn-php-kafka:latest

LABEL Thiago You <thiago.youx@gmail.com>

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Set for all apt-get install, must be at the very beginning of the Dockerfile.
ENV DEBIAN_FRONTEND noninteractive

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Install common and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    apt-utils \
    apt-transport-https \
    zip \
    unzip \
    vim \
    nano

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# copy PHP config
COPY ./docker-compose/php/php.ini /usr/local/etc/php/

# Set working directory
WORKDIR /var/www/html

# set php session permission
RUN mkdir -p /var/lib/php/sessions && \
    chown -R www-data:www-data /var/lib/php/sessions

# uncoment php extension from mime.types
RUN sed -i '/x-httpd-php/s/^#//g' /etc/mime.types

# Expose apache2 port
EXPOSE 80

# Expose angular serve port
EXPOSE 4200

# Expose node server port
EXPOSE 3000