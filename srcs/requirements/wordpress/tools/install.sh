#!/bin/sh

cd /var/www/html

mariadb-admin --host=mariadb --port=3306 --user="$DB_USER" --password="$DB_PASS" --wait status

if ! [ -f wp-load.php ]; then
	wp core download --locale=fr_FR --allow-root --path=/var/www/html
fi

if ! [ -f wp-config.php ]; then
	wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --skip-check --path=/var/www/html --allow-root
	wp core install --url=$DOMAIN --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_PASS_ADMIN --admin_email=$WP_MAIL_ADMIN --skip-email --path=/var/www/html --allow-root
fi

chown wordpress:wordpress -R /var/www/html
chmod -R +rw /var/www/html

exec php-fpm --nodeamonize
