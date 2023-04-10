kubectl create secret generic postgres-auth \
  --namespace ceramic-anchor-service \
  --from-literal=DB_PASSWORD=$(openssl rand -hex 20)
# Need these env vars to be set in the environment
kubectl create secret generic cas-auth \
  --namespace ceramic-anchor-service \
  --from-literal=ETH_WALLET_PK=$ETH_WALLET_PK \
  --from-literal=CONTRACT_ADDRESS=$CONTRACT_ADDRESS \
  --from-literal=ETH_RPC_URL=$ETH_RPC_URL
