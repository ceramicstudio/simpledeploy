# k8s

The `base` directory contains the kubernetes manifests for the Ceramic HDS service. The `overlays` directory contains the manifests for different, example, configurations.

The manifests require secrets for a Postgres database and a Ceramic node private key.

An exampleof creating random secrets is in `create-secrets.sh`.

Overlays:
- overlays/ceramic-hds - an environment with an extra runner container and schemas to test historical data sync.

## local deployemnt of `base` using [kind](https://kind.sigs.k8s.io/)

Requires
  - [kind](https://kind.sigs.k8s.io/)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  - [docker](https://docs.docker.com/get-docker/)

To use ceramic prior to version 6:
```
kind create cluster --name ceramic
kubectl create ns ceramic
./k8s/base/composedb/create-secrets.sh
kubectl apply -k k8s/base/composedb/
```

To use ceramic version 6.x or above (using ceramic-one):
```
kind create cluster --name ceramic
cd ./k8s/base/ceramic-one
export CERAMIC_NAMESPACE=ceramic-one-0-17-0
kubectl create namespace ${CERAMIC_NAMESPACE}
./scripts/create-secrets.sh
kubectl apply -k .
```

View logs
```
kubectl logs composedb-0 -c composedb
```

Expose the service
```
kubectl port-forward svc/composedb 7007
```
