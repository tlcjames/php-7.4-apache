FROM php:7.4-apache
MAINTAINER TLC <james@tlc-direct.co.uk>

# Install GD
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

COPY ./99-xdebug.ini.disabled /usr/local/etc/php/conf.d/

# Define PHP_TIMEZONE env variable
ENV PHP_TIMEZONE Europe/London

# Configure Apache Document Root
ENV APACHE_DOC_ROOT /var/www/html

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Additional PHP ini configuration
COPY ./999-php.ini /usr/local/etc/php/conf.d/

COPY ./index.php /var/www/html/index.php

########################################################################################################################

# Start!
COPY ./start /usr/local/bin/
CMD ["start"]
