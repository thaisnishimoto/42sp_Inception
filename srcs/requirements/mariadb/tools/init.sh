#!/bin/sh

service mariadb start
until mariadb -e "SELECT 1" 2>/dev/null
do
	sleep 1
done

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
mariadb -u root -e "CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME}; \
CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}'; \
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%'; \
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; \
FLUSH PRIVILEGES;"

else
    echo "Database already initialized, skipping setup."

fi

service mariadb stop