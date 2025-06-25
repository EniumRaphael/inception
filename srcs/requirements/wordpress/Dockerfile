FROM alpine:3.21

RUN apk update && apk add bash wget php82 php82-phar php82-mysqli php82-fpm mariadb-client

# RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz

RUN mkdir -p /var/www/html

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /bin/wp-cli.phar;
RUN chmod +x /bin/wp-cli.phar;
RUN mv /bin/wp-cli.phar /bin/wp;

RUN ln -s /usr/bin/php82 /usr/bin/php;
RUN ln -s /usr/sbin/php-fpm82 /usr/sbin/php-fpm;
RUN export PHP_OPTIONS="-d memory_limit=512M"

COPY tools/install.sh /usr/bin/install-wp

RUN chmod +x /usr/bin/install-wp

CMD ["install-wp", "php-fpm"]
