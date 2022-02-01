PULL_SECRET=$(cat ~/Downloads/pull-secret.txt)
PUBLIC_SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

sed "s#replace-with-pull-secret#$PULL_SECRET#" pull-secret.yaml.in > pull-secret.yaml
sed "s#replace-with-public-ssh-key#$PUBLIC_SSH_KEY#" agent-cluster-install.yaml.in > agent-cluster-install.yaml
sed "s#replace-with-public-ssh-key#$PUBLIC_SSH_KEY#" infraenv.yaml.in > infraenv.yaml

kubectl apply -f namespace.yaml
kubectl apply -f pull-secret.yaml
kubectl apply -f cluster-image-set.yaml
kubectl apply -f cluster-deployment.yaml
kubectl apply -f infrastructure-operator-install-manifests.yaml
kubectl apply -f agent-cluster-install.yaml
kubectl apply -f infraenv.yaml