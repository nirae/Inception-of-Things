#! /bin/bash

# Install utils and setup
sudo yum -y install vim tree net-tools telnet git python3
sudo echo "alias python=/usr/bin/python3" >> /home/vagrant/.bashrc
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Install K3S
sudo yum install -y http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/container-selinux-2.164.1-1.module_el8.5.0+870+f792de72.noarch.rpm
sudo curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode '0644' --flannel-iface 'eth1'" INSTALL_K3S_VERSION="v1.22.3+k3s1" sh -
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
echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc
echo "alias k=kubectl" >> /home/vagrant/.bashrc
echo "complete -F __start_kubectl k" >> /home/vagrant/.bashrc
# Get the token for the worker
cp /var/lib/rancher/k3s/server/node-token /vagrant/token
