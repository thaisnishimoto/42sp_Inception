COMPOSE_FILE = ./srcs/docker-compose.yml
DOCKER_COMPOSE_COMMAND = docker-compose -f $(COMPOSE_FILE)

all: setup up

setup:
	grep "tmina-ni.42.fr" /etc/hosts || echo "127.0.0.1 tmina-ni.42.fr" | sudo tee --append /etc/hosts > /dev/null
	sudo mkdir -p /home/tmina-ni/data/wp_database
	sudo mkdir -p /home/tmina-ni/data/wp_files
	@if [ ! -f ./srcs/.env ]; then \
		echo "Creating .env from .env.example..."; \
		cp ./srcs/.env.example ./srcs/.env; \
	fi

up:
	$(DOCKER_COMPOSE_COMMAND) up --build -d

down:
	$(DOCKER_COMPOSE_COMMAND) down --rmi all -v --remove-orphans

up-nc:
	$(DOCKER_COMPOSE_COMMAND) build --no-cache
	$(DOCKER_COMPOSE_COMMAND) up -d 

exec:
	$(DOCKER_COMPOSE_COMMAND) exec $(SERV) bash

logs:
	$(DOCKER_COMPOSE_COMMAND) logs $(SERV) --tail=50

follow-logs:
	$(DOCKER_COMPOSE_COMMAND) logs -f $(SERV)

rmi:
	@if [ -n "$$(docker image ls -qa)" ]; then \
		docker rmi $$(docker image ls -qa) --force; \
	else \
		echo "No images to remove."; \
	fi

prune:
	docker system prune -a -f

clean: down
	sudo rm -rf /home/tmina-ni/data/

fclean: clean rmi prune

re: clean all 

.PHONY: all setup up down up-nc exec logs follow-logs rmi prune clean fclean re 