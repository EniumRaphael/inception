FROM alpine:3.21

RUN apk update && apk add sudo mariadb mariadb-client bash;

RUN mkdir -p /var/lib/mysqld;
RUN mkdir -p /run/mysqld;
RUN chown -R mysql:mysql /run/mysqld;
RUN chown -R mysql:mysql /var/lib/mysqld;

EXPOSE 3306

RUN /usr/bin/mysql_install_db --user=mysql --datadir=/var/lib/mysql;

COPY tools/start_db.sh /usr/bin/start_db
RUN chmod +x /usr/bin/start_db;

CMD ["start_db"]
