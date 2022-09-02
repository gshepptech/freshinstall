#! /bin/bash
# This file removes everything docker prior to install..
THIS_USER=$(whoami)
apt-get purge -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

rm -rf /var/lib/docker
rm -rf /var/lib/containerd


apt-get remove -y \
    docker \
    docker-engine \
    docker.io \
    containerd \
    runc \
    > /dev/null

apt-get update

apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    > /dev/null

mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    > /dev/null


groupadd -f docker

usermod -aG docker $USER

exec bash

systemctl enable docker.service
systemctl enable containerd.service

su $THIS_USER