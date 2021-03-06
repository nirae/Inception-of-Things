#! /bin/bash

# Create the K3D cluster
k3d cluster create iot-cluster --api-port 6443 -p 8080:80@loadbalancer --agents 2
# Create namespace for argocd
kubectl create namespace argocd
# Install argocd
kubectl apply -n argocd -f conf/install.yaml
kubectl apply -n argocd -f conf/ingress.yml
# Update password to admin
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$12$xqvbSAZa9Sx/aQsDeNZXielNfB2jhBD8jPmSDiZyUqdBSJgHRZtuq",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'
# Create namespace for dev
kubectl create namespace dev
# Deploy app to argocd
kubectl apply -f conf/project.yml -n argocd
kubectl apply -f conf/application.yml -n argocd
