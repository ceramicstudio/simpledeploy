kubectl create secret generic postgres-auth \
  --namespace ceramic-hds \
  --from-literal=username=ceramic --from-literal=password=$(openssl rand -hex 20)
#kubectl create secret generic ceramic-admin --from-literal=private-key=$(openssl rand -hex 32)
kubectl create secret generic ceramic-admin \
  --namespace ceramic-hds \
  --from-literal=private-key=571f09cfb204e83e5d7e2f0430a6ca0aadea59f392d4b59ef411050680e3aaf3 \
  --from-literal=did="did:key:z6MkqA7CpACixDA4mH8Snix2kMEkmGp8YBX8uBKhni5UZzCD"
