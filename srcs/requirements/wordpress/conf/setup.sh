#!/bin/bash
set -e

# Wait for MariaDB to be ready
sleep 10

# Download WordPress core
wp core download --allow-root

# Create wp-config.php
wp config create --allow-root \
  --dbname=$SQL_DATABASE \
  --dbuser=$SQL_USER \
  --dbpass=$SQL_PASSWORD \
  --dbhost=mariadb:3306

# Install WordPress
wp core install --allow-root \
  --url=$WP_URL \
  --title=$WP_TITLE \
  --admin_user=$WP_ADMIN_USER \
  --admin_password=$WP_ADMIN_PASSWORD \
  --admin_email=$WP_ADMIN_EMAIL

# Create a secondary user
wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PASSWORD --allow-root

php-fpm7.4 -F
