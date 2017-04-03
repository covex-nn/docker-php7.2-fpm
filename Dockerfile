FROM php:7.1-fpm-alpine

# https://github.com/prooph/docker-files/blob/master/php/7.1-fpm

# persistent / runtime deps
ENV PHPIZE_DEPS \
        autoconf \
        cmake \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c

RUN apk add --no-cache --virtual .persistent-deps \
        # for intl extension
        icu-dev \
        # for mcrypt extension
        libmcrypt-dev \
        # for gd
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev

RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        openssl-dev \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
        bcmath \
        intl \
        mcrypt \
        pcntl \
        pdo_mysql \
        mbstring \
        gd \
        zip \
        opcache

RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin \
      --filename=composer

WORKDIR /var/www
