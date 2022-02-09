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

RUN wget -O laravel-app.zip https://github.com/yiisoft/yii2-apidoc/files/7951291/app.zip
RUN unzip laravel-app.zip

RUN composer create-project --prefer-dist yiisoft/yii2-app-basic yii2-app-basic

# PHP packages

WORKDIR /code/laravel-app
ADD composer.json /code/laravel-app/
RUN composer install

WORKDIR /code/yii2-app-basic
RUN composer require -W yiisoft/yii2-apidoc:3.0.1

ENTRYPOINT ["/code/yii2-app-basic/vendor/bin/apidoc", "api", "/code/yii2-app-basic", "/code/yii2-app-basic-api", "--interactive", "0", "--exclude", "vendor", "--page-title", "My Project - Documentacion"]
