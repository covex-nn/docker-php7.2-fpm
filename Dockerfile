FROM php:7.1-fpm-alpine

RUN apk add --no-cache --virtual .persistent-deps \
        # for intl extension
        icu-dev \
        # for mcrypt extension
        libmcrypt-dev

RUN apk add --no-cache --virtual .build-deps \
        autoconf \
        cmake \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c \
        openssl-dev

#RUN docker-php-ext-configure intl --enable-intl \
#    && docker-php-ext-configure mbstring --enable-mbstring \
#    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
#    && docker-php-ext-install \

# RUN docker-php-ext-install gd

RUN docker-php-ext-install \
        intl \
        mbstring \
        mcrypt \
        pdo_mysql \
        zip \
        opcache

RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin \
      --filename=composer

WORKDIR /var/www
