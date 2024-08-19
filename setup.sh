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

# interactive setup
env="local"
read -p "Choose your environment (local/prod) [default: local]: " input
if [ -n "$input" ]; then
  if [[ "$input" == "local" || "$input" == "prod" ]]; then
    env="$input"
  else
    echo "Invalid choice. The standard environment 'local' will be used."
  fi
fi

CADDYFILE_EXT=".$env.dist"
echo $CADDYFILE_EXT

echo "Please select one of the following base templates:"
echo "1) Local (localhost)"
echo "2) WordPress"
echo "3) WordPress (Cloudflare only)"
echo "4) Simple Website"
echo "5) Simple Website (Cloudflare only)"
echo "6) HTTPS"
echo "7) HTTPS (Cloudflare only)"
read -p "Your choice: " choice

case $choice in
  1) TEMPLATE_FILE="caddy/templates/local.dist";;
  2) TEMPLATE_FILE="caddy/templates/wordpress.dist";;
  3) TEMPLATE_FILE="caddy/templates/wordpress-cf.dist";;
  4) TEMPLATE_FILE="caddy/templates/simple.dist";;
  5) TEMPLATE_FILE="caddy/templates/simple-cf.dist";;
  6) TEMPLATE_FILE="caddy/templates/https-backend.dist";;
  7) TEMPLATE_FILE="caddy/templates/https-backend-cf.dist";;
  *) echo "Invalid choice. Script will be terminated."; exit 1;;
esac

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "File $TEMPLATE_FILE does not exist. Script will be terminated."
    exit 1
fi

cp $TEMPLATE_FILE "Caddyfile$CADDYFILE_EXT"

# IP
read -p "Enter the target IP address for your application server: " SERVER_IP
if [ -z "$SERVER_IP" ]; then
    echo "No IP entered. Script will be terminated."
    exit 1
fi
sed -i "s/\$IP/$SERVER_IP/g" Caddyfile$CADDYFILE_EXT
echo "sed-Befehl ausgeführt: $?"
echo "IP $SERVER_IP was successfully set to Caddyfile"

# DOMAIN
read -p "Enter the target domain name (e.g. example.com) (if you want localhost then let this empty): " DOMAIN_NAME
if [ -z "$DOMAIN_NAME" ]; then
    echo "Nothing entered. We use localhost as default."
    DOMAIN_NAME="localhost"
fi
sed -i "s/\$DOMAIN/$DOMAIN_NAME/g" Caddyfile$CADDYFILE_EXT
echo "Domain $DOMAIN_NAME was successfully set to Caddyfile"

# PORT
read -p "Enter the target port number (e.g. 8080): " PORT
if [ -z "$PORT" ]; then
    echo "Nothing entered. Script will be terminated."
    exit 1
fi
sed -i "s/\$PORT/$PORT/g" Caddyfile$CADDYFILE_EXT
echo "Port $PORT was successfully set to Caddyfile"

cp Caddyfile$CADDYFILE_EXT Caddyfile

echo "Please check and validate your Caddyfile before you use it!"
echo "Done"

echo "
######################################
Successfully prepared!
######################################"
echo "Modify your Caddyfile.prod.dist file!"
echo "Start your local reverse proxy with the command: make start"
echo "Start your prod reverse proxy with the command: make prod-start"