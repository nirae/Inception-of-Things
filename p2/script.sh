# K3S
# Install containers utils
# yum install -y container-selinux selinux-policy-base
# 
# rpm -i https://rpm.rancher.io/k3s-selinux-0.1.1-rc1.el7.noarch.rpm
# Install K3S
curl -sfL https://get.k3s.io | sh -
# use eth1 flannel

# Install docker
# sudo yum install -y yum-utils
# sudo yum-config-manager \
#     --add-repo \
#     https://download.docker.com/linux/centos/docker-ce.repo
# sudo yum install -y docker-ce docker-ce-cli containerd.io

# Add line to /etc/systemd/system/k3s.service at the end
# sudo sed '/    server \/a     --flannel-iface "eth1"' /etc/systemd/system/k3s.service
vim /etc/systemd/system/k3s.service
# Reload systemd and restart service
sudo systemctl daemon-reload && systemctl restart k3s
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

# appliquer les fichiers
cd /vagrant/conf
kubectl apply -f .

# change to 8.8.8.8
vim /etc/resolv.conf

# kubectl get nodes (-o wide (pour l'ip))
# kubectl get pods (--all-namespaces)
# kubectl get all -n kube-system
# kubectl get ingress

# kubectl delete deploy --all
# kubectl delete svc --all
# kubectl delete ingress --all
