# ceramic-one k8s kustomization

This is a base directory for running kubernetes kustomize to build and deploy manifests for running ceramic-one.

## Quick start

Comands assume this directory as the current working directory.

### Create a namespace for the nodes.

```
export CERAMIC_NAMESPACE=ceramic-one
kubectl create namespace ${CERAMIC_NAMESPACE}
```

### Create ephemereal secrets for js-ceramic and postgres

```
./scripts/create-secrets.sh
```

### Apply the manifests

```
kubectl apply -k .
```

### Wait for the pods to start

```
kubectl wait --for=condition=ready pod -l app=js-ceramic --all --timeout=600s
```

# Limitations

- only deploys 2 nodes
- does not peer the nodes
