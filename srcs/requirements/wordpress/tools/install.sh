#!/bin/sh
set -xe
mysqladmin --host=mariadb --port=3306 --user="$DB_USER" --password="$DB_PASSWORD" --wait status

if ! [ -e /var/www/html/wp-config.php ]; then
	wp core download --locale=fr_FR --allow-root --path=/var/www/html
	wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --skip-check --path=/var/www/html --allow-root
	wp core install --url=$DOMAIN --title="$WP_TITLE" --admin_user=$WP_ADMIN --admin_password=$WP_PASS_ADMIN --admin_email=$WP_MAIL_ADMIN --path=/var/www/html --allow-root
	wp user create "$WP_USER" "$WP_MAIL" --user_pass="$WP_PASS" --role=editor --path=/var/www/html
fi

exec php-fpm -F
