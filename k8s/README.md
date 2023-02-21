# k8s

## local (kind)

Requires
  - [kind](https://kind.sigs.k8s.io/)
  - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
  - [docker](https://docs.docker.com/get-docker/)

```
kind create cluster --name ceramic-hds-testing
kubectl create ns ceramic-hds
./k8s/create-secrets.sh
kubectl apply -k k8s/base/
```

View logs
```
kubectl logs composedb-0 -c composedb
```

Expose the service
```
kubectl port-forward svc/composedb 7007
```
