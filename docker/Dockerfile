FROM php:8.3-fpm

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libjpeg-dev libonig-dev libxml2-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring gd

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar app
WORKDIR /var/www/html
COPY . .

# Permisos
RUN chown -R www-data:www-data /var/www/html/storage \
    && chown -R www-data:www-data /var/www/html/bootstrap/cache

CMD ["php-fpm"]