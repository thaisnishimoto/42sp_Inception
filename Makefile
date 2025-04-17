all: up

up:
	docker compose up --build -d

down:
	docker compose down --rmi all -v