FROM php:5.6-fpm

COPY sources.list /etc/apt/sources.list

RUN set -eux \
    && apt-get update \ 
    && apt-get install -y --no-install-recommends \
    curl zip unzip wget \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev

RUN docker-php-ext-install -j$(nproc) iconv bcmath pdo_mysql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install redis-4.3.0 \
    && docker-php-ext-enable redis

#remove cache
RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*