FROM alpine:3.21

RUN apk update && apk add mariadb mariadb-client bash

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

HEALTHCHECK --start-period=5m CMD mariadb -e 'SELECT @@datadir;' || exit 1

RUN mysql_install_db --user=$DB_USER --basedir=/usr --datadir=/var/lib/mysql

USER mysql

EXPOSE 3306

CMD ["mariadbd"]
