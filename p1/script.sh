# K3S
# Install containers utils
yum install -y container-selinux selinux-policy-base
# 
# rpm -i https://rpm.rancher.io/k3s-selinux-0.1.1-rc1.el7.noarch.rpm
# Install K3S
curl -sfL https://get.k3s.io | sh -
# use eth1 flannel

# Add line to /etc/systemd/system/k3s.service at the end
# sudo sed '/    server \/a     --flannel-iface "eth1"' /etc/systemd/system/k3s.service
vim /etc/systemd/system/k3s.service
# Reload systemd and restart service
sudo systemctl daemon-reload
sudo systemctl restart k3s
# Add kubernetes repo
cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
# Install kubectl
yum install -y kubectl
# Change permissions to k3s conf
chmod 644 /etc/rancher/k3s/k3s.yaml



# kubectl get nodes (-o wide (pour l'ip))
# kubectl get pods (--all-namespaces)

#K3SW
# install k3s | with master ip and token
# Get master token :
#         cat /var/lib/rancher/k3s/server/node-token
curl -sfL https://get.k3s.io | K3S_TOKEN=<ip> K3S_URL=https://192.168.42.100:6443 sh -
# Use eth1 flannel
sudo vim /etc/systemd/system/k3s-agent.service
ExecStart=/usr/local/bin/k3s \
    agent \
    --flannel-iface 'eth1'

