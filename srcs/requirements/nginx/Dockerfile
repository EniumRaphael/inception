FROM alpine:3.21

RUN apk update
RUN apk add nginx openssl bash

RUN mkdir -p /run/nginx /etc/nginx/ssl

RUN rm -rf /var/www/html;
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/generate_ssl_certificate.sh /usr/bin/generate_ssl_certificate

RUN chmod +x /usr/bin/generate_ssl_certificate

EXPOSE 443

CMD ["generate_ssl_certificate"]
