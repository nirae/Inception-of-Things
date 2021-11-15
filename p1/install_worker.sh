#! /bin/bash

# Install utils and setup
sudo yum -y install vim tree net-tools telnet git python3
sudo echo "alias python=/usr/bin/python3" >> /home/vagrant/.bashrc
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

TOKEN=`cat /vagrant/token`
echo "TOKEN : " $TOKEN
# Install K3S
sudo curl -sfL https://get.k3s.io | K3S_TOKEN=$TOKEN K3S_URL=https://192.168.42.110:6443 sh -
# Add flannel option to use eth1
if ! grep -q "eth1" /etc/systemd/system/k3s-agent.service
then
    sed '/agent \\/a\ \ \ \ --flannel-iface \"eth1\"' /etc/systemd/system/k3s-agent.service | sudo tee /etc/systemd/system/k3s-agent.service
    sudo systemctl daemon-reload
    sudo systemctl restart k3s-agent.service
fi
