#!/bin/bash

set -e

exec > >(tee /var/log/deployx-user-data.log | logger -t deployx-user-data -s 2>/dev/console) 2>&1

echo "======================================"
echo "DeployX EC2 Setup Started"
echo "======================================"

# Update system
apt-get update -y

# Install required packages
apt-get install -y \
  ca-certificates \
  curl \
  git \
  unzip \
  jq \
  nginx

# Install Docker
curl -fsSL https://get.docker.com | sh

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Allow ubuntu user to use Docker
usermod -aG docker ubuntu

# Install Docker Compose plugin
apt-get install -y docker-compose-plugin

# Verify Docker
docker --version
docker compose version

# Create application directory
mkdir -p /opt/deployx
chown -R ubuntu:ubuntu /opt/deployx

# Clone GitLab repository
if [ -d "/opt/deployx/.git" ]; then

  echo "Repository already exists."
  echo "Pulling latest code..."

  cd /opt/deployx

  sudo -u ubuntu git fetch origin
  sudo -u ubuntu git checkout "${git_branch}"
  sudo -u ubuntu git pull origin "${git_branch}"

else

  echo "Cloning GitLab repository..."

  sudo -u ubuntu git clone \
    --branch "${git_branch}" \
    --single-branch \
    "${gitlab_repo}" \
    /opt/deployx

fi

# Go to application directory
cd /opt/deployx

echo "======================================"
echo "Repository Contents"
echo "======================================"

ls -la

# Check docker-compose file
if [ ! -f "docker-compose.yml" ]; then
  echo "ERROR: docker-compose.yml not found!"
  exit 1
fi

# Build and start containers
echo "======================================"
echo "Starting DeployX containers"
echo "======================================"

sudo -u ubuntu docker compose up -d --build

# Show containers
echo "======================================"
echo "Docker Containers"
echo "======================================"

docker ps

# Docker status
echo "======================================"
echo "Docker Service Status"
echo "======================================"

systemctl status docker --no-pager || true

echo "======================================"
echo "DeployX EC2 Setup Completed"
echo "======================================"