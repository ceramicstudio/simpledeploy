# Keramik

The `base` directory contains the kubernetes manifests for a Ceramic network.

The manifests require secrets for a Postgres database and a Ceramic node private key.

An example of creating random secrets is in `create-secrets.sh`.

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
./base/composedb/create-secrets.sh
kubectl apply -k ./base/ceramic/
```

View logs
```
kubectl logs ceramic-0 -c ceramic
```

## Change network size

The network size can be increase by changing the number of replicas for the ceramic statefulset.

