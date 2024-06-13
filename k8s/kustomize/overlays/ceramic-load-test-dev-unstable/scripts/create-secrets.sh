kubectl create secret generic postgres-auth \
  --namespace ceramic-load-test-dev-unstable \
  --from-literal=username=ceramic --from-literal=password=$(openssl rand -hex 20)
kubectl create secret generic ceramic-admin \
  --namespace ceramic-load-test-dev-unstable \
  --from-literal=private-key=$(openssl rand -hex 32)
