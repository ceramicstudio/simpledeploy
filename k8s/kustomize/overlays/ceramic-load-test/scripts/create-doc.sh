#!/bin/bash

set -exo pipefail

while true;do
    composedb document:create \
    ${MODEL_DEPLOYED_ID} \
    '{"data":1234}'\
    --ceramic-url=http://composedb:7007 \
    --did-private-key=$CERAMIC_ADMIN_PRIVATE_KEY

    sleep ${SLEEP_TIME}
done