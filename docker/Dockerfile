# ---------- STAGE 1: composer ----------
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-progress --no-interaction
COPY . .
RUN composer dump-autoload --optimize --no-dev

# ---------- STAGE 2: vite build ----------
FROM node:20-alpine AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci || npm i
COPY . .
RUN npm run build

# ---------- STAGE 3: runtime ----------
FROM php:8.3-fpm-alpine

# Paquetes del SO y extensiones
RUN apk add --no-cache nginx supervisor bash curl git icu-dev oniguruma-dev libzip-dev libpng-dev libjpeg-turbo-dev libwebp-dev \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install pdo pdo_mysql intl zip gd bcmath

WORKDIR /var/www/html

# Copiar app, vendor y assets
COPY --from=vendor /app /var/www/html
COPY --from=assets /app/public/build /var/www/html/public/build

# Nginx + Supervisor + entrypoint
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Permisos mínimos necesarios
RUN addgroup -g 1000 app && adduser -D -G app -u 1000 app \
    && chown -R app:app /var/www/html
USER app

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]