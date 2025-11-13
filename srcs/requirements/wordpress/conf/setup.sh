#!/bin/bash
set -e

# Wait for MariaDB to be ready
sleep 10

# --- START: Conditional Installation Block ---

# Check if wp-config.php exists. If it does, WordPress is already installed.
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
    echo "wp-config.php not found. Running initial WordPress setup."

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
    
    echo "WordPress setup complete."
else
    echo "wp-config.php found. Skipping initial WordPress setup."
fi

# --- END: Conditional Installation Block ---

# This command must run unconditionally to keep the container alive
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F