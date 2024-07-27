#!/bin/bash

# update system
apt update
apt upgrade -y

# install make to execute makefile commands
apt install -y make unzip

# install docker and docker-compose
curl -o docker.sh https://raw.githubusercontent.com/ManuelReschke/linux-helper/master/ubuntu/docker/install-update.sh
chmod +x docker.sh
sudo ./docker.sh

# download & unzip repo files
curl -L -o caddy-reverse-proxy.zip https://github.com/ManuelReschke/caddy-reverse-proxy/archive/refs/heads/main.zip
mkdir reverse
unzip caddy-reverse-proxy.zip
mv caddy-reverse-proxy-main/* reverse/
rm -r caddy-reverse-proxy-main/
rm caddy-reverse-proxy.zip docker.sh

echo "
######################################
Successfully prepared!
######################################"
echo "Modify your Caddyfile.prod.dist file!"
echo "Start your local reverse proxy with the command: make start"
echo "Start your prod reverse proxy with the command: make prod-start"