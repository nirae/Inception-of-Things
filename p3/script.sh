# Install k3d
k3d cluster create my-cluster --api-port 6443 -p 8080:80@loadbalancer --agents 2
# Install kubectl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# argocd
kubectl create namespace argocd
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.1.6/manifests/install.yaml
kubectl apply -n argocd -f install.yaml
# ingress
kubectl apply -n argocd -f ingress.yaml

# Update password
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2y$12$Kg4H0rLL/RVrWUVhj6ykeO3Ei/YqbGaqp.jAtzzUSJdYWT6LUh/n6",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

# dev
kubectl create namespace dev
kubectl apply -f project.yml -n argocd
kubectl apply -f application.yml -n argocd
