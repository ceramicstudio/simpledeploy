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

```
kind create cluster --name ceramic
kubectl create ns ceramic
./k8s/base/composedb/create-secrets.sh
kubectl apply -k k8s/base/composedb/
```

View logs
```
kubectl logs composedb-0 -c composedb
```

Expose the service
```
kubectl port-forward svc/composedb 7007
```
