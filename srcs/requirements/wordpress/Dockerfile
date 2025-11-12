FROM debian:latest

WORKDIR /var/www/html

RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget mariadb-client && \
    wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && \
    sed -i "s|listen = /run/php/php.*-fpm.sock|listen = 9000|" /etc/php/*/fpm/pool.d/www.conf

COPY conf/setup.sh /tmp
RUN chmod +x /tmp/setup.sh

ENTRYPOINT ["/tmp/setup.sh"]
