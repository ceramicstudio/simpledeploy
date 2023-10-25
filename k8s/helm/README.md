# Helm

Helm chart for ceramic nodes. 

## Installation

`helm upgrade -i ceramic . -f values.yaml`

## Secrets

Secret management / encryption is left to the user. [sops](https://github.com/getsops/sops) and [helm secrets](https://github.com/jkroepke/helm-secrets) strongly recommended. 