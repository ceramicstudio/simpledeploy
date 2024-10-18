kubectl create secret generic ceramic-admin \
  --namespace ${CERAMIC_NAMESPACE} \
  --from-literal=admin-private-key=$(openssl rand -hex 32) \
  --from-literal=node-private-key=$(openssl rand -hex 32) \
  --from-literal=eth-rpc-urls=

kubectl create secret generic ceramic-postgres-auth \
  --namespace ${CERAMIC_NAMESPACE} \
  --from-literal=db=ceramic-mainnet \
  --from-literal=host=postgres \
  --from-literal=password=ceramic \
  --from-literal=username=ceramic
