#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing core utilities..."
sudo apt install -y curl wget git unzip htop build-essential software-properties-common

echo "Installing Nginx..."
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

echo "Setting up UFW firewall..."
sudo apt install -y ufw
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

echo "Installing Docker..."
sudo apt install -y ca-certificates gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

echo "Installing Python..."
sudo apt install -y python3 python3-pip python3-venv
pip3 install --upgrade pip

echo "Installing Node.js (LTS)..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

echo "Installing PM2..."
sudo npm install -g pm2

echo "Installing Certbot..."
sudo apt install -y certbot python3-certbot-nginx

echo "Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib

echo "Installing Python trading libraries..."
pip3 install pandas numpy matplotlib requests websocket-client

echo "Installing tmux..."
sudo apt install -y tmux net-tools

echo "Creating project directories..."
sudo mkdir -p /var/www/yoursite
sudo mkdir -p /opt/trading-bot

sudo chown -R $USER:$USER /var/www/yoursite
sudo chown -R $USER:$USER /opt/trading-bot

echo "Setup complete!"
echo "Please logout and login again for Docker group changes to apply."
