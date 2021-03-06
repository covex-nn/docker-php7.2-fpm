FROM php:7.2-fpm-stretch

COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY sync-vendor.php /usr/local/bin/sync-vendor

ENV PATH "/composer/vendor/bin:/composer/home/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer/home

RUN apt-get update && apt-get install -y \
            libicu-dev \
            zlib1g-dev \
            acl \
		    cron \
		    netcat \
    && docker-php-ext-install -j$(nproc) \
            intl \
            opcache \
            pdo_mysql \
            zip \
    && pecl install xdebug \
    && curl -sS https://getcomposer.org/installer | php -- \
             --install-dir=/usr/local/bin \
             --filename=composer \
    && mkdir /composer/vendor \
    && curl -sS -L -o /usr/local/bin/phing http://www.phing.info/get/phing-latest.phar \
    && chmod 744 /usr/local/bin/phing /usr/local/bin/sync-vendor \
    && chmod 644 /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && docker-php-source delete \
    && rm -rf /var/lib/apt/lists/* /tmp/*

VOLUME [ "/composer/home/cache" ]
