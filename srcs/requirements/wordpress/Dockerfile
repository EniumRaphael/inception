FROM alpine:3.21

RUN apk update && apk add php82-curl php82-gd php82-mbstring php82-session php82-opcache php82-zlib bash wget php82 php82-phar php82-mysqli php82-fpm mariadb-client;

# RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz

RUN mkdir -p /var/www/html;

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /bin/wp-cli.phar;
RUN chmod +x /bin/wp-cli.phar;
RUN mv /bin/wp-cli.phar /bin/wp;

RUN ln -s /usr/bin/php82 /usr/bin/php;
RUN ln -s /usr/sbin/php-fpm82 /usr/sbin/php-fpm;

RUN adduser -D wordpress -g wordpress;
RUN chown wordpress:wordpress -R /var/www/html;
RUN chmod -R +rw /var/www/html;
RUN chmod -R +rw /var/log/php82/;

COPY tools/install.sh /usr/bin/install-wp
RUN chmod +x /usr/bin/install-wp;

COPY ./conf/php-fpm.conf /etc/php82/php-fpm.d/www.conf
RUN sed -i 's/^memory_limit\s*=.*/memory_limit = 1024M/' /etc/php82/php.ini;
USER wordpress

CMD ["install-wp"]
