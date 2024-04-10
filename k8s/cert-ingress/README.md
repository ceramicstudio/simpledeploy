## Configuring domain name and SSL cert for your composedb node

### Remove the default load balancer

We are going to replace the load balancer that was installed with an ingress controller and related services

`kubectl delete -f k8s/base/composedb/do-lb.yaml`

### Install an ingress controller

If you have not already done so, install the ingress controller to your cluster

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.0/deploy/static/provider/do/deploy.yaml`

### Apply the ingress and related services

The resources in this deployment may be deployed from the repository root like so

```
kubectl apply -k k8s/cert-ingress/
```

This will spin up the ingress and the static file server.  You may remove the static file server if it is not needed for your configuration.

### If you need to get a cert

You may need to return a challenge file.  In this case you will use the static server
that is included in this deployment, and configure its files like so

```
mkdir -p .well-known/acme-challenge
# place the challenge file in this directory, then
kubectl create configmap acme-challenge --from-file=.well-known/acme-challenge/ --namespace=ceramic
```
Follow the instructions from your cert provider to get your TLS certificate and private key.

Place them in files such as `fullchain.pem` and `privkey.pem`

Then run

```
kubectl create secret tls ceramic-tls-secret --cert=fullchain.pem --key=privkey.pem
```
