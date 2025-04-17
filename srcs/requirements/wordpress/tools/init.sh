#!/bin/bash

# Download WordPress and create the wp-config.php
if [ ! -f /var/www/html/wp-config.php ]; then
  wp core download --allow-root --path=/var/www/html

  wp config create \
    --allow-root \
    --path=/var/www/html \
    --dbname="$WP_DB_NAME" \
    --dbuser="$WP_DB_USER" \
    --dbpass="$WP_DB_PASSWORD" \
    --dbhost=mariadb
fi

# Wait for MariaDB to be ready
until wp db check --allow-root --path=/var/www/html; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done

# WordPress initial setup
if [ ! -f /var/www/html/wp-config.php ]; then
  wp core install \
    --allow-root \
    --path=/var/www/html \
    --url="$DOMAIN_NAME" \
    --title="Inception" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL"
fi

exec php-fpm7.4 -F