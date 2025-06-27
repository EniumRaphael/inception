#!/bin/sh

sudo -u mysql -s /bin/sh -c mysqld &
PID=$!

mariadb-admin status --wait

mariadb -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
mariadb -e "FLUSH PRIVILEGES;"

sudo -u mysql -s /bin/sh -c "mysqladmin shutdown"
wait "$PID"

sed -i /etc/my.cnf.d/mariadb-server.cnf -e 's/^port=3307$/\0\nbind-address = 0.0.0.0/'
sed -i /etc/my.cnf.d/mariadb-server.cnf -e 's/^skip-networking$/;\0/'

exec sudo -u mysql -s /bin/sh -c mysqld
