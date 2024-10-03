# Configuring Domain Name and Automatic SSL Cert for Your ComposeDB Node

## Prerequisites
- A Kubernetes cluster (e.g., on DigitalOcean)
- `kubectl` configured to interact with your cluster
- A domain name pointed to your cluster's IP address

## Setup Steps

### 1. Remove the default load balancer
Replace the existing load balancer with an ingress controller:  
(this step assumes a digital ocean load balancer, adjust for your configuration)

```bash
kubectl delete -f k8s/base/composedb/do-lb.yaml
```

### 2. Install the NGINX Ingress Controller
If not already installed, add the NGINX ingress controller to your cluster:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/do/deploy.yaml
```

### 3. Install cert-manager
cert-manager will automatically manage and renew SSL certificates:

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml
```

### 4. Update Configuration Files
1. Edit `ingress.yaml`:
   - Replace `your-domain.com` with your actual domain name.
2. Edit `letsencrypt-issuer.yaml`:
   - Replace `your-email@example.com` with your actual email address.

### 5. Apply the Ingress and Related Services
From the repository root, run:

```bash
kubectl apply -k k8s/cert-ingress/
```

This will set up the ingress, ClusterIP service, and cert-manager configurations.

### 6. Verify the Setup
1. Check that the ingress has been created:
   ```bash
   kubectl get ingress -n ceramic
   ```
2. Verify that cert-manager has issued a certificate:
   ```bash
   kubectl get certificates -n ceramic
   ```
3. Once the certificate is ready, you should be able to access your ComposeDB node securely via HTTPS at your domain.

## Notes
- SSL certificates will be automatically obtained and renewed by cert-manager.
- If you need to make changes, modify the relevant files in the `k8s/cert-ingress/` directory and reapply using `kubectl apply -k k8s/cert-ingress/`.
- Ensure your domain's DNS is properly configured to point to your cluster's IP address.
