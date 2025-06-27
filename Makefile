# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rparodi <rparodi@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/12 18:09:23 by rparodi           #+#    #+#              #
#    Updated: 2025/06/27 17:23:54 by rparodi          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SECRET = $(HOME)/secrets

MAIN = $(shell pwd)/srcs

BASE_CONTAINERS = $(MAIN)/requirements
NGINX = $(BASE_CONTAINERS)/nginx
MARIADB = $(BASE_CONTAINERS)/mariadb
WORDPRESS = $(BASE_CONTAINERS)/wordpress

#Setup
PACK_MAN = pacman -Syu --noconfirm

# Colors
GREEN = \033[32m
GREY = \033[0;90m
RED = \033[0;31m
GOLD = \033[38;5;220m
END = \033[0m

all: header get_secret build footer

build:
	docker compose -f $(MAIN)/docker-compose.yml up --build -d

stop: header
	@docker compose -f $(MAIN)/docker-compose.yml stop
	@if [ $(shell docker ps -q | wc -l) -ne 0 ]; then \
		docker stop $(shell docker ps -q); \
	fi
	@printf '$(GREY)Stopping all the $(RED)Containers$(END)\n';

nginx:
	@if docker image inspect nginx-test:latest > /dev/null 2>&1; then \
		printf '$(GREY)Suppressing the image named: $(RED)nginx-test$(END)\n'; \
		docker rmi nginx-test:latest; \
	fi
	@printf '$(GREY)Build the container $(GREEN)nginx$(END)\n'; \
	docker build -t nginx-test $(NGINX)

mariadb:
	@if docker image inspect mariadb-test:latest > /dev/null 2>&1; then \
		printf '$(GREY)Suppressing the image named: $(RED)mariadb-test$(END)\n'; \
		docker rmi mariadb-test:latest; \
	fi
	@printf '$(GREY)Build the container $(GREEN)mariadb$(END)\n'; \
	docker build -t mariadb-test $(MARIADB)

wordpress:
	@if docker image inspect wordpress-test:latest > /dev/null 2>&1; then \
		printf '$(GREY)Suppressing the image named: $(RED)wordpress-test$(END)\n'; \
		docker rmi wordpress-test:latest; \
	fi
	@printf '$(GREY)Build the container $(GREEN)wordpress$(END)\n'; \
	docker build -t wordpress-test $(WORDPRESS)

get_secret:

#@if [ ! -d $(SECRET) ]; then \
#	printf "$(RED)The secrets home folder doesn't exist$(END)\n"; \
#	exit 1; \
#elif [ ! -d $(shell pwd)/secrets ]; then \
#	cp -r $(SECRET) $(shell pwd)/secrets; \
#	printf '$(GREY)Creating the folder $(GREEN)$(shell pwd)/secrets$(END)\n'; \
#else \
#	printf '$(GREY)The secrets is $(RED)already existing$(END)\n'; \
#fi

clean: stop
	@printf '$(GREY)Suppressing all the $(RED)Containers$(END)\n';
	@if [ $(shell docker ps -aq | wc -l) -ne 0 ]; then \
		docker rm -f $(shell docker ps -aq); \
	fi

fclean: clean
	docker image prune -f -a
	@printf '$(GREY)Suppressing all the $(RED)Images$(END)\n';
	docker volume prune -fa
	@printf '$(GREY)Suppressing all the $(RED)Volumes$(END)\n';
	docker system prune -f -a
	@printf '$(GREY)Suppressing all the $(RED)Network$(END)\n';

re: header fclean all footer

setup_vm: header
	@echo "127.0.0.1 rparodi.42.fr" | sudo tee -a /etc/hosts &> /dev/null
	@printf "$(GREY)Adding the custom host $(GREEN)rparodi.42.fr$(END)\n";
	@sudo $(PACK_MAN) docker docker-compose docker-buildx &> /dev/null
	@printf "$(GREY)Install the $(GREEN)docker docker-compose docker-buildx packages$(END)\n";
	@sudo usermod -aG docker $(shell whoami)
	@printf "$(GREY)User add to the $(GREEN)docker's group$(END)\n";
	@printf "$(GREY)Virtual Machine now $(GOLD)setuped$(END)\n";

setup: setup_vm

#	Header
header:
		@clear
		@printf '\n\n'
		@printf '$(GOLD)            *******     ****** ******* $(END)\n'
		@printf '$(GOLD)          ******        ***    ******* $(END)\n'
		@printf '$(GOLD)      *******           *      ******* $(END)\n'
		@printf '$(GOLD)     ******                  ******* $(END)\n'
		@printf '$(GOLD)  *******                  ******* $(END)\n'
		@printf '$(GOLD) *******************     ******      * $(END)\n'
		@printf '$(GOLD) *******************    *******    *** $(END)\n'
		@printf '$(GOLD)              ******    ******* ****** $(END)\n'
		@printf '$(GOLD)              ******  $(END)\n'
		@printf '$(GOLD)              ******  $(END)\n'
		@printf '$(GREY)                                      Made by rparodi$(END)\n\n'

#	Footer
footer:
		@printf "\n"
		@printf "$(GOLD)                   ,_     _,$(END)\n"
		@printf "$(GOLD)                   | \\___//|$(END)\n"
		@printf "$(GOLD)                   |=6   6=|$(END)\n"
		@printf "$(GOLD)                   \\=._Y_.=/$(END)\n"
		@printf "$(GOLD)                    )  \`  (    ,$(END)\n"
		@printf "$(GOLD)                   /       \\  (('$(END)\n"
		@printf "$(GOLD)                   |       |   ))$(END)\n"
		@printf "$(GOLD)                  /| |   | |\\_//$(END)\n"
		@printf "$(GOLD)                  \\| |._.| |/-\`$(END)\n"
		@printf "$(GOLD)                   '\"'   '\"'$(END)\n"
		@printf '              $(GREY)The build is $(GOLD)finished$(END)\n               $(GREY)Have a good $(GOLD)evaluation !$(END)\n'

#	Phony
.PHONY: all nginx mariadb wordpress get_secret clean fclean re setup setup_vm
