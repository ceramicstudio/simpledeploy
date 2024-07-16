#!/bin/bash

set -eo pipefail

export MY_POD_INDEX=$(echo $MY_POD_NAME | grep -o '[0-9]\+$')
# Assuming http://ceramic-one-1:5001 format
export CERAMIC_IPFS_HOST=http://ceramic-one-${MY_POD_INDEX}:5001
export CERAMIC_ADMIN_DID=$(composedb did:from-private-key ${CERAMIC_ADMIN_PRIVATE_KEY})

CERAMIC_ADMIN_DID=$CERAMIC_ADMIN_DID envsubst < /js-ceramic-init/daemon-config.json > /config/daemon-config.json
