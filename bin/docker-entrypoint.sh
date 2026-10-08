#!/usr/bin/env bash
set -Eeuo pipefail

cd /var/www/html

if [[ ! -f composer.json ]]; then
    echo 'Application source is missing from /var/www/html.' >&2
    exit 1
fi

mkdir -p data/cache data/documents/waivers public/data

if [[ ! -e public/data/documents ]]; then
    ln -s /var/www/html/data/documents public/data/documents
fi
if [[ ! -e PHPMailer && -d module/Application/src/Controller/Helper/PHPMailer ]]; then
    ln -s /var/www/html/module/Application/src/Controller/Helper/PHPMailer PHPMailer
fi
if [[ ! -e public/assets && -d assets ]]; then
    ln -s /var/www/html/assets public/assets
fi

# Named volumes are created as root by Docker. Apache runs as www-data and
# must be able to write Laminas cache and generated document files.
chown -R www-data:www-data data/cache data/documents

if [[ ! -f vendor/autoload.php || composer.lock -nt vendor/autoload.php || composer.json -nt vendor/autoload.php ]]; then
    composer install --no-interaction --prefer-dist --optimize-autoloader
fi

if [[ -x bin/clear-config-cache.php || -f bin/clear-config-cache.php ]]; then
    php bin/clear-config-cache.php || true
fi

exec "$@"
