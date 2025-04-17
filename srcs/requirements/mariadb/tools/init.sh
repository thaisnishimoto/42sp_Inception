#!/bin/sh

service mariadb start

# Wait until the server is ready
until mariadb -u root -e "SELECT 1;" &> /dev/null; do
    echo "Waiting for MariaDB to be ready..."
    sleep 1
done

mariadb -u root -e "CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME}; \
CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}'; \
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%'; \
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; \
FLUSH PRIVILEGES;"