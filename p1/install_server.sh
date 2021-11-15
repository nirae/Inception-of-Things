#! /bin/bash

# Install utils and setup
sudo yum -y install vim tree net-tools telnet git python3
sudo echo "alias python=/usr/bin/python3" >> /home/vagrant/.bashrc
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Install K3S
sudo curl -sfL https://get.k3s.io | sh -
# Add flannel option to use eth1
if ! grep -q "eth1" /etc/systemd/system/k3s.service
then
    sed '/server \\/a\ \ \ \ --flannel-iface \"eth1\"' /etc/systemd/system/k3s.service | sudo tee /etc/systemd/system/k3s.service
    sudo systemctl daemon-reload
    sudo systemctl restart k3s
fi
# Add Kubernetes repo
if ! test -f /etc/yum.repos.d/kubernetes.repo
then
sudo cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
fi
# Install kubectl
sudo yum install -y kubectl
# Change permissions to k3s conf
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
# Get the token for the worker
cp /var/lib/rancher/k3s/server/node-token /vagrant/token
