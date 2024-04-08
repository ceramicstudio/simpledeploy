kubectl create secret generic ceramic-admin \
  --from-literal=private-key=$(openssl rand -hex 32)
kubectl create secret generic ceramic-postgres-auth \
  --from-literal=db=ceramic \
  --from-literal=host=localhost \
  --from-literal=password=ceramic \
  --from-literal=username=ceramic
