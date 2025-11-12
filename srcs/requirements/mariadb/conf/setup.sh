#!/bin/bash

set -euo pipefail
trap "exit" TERM

# Initialize database directory if it's empty/missing
if [ ! -d "/var/lib/mysql/mysql" ]; then
    if command -v mysql_install_db >/dev/null 2>&1; then
        mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null 2>&1
    elif command -v mariadb-install-db >/dev/null 2>&1; then
        mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null 2>&1
    else
        echo "Warning: no mysql_install_db or mariadb-install-db found, attempting mysqld --initialize-insecure"
        mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1 || true
    fi
    sleep 3
fi

service mariadb start
sleep 2

# Only run SQL user/database creation when required environment variables are set
if [ -n "${SQL_DATABASE:-}" ] && [ -n "${SQL_USER:-}" ] && [ -n "${SQL_PASSWORD:-}" ]; then
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
    mysql -e "FLUSH PRIVILEGES;"
else
    # mask password when printing
    pw_summary="${SQL_PASSWORD:+***set***}"
    echo "One or more required env vars are missing or empty. Skipping DB creation."
    echo "SQL_DATABASE='${SQL_DATABASE:-}' SQL_USER='${SQL_USER:-}' SQL_PASSWORD='${pw_summary}'"
fi

service mariadb stop

exec mysqld
