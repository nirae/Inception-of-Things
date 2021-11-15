#! /bin/bash

USER=osboxes

sudo apt install -y curl vim

# Install Docker
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

if ! test -f /etc/apt/sources.list.d/docker.list
then
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
# Install k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "Reboot the VM !"
