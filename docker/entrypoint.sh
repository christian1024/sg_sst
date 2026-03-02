#!/usr/bin/env bash
set -e

cd /var/www/html

# Si quieres evitar regenerar APP_KEY en prod, comenta esta sección y define APP_KEY por .env
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:" ]; then
  php artisan key:generate --force || true
fi

# Optimizar y migrar (para test/qa está bien; en prod mejor hacerlo desde pipeline)
php artisan optimize
php artisan migrate --force || true

exec /usr/bin/supervisord -c /etc/supervisord.conf