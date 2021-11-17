#! /bin/bash

# Install utils and setup
sudo yum -y install vim tree net-tools telnet git python3
sudo echo "alias python=/usr/bin/python3" >> /home/vagrant/.bashrc
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

TOKEN=`cat /vagrant/token`
echo "TOKEN : " $TOKEN
# Install K3S
sudo yum install -y http://mirror.centos.org/centos/8-stream/AppStream/aarch64/os/Packages/container-selinux-2.164.1-1.module_el8.5.0+870+f792de72.noarch.rpm
sudo curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.22.3+k3s1" INSTALL_K3S_EXEC="agent --flannel-iface 'eth1'" K3S_TOKEN=$TOKEN K3S_URL=https://192.168.42.110:6443 sh -
