#!/bin/bash

# ##### Create the docker-compose.yml file
cat > /docker-compose.yml <<EOF
version: "3"

services:
  ontime:
    container_name: ontime
    image: getontime/ontime:latest
    ports:
      - "80:4001/tcp"
      - "8888:8888/udp"
      - "9999:9999/udp"
    volumes:
      - "./ontime-data:/data/"
    environment:
      - TZ=America/New_York
    restart: unless-stopped
EOF


# ##### Install Docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo newgrp docker


# ##### Install Docker Compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


# ##### Run Docker with OnTime
docker pull getontime/ontime
docker-compose up -d