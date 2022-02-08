# PHP

FROM php:7.4-cli

# System packages

RUN apt-get update
RUN apt-get install -y git unzip wget

# PHP extensions
# https://github.com/mlocati/docker-php-extension-installer

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions zip

# Composer

COPY --from=composer:2.2.3 /usr/bin/composer /usr/local/bin/composer

# Code

WORKDIR /code
RUN wget https://github.com/yiisoft/yii2-apidoc/files/7951291/app.zip
RUN unzip app.zip

# PHP packages

WORKDIR /code/app
ADD composer.json /code/app/
RUN composer install

ENTRYPOINT ["/code/app/vendor/bin/apidoc", "api", "/code/app", "/code/app-output"]
