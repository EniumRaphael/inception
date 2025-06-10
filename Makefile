# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sben-tay <sben-tay@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/05/02 15:40:00 by rparodi           #+#    #+#              #
#    Updated: 2025/06/10 13:40:37 by rparodi          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


# Name
NAME = ircserv

# Commands
CXX = c++
RM = rm -rf

# Flags
#  Mandatory flags for 42
CXXFLAGS = -Werror -Wextra -Wall -std=c++98
SESSION = test-irc

# Sources
SRC =	sources/channel/channel.cpp \
		sources/commands/cap.cpp \
		sources/commands/commands.cpp \
		sources/commands/invite.cpp \
		sources/commands/join.cpp \
		sources/commands/kick.cpp \
		sources/commands/list.cpp \
		sources/commands/modes.cpp \
		sources/commands/nick.cpp \
		sources/commands/notice.cpp \
		sources/commands/part.cpp \
		sources/commands/pass.cpp \
		sources/commands/ping.cpp \
		sources/commands/pong.cpp \
		sources/commands/privmsg.cpp \
		sources/commands/userCmd.cpp \
		sources/core/PollManager.cpp \
		sources/core/Server.cpp \
		sources/core/check.cpp \
		sources/core/main.cpp \
		sources/core/parser.cpp \
		sources/user/user.cpp

INC_DIR =	include/core \
			include/commands \
			include

CPPFLAGS = $(addprefix -I, $(INC_DIR)) -MMD -MP

# Objects
OBJDIRNAME = ./build
OBJ = $(addprefix $(OBJDIRNAME)/,$(SRC:.cpp=.o))

# Colors
GREEN = \033[32m
GREY = \033[0;90m
RED = \033[0;31m
GOLD = \033[38;5;220m
END = \033[0m

# Rules

# All (make all)
all: header $(NAME) footer

# Clean (make clean)
clean:
	@printf '$(GREY) Removing $(END)$(RED)Objects$(END)\n'
	@printf '$(GREY) Removing $(END)$(RED)Objects Folder$(END)\n'
	@$(RM) $(OBJDIRNAME)

# Clean (make fclean)
fclean: clean
	@printf '$(GREY) Removing $(END)$(RED)Program$(END)\n'
	@$(RM) $(NAME) @echo ""

# Restart (make re)
re: header fclean all

# Dependences for all
$(NAME): $(OBJ)
	@mkdir -p $(OBJDIRNAME)
	@printf '$(GREY) Creating $(END)$(GREEN)$(OBJDIRNAME)$(END)\n'
	@$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $(NAME) $(OBJ) #-fuse-ld=lld

# Creating the objects
$(OBJDIRNAME)/%.o: %.cpp
	@mkdir -p $(dir $@)
	@printf '$(GREY) Compiling $(END)$(GREEN)$<$(END)\n'
	@$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ -c $<

debug: CPPFLAGS += -D DEBUG=1
debug: CXXFLAGS += -g
# debug: CXXFLAGS += -fsanitize=address
debug: re

PORT ?= 4243

test: debug
	@printf '$(GREY) now running with\n\t- Port:\t\t$(GREEN)$(PORT)$(GREY)\n\t- Password:\t$(GREEN)irc$(END)\n'
	@if tmux has-session -t $(SESSION) 2>/dev/null; then \
		tmux kill-session -t $(SESSION); \
	fi
	@tmux new-session -d -s $(SESSION) \
		'bash -lc "./$(NAME) $(PORT) irc; exec bash"'
	@tmux split-window -h -p 70 -t $(SESSION):0 \
		'bash -lc "irssi -c localhost -p $(PORT) -w irc || exec yes \"irssi exit code: $?\""'
	@tmux split-window -v -p 50 -t $(SESSION):0.1 \
		'bash -lc "nc localhost $(PORT) || exec yes \"netcat exit code: $?\""'
	@tmux split-window -v -p 50 -t $(SESSION):0.2 \
		'bash -lc "nc localhost $(PORT) || exec yes \"netcat exit code: $?\""'
	@tmux split-window -v -p 50 -t $(SESSION):0.3 \
		'bash -lc "nc localhost $(PORT) || exec yes \"netcat exit code: $?\""'
	@tmux attach -t $(SESSION)

run: all
	@printf '$(GREY) now running with\n\t- Port:\t\t$(GREEN)$(PORT)$(GREY)\n\t- Password:\t$(GREEN)irc$(END)\n'
	@if tmux has-session -t $(SESSION) 2>/dev/null; then \
		tmux kill-session -t $(SESSION); \
	fi
	@tmux new-session -d -s $(SESSION) \
		'bash -lc "./$(NAME) $(PORT) irc; exec bash"'
	@tmux split-window -h -p 70 -t $(SESSION):0 \
		'bash -lc "irssi -c localhost -p $(PORT) -w irc || exec yes \"irssi exit code: $?\""'
	@tmux split-window -v -p 50 -t $(SESSION):0.1 \
		'bash -lc "nc localhost $(PORT) || exec yes \"netcat exit code: $?\""'
	@tmux attach -t $(SESSION)


#	Header
header:
		@clear
		@printf '\n\n'
		@printf '$(GOLD)            *******     ****** ******* $(END)\n'
		@printf '$(GOLD)          ******        ***    ******* $(END)\n'
		@printf '$(GOLD)      *******           *      ******* $(END)\n'
		@printf '$(GOLD)     ******                  ******* $(END)\n'
		@printf '$(GOLD)  *******                  ******* $(END)\n'
		@printf '$(GOLD) *******************    *******      * $(END)\n'
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
		@printf '              $(GREY)The compilation is$(END) $(GOLD)finished$(END)\n               $(GREY)Have a good $(END)$(GOLD)evaluation !$(END)\n'

clangd:
	@printf "CompileFlags:\n" > ./.clangd
	@printf "  Add:\n" >> ./.clangd
	@printf "    - \"-xc++\"\n" >> ./.clangd
	@for FLAG in $(CXXFLAGS); do \
		printf "    - \"$$FLAG\"\n" >> ./.clangd; \
	done
	@printf "    - \"-I"$(shell pwd)"/\"\n" >> .clangd;
	@for file in $(INC_DIR); do \
		printf "    - \"-I"$(shell pwd)"/"$$file"\"\n" >> .clangd; \
	done
	@printf "\n" >> ./.clangd
	@printf '$(GREY) Now parsing settings is set in $(END)$(GREEN)./.clangd$(END)\n'

#	Phony
.PHONY: all clean fclean re clangd debug test
-include	${OBJ:.o=.d}
