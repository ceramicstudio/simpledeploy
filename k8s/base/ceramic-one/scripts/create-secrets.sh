kubectl create secret generic ceramic-admin \
  --namespace ${CERAMIC_NAMESPACE} \
  --from-literal=private-key=$(openssl rand -hex 32)
kubectl create secret generic ceramic-postgres-auth \
  --namespace ${CERAMIC_NAMESPACE} \
  --from-literal=db=ceramic \
  --from-literal=host=postgres \
  --from-literal=password=ceramic \
  --from-literal=username=ceramic
