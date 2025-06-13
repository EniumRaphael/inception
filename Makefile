# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rparodi <rparodi@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/12 18:09:23 by rparodi           #+#    #+#              #
#    Updated: 2025/06/13 14:45:19 by rparodi          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SECRET = $(HOME)/secrets

MAIN = $(shell pwd)/srcs

BASE_CONTAINERS = $(MAIN)/requirements
NGINX = $(BASE_CONTAINERS)/nginx
MARIADB = $(BASE_CONTAINERS)/mariadb
WORDPRESS = $(BASE_CONTAINERS)/wordpress

#Setup
PACK_MAN = pacman -S

# Colors
GREEN = \033[32m
GREY = \033[0;90m
RED = \033[0;31m
GOLD = \033[38;5;220m
END = \033[0m

all: header get_secret build footer

build:
	docker compose -f $(MAIN)/docker-compose.yml up --build -d

stop:
	@docker compose -f $(MAIN)/docker-compose.yml down
	@if [ $(shell docker ps -q | wc -l) -ne 0 ]; then \
		docker stop $(docker ps -q); \
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
	@if [ ! -d $(SECRET) ]; then \
		printf "$(RED)The secrets home folder doesn't exist$(END)\n"; \
		exit 1; \
	elif [ ! -d $(shell pwd)/secrets ]; then \
		cp -r $(SECRET) $(shell pwd)/secrets; \
		printf '$(GREY)Creating the folder $(GREEN)$(shell pwd)/secrets$(END)\n'; \
	else \
		printf '$(GREY)The secrets is $(RED)already existing$(END)\n'; \
	fi

clean: stop
	@printf '$(GREY)Suppressing all the $(RED)Containers$(END)\n';
	@if [ $(shell docker ps -aq | wc -l) -ne 0 ]; then \
		docker rm -f $(shell docker ps -aq); \
	fi

fclean: clean
	@if [ $(shell docker images -aq | wc -l) -ne 0 ]; then \
		docker rmi -f $(shell docker images -aq); \
	fi
	@printf '$(GREY)Suppressing all the $(RED)Images$(END)\n';
	@if [ $(shell docker volume ls -q | wc -l) -ne 0 ]; then \
		docker volume rm $(shell docker volume ls -q); \
	fi
	@printf '$(GREY)Suppressing all the $(RED)Volumes$(END)\n';
	@if [ $(shell docker network ls | grep -v "bridge\|host\|none\|NETWORK" | awk '{print $1}' | wc -l) -ne 0 ]; then \
		docker network rm $(shell docker network ls | grep -v "bridge\|host\|none\|NETWORK" | awk '{print $1}'); \
	fi
	@printf '$(GREY)Suppressing all the $(RED)Network$(END)\n';

re: header fclean all footer

setup_vm:
	sudo $(PACK_MAN) docker docker-compose
	sudo usermod -aG docker $(shell whoami)
	@printf '$(GREY)Virtual Machine now$(GREEN)setuped$(END)\n'; \

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
.PHONY: all nginx mariadb wordpress get_secret clean fclean re
