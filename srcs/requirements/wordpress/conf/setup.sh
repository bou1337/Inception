
set -e
trap "exit" TERM

until mysqladmin ping -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
  sleep 2
done

cd /var/www/html/wordpress
if [ ! -f "wp-config.php" ]; then
    rm -rf *
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
fi

mkdir -p /run/php
exec /usr/sbin/php-fpm7.4 -F