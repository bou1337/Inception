# Use a suitable Debian base image
FROM debian:bullseye

# Set the working directory for subsequent commands
WORKDIR /var/www/html

# Install necessary packages and configure PHP-FPM
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    php7.4 php-fpm php-mysql mariadb-client wget ca-certificates && \
    # Download and install WP-CLI
    wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && \
    # Configure php-fpm to listen on port 9000 for the Nginx upstream
    sed -i "s|listen = /run/php/php7.4-fpm.sock|listen = 9000|" /etc/php/7.4/fpm/pool.d/www.conf && \
    # Clean up cache
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the setup script and ensure it's executable
# Note: The 'exec format error' happens here if the line endings are CRLF
COPY conf/setup.sh /tmp/
RUN chmod +x /tmp/setup.sh

# Expose the PHP-FPM port 
EXPOSE 9000

# Set the entrypoint to the setup script
ENTRYPOINT ["/tmp/setup.sh"]