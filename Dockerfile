FROM php:7.3-apache

RUN apt-get update \
   && apt-get -y upgrade \
   && apt-get -y install libzip-dev unzip libz-dev libpng-dev \
   && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure zip \
   && docker-php-ext-configure gd \
   && docker-php-ext-configure pdo_mysql \
   && docker-php-ext-install zip \
   && docker-php-ext-install gd \
   && docker-php-ext-install pdo_mysql

# Install Akaunting
ENV AKAUNTING_VERSION 1.3.17
WORKDIR /var/www/html/
RUN curl \
        --location \
        -o akaunting.zip \
        https://github.com/akaunting/akaunting/releases/download/${AKAUNTING_VERSION}/Akaunting_${AKAUNTING_VERSION}-Stable.zip \
    && unzip akaunting.zip \
    && rm akaunting.zip \
    && chown -R www-data:www-data /var/www/html

COPY --chown=www-data:www-data ./trustedproxy.php /var/www/html/config/

RUN cp .env.example .env \
    && chown www-data:www-data .env
RUN a2enmod rewrite
RUN a2enmod proxy
