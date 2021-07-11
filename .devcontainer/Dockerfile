FROM php:8.0.8-apache
RUN apt update -y \
      && apt install -y git libpq-dev \
      && apt -y clean \
      && docker-php-ext-install pgsql pdo pdo_pgsql
