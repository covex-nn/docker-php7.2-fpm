FROM php:7.1-fpm-alpine

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

RUN apk add --no-cache \
        icu-dev \
        libmcrypt-dev \
    && docker-php-ext-install \
        intl \
        mbstring \
        mcrypt \
        pdo_mysql \
        zip \
        opcache \
    && pecl install xdebug

RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin \
      --filename=composer

RUN adduser -h /home/docker -D docker \
    && mkdir /home/docker/vendor \
    && mkdir /home/docker/.composer \
    && echo "{ }" > /home/docker/.composer/config.json \
    && composer config --file=/home/docker/.composer/config.json vendor-dir /home/docker/vendor \
    && composer config --global vendor-dir /home/docker/vendor

COPY sync-vendor.php /home/docker/sync-vendor.php
RUN chmod 744 /home/docker/sync-vendor.php \
    && chown -R docker:docker /home/docker

VOLUME [ "/home/docker/.composer" ]
