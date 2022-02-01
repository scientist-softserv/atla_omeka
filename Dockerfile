FROM php:7.3.33-apache

RUN a2enmod rewrite

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install \
    curl \
    imagemagick \
    libfreetype6-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    unzip \
    zip \
    zlib1g-dev \
    && echo 'DONE'


# install the PHP extensions we need
RUN pecl install mcrypt-1.0.4 && pecl install imagick && \
    docker-php-ext-install -j$(nproc) \
      iconv \
      pdo \
      pdo_mysql \
      mysqli \
      gd \
      exif \
    && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-enable exif imagick mcrypt

COPY . /var/www/html/exhibitions
COPY ./imagemagick-policy.xml /etc/ImageMagick/policy.xml

CMD ["apache2-foreground"]
