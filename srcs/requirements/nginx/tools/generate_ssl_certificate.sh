#!/usr/bin/env bash

if [ ! -f "$CERT_DIR/nginx.key" ]; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=FR/ST=Paris/L=42/O=Students/OU=Inception/CN=rparodi.42.fr"
fi

exec nginx
