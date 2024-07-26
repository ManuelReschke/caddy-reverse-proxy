build:
	sudo docker-compose build --no-cache
.PHONY: build

run:
	cp Caddyfile.local.dist Caddyfile
	sudo docker-compose up
.PHONY: run

start:
	cp Caddyfile.local.dist Caddyfile
	sudo docker-compose up -d
.PHONY: start

stop:
	sudo docker-compose stop
.PHONY: stop

down:
	sudo docker-compose down
.PHONY: down

restart: stop start
.PHONY: restart

prod-build:
	cp Caddyfile.prod.dist Caddyfile
	sudo docker-compose -f docker-compose.prod.yml build --no-cache
.PHONY: prod-build

prod-start:
	cp Caddyfile.prod.dist Caddyfile
	sudo docker-compose -f docker-compose.prod.yml up -d
.PHONY: prod-start

prod-stop:
	sudo docker-compose -f docker-compose.prod.yml stop
.PHONY: prod-stop

prod-restart: prod-stop prod-start
.PHONY: prod-restart