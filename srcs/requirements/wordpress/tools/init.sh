#!/bin/bash

# Download WordPress and create the wp-config.php
if [ ! -f /var/www/html/wp-config.php ]; then
  wp core download --allow-root --path=/var/www/html

  wp config create --allow-root --path=/var/www/html \
    --dbname="$WP_DB_NAME" \
    --dbuser="$WP_DB_USER" \
    --dbpass="$WP_DB_PASSWORD" \
    --dbhost="$WP_DATABASE_HOST"
fi

# Wait for MariaDB to be ready
until wp db check --allow-root --path=/var/www/html; do
  echo "Waiting for MariaDB to be ready..."
  sleep 1
done

# WordPress initial setup - Creates the WordPress tables in the database
wp core install --allow-root --path=/var/www/html \
  --url="$DOMAIN_NAME" \
  --title="Inception" \
  --admin_user="$WP_ADMIN_USER" \
  --admin_password="$WP_ADMIN_PASSWORD" \
  --admin_email="$WP_ADMIN_EMAIL" \
  --skip-email

wp user create --allow-root --path=/var/www/html \
  "$WP_USER" \
  "$WP_USER_EMAIL" \
  --user_pass="$WP_USER_PASSWORD" \
  --role=author

wp theme install twentyseventeen --allow-root --path=/var/www/html --activate

exec php-fpm7.4 -F