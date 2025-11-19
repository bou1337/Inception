#!/bin/bash

set -e


trap 'exit' TERM
echo "Waiting for MariaDB at $DB_HOST..."
until mariadb-admin ping -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
  sleep 2
done
echo "MariaDB is ready."

WORDPRESS_DIR="/var/www/html"
mkdir -p "$WORDPRESS_DIR"
cd "$WORDPRESS_DIR"

if [ ! -f "wp-config.php" ]; then
    echo "Starting WordPress initial setup..."

        wp core download --allow-root
    wp config create --allow-root --dbname="$DB_NAME" \
        --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="$DB_HOST"

    wp core install --allow-root \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create --allow-root "$WP_USER" "$WP_EMAIL" \
            --user_pass="$WP_PASSWORD" --role=editor

    wp theme activate twentytwentythree --allow-root 
    echo "WordPress setup complete."
fi

echo "Starting PHP-FPM..."
mkdir -p /run/php
exec /usr/sbin/php-fpm7.4 -F