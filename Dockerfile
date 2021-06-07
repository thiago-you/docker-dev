FROM php:7.4-apache

LABEL Thiago You <thiago.youx@gmail.com>

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Set for all apt-get install, must be at the very beginning of the Dockerfile.
ENV DEBIAN_FRONTEND noninteractive

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /etc/php/7.4

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Persistent runtime dependencies
ARG DEPS="\
        php7.4 \
        php7.4-phar \
        php7.4-bcmath \
        php7.4-calendar \
        php7.4-mbstring \
        php7.4-exif \
        php7.4-ftp \
        php7.4-openssl \
        php7.4-zip \
        php7.4-sysvsem \
        php7.4-sysvshm \
        php7.4-sysvmsg \
        php7.4-shmop \
        php7.4-sockets \
        php7.4-zlib \
        php7.4-bz2 \
        php7.4-curl \
        php7.4-simplexml \
        php7.4-xml \
        php7.4-opcache \
        php7.4-dom \
        php7.4-xmlreader \
        php7.4-xmlwriter \
        php7.4-tokenizer \
        php7.4-ctype \
        php7.4-session \
        php7.4-fileinfo \
        php7.4-iconv \
        php7.4-json \
        php7.4-posix \
        php7.4-apache2 \
        php7.4-cli  \
        php7.4-dev \
        php7.4-common \
        php7.4-fpm \
        php7.4-gd \
        php7.4-intl \
        php7.4-mysql \
        php7.4-soap  \
        curl \
        ca-certificates \
        runit \
        apache2 \
"

RUN apt-get update

# Install common and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    apt-utils \
    curl \
    apt-transport-https \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# install MS core font
RUN sed -i'.bak' 's/$/ contrib/' /etc/apt/sources.list
RUN apt-get update; apt-get install -y ttf-mscorefonts-installer

# install the MUSTHAVE editor vim
# RUN apt-get install -y --no-install-recommends vim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    default-mysql-client

RUN docker-php-ext-install mysqli

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
# RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -y install \
#    apache2 php7.2 php7.2-mysql curl

# Enable apache mods.
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
# RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.4/apache2/php.ini
# RUN sed -i "s/error_reporting = .*$/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE & ~E_WARNING/" /etc/php/7.4/apache2/php.ini
# RUN sed -i "s/display_errors = .*$/display_errors = On/" /etc/php/7.4/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND

# Set working directory
WORKDIR /var/www/html
COPY www/ /var/www/html

USER $user

# Expose apache.
# EXPOSE 80
