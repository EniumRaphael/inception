FROM alpine:3.21

RUN apk update
RUN apk add nginx openssl bash

RUN mkdir -p /run/nginx /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/generate_ssl_certificate.sh /usr/bin/generate_ssl_certificate

RUN chmod +x /usr/bin/generate_ssl_certificate

RUN /usr/bin/generate_ssl_certificate

USER nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
