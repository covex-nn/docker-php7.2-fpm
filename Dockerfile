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

COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

ENV PATH "/composer/vendor/bin:/composer/home/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer/home

RUN curl -sS https://getcomposer.org/installer | php -- \
      --install-dir=/usr/local/bin \
      --filename=composer \
    && composer global require phing/phing ~2.0 \
    && mkdir /composer/vendor \
    && echo "{ }" > /composer/home/config.json \
    && composer config --global vendor-dir /composer/vendor

COPY sync-vendor.php /usr/local/bin/sync-vendor

RUN apk add --no-cache sudo acl \
    && chmod 744 /usr/local/bin/sync-vendor \
    && chmod 644 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && rm /tmp/* -rf

VOLUME [ "/composer/home/cache" ]
