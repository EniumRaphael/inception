#!/usr/bin/env bash

GREEN = \033[32m
GREY = \033[0;90m
RED = \033[0;31m
GOLD = \033[38;5;220m
END = \033[0m

if [ ! -f "$CERT_DIR/nginx.key" ]; then
	@printf '$GREYGenerating the ssl$GREEN Certificate$END\n';
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=FR/ST=Paris/L=42/O=Students/OU=Inception/CN=rparodi.42.fr"
else
	@printf '$GREYGenerating the ssl certificate$RED already exist$END\n';
fi
