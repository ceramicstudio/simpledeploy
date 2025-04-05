# ceramic-one-mainnet

This overlay configures the `ceramic-one` deployment to connect to the Ceramic mainnet network.

## Step 1: Create a namespace

The example kustomization uses namespace `ceramic-one-mainnet`.

Update the namespace in the kustomization file to your desired namespace.

Create the namespace with the following command:

```
export CERAMIC_NAMESPACE=ceramic-one-mainnet
kubectl create namespace ${CERAMIC_NAMESPACE}
```

## Step 2: Create secrets

The k8s manifests require 2 secrets to be set up before deploying.

### ceramic-admin

This secret contains the following 3 keys:

#### eth-rpc-urls

This should be a valid Ethereum mainnetRPC URL that the Ceramic node can use to connect to the Ethereum network.

#### node-private-key

A private key for the Ceramic node to authenticate with CAS.

If you don't already have a private key, you can generate one with `openssl rand -hex 32`.

From this key, a DID will be derived. Use the `composedb did:from-private-key` command to derive a DID from the private key.

Use this DID to register with CAS as documented https://developers.ceramic.network/docs/composedb/guides/composedb-server/access-mainnet

#### admin-private-key

A private key for the Admin DID to use the deployed Ceramic API.

If you don't already have a private key, you can generate one with `openssl rand -hex 32`.

#### Create the ceramic-admin secret
Create the secret with the following command (as example):

```
kubectl create secret generic ceramic-admin \
  --namespace ${CERAMIC_NAMESPACE} \
  --from-literal=admin-private-key=$(openssl rand -hex 32) \
  --from-literal=node-private-key=$(openssl rand -hex 32) \
  --from-literal=eth-rpc-urls=<mainnet-rpc-url>
```

### ceramic-postgres-auth

This example deployment also deploys a postgres instance with a database for the Ceramic node to use.

#### Create the ceramic-postgres-auth secret

Create the secret with the following command (as example):

```
kubectl create secret generic ceramic-postgres-auth \
  --namespace ${CERAMIC_NAMESPACE} \
  --from-literal=db=ceramic-mainnet \
  --from-literal=host=postgres \
  --from-literal=password=ceramic \
  --from-literal=username=ceramic
```

## Step 3: Deploy

From this directory, apply the kustomization:

```
kubectl apply -k .
```
