#!/usr/bin/env bash
set -e

cd /var/www/html

# Si no quieres generarla automáticamente, comenta esto y define APP_KEY en .env
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:" ]; then
  php artisan key:generate --force || true
fi

# Descubrir paquetes y optimizar caches
php artisan package:discover --ansi || true
php artisan optimize

# Migraciones (útil en QA; en prod mejor desde el pipeline)
php artisan migrate --force || true

exec /usr/bin/supervisord -c /etc/supervisord.conf