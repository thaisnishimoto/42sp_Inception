COMPOSE_FILE=./srcs/docker-compose.yml

all: setup up

setup:
	grep "tmina-ni.42.fr" /etc/hosts || echo "127.0.0.1 tmina-ni.42.fr" | sudo tee --append /etc/hosts > /dev/null
	sudo mkdir -p /home/tmina-ni/data/wp_database
	sudo mkdir -p /home/tmina-ni/data/wp_files

up:
	docker compose -f $(COMPOSE_FILE) up --build -d

down:
	docker compose -f $(COMPOSE_FILE) down --rmi all -v

up-nc:
	docker compose -f $(COMPOSE_FILE) build --no-cache
	docker compose -f $(COMPOSE_FILE) up -d 

exec:
	docker compose -f $(COMPOSE_FILE) exec $(SERV) bash

logs:
	docker compose -f $(COMPOSE_FILE) logs $(SERV) --tail=50

follow-logs:
	docker compose -f $(COMPOSE_FILE) logs -f $(SERV)

rmi:
	docker rmi $$(docker image ls -qa) --force

prune:
	docker system prune -a -f

clean:
	down
	sudo rm -rf /home/tmina-ni/data/

fclean:
	clean
	docker compose down --remove-orphans 
	rmi
	prune

re: clean all 

.PHONY: all setup up down up-nc exec logs follow-logs rmi prune clean fclean re 