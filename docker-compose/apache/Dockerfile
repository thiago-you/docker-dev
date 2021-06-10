FROM php:7.4-apache

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

RUN apt-get update

# Install common and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    apt-utils \
    apt-transport-https \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable apache mods.
RUN a2enmod rewrite

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND

USER $user

# Explicit Expose apache.
EXPOSE 80
