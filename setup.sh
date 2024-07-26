#!/bin/bash

# update system
apt update
apt upgrade -y

# install make to execute makefile commands
apt install -y make

# install docker and docker-compose
curl -o docker.sh https://raw.githubusercontent.com/ManuelReschke/linux-helper/master/ubuntu/docker/install-update.sh
chmod +x docker.sh
sudo ./docker.sh

# download & unzip repo files
curl -o caddy-reverse-proxy.zip https://github.com/ManuelReschke/caddy-reverse-proxy/archive/refs/heads/main.zip
mkdir reverse
unzip caddy-reverse-proxy.zip -d reverse

# modify
echo "Modify your Caddyfile.prod.dist file!"
echo "Start your local reverse proxy with the command: make start"
echo "Start your prod reverse proxy with the command: make prod-start"