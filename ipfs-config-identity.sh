#!/bin/sh

FILE=$1
PEER=$2
PRIV=$3
TEMP=$(mktemp)

jq --arg PRIV "$PRIV" '.Identity.PrivKey = $PRIV' $FILE > "$TEMP" && mv "$TEMP" $FILE || exit 1
jq --arg PEER "$PEER" '.Identity.PeerID = $PEER' $FILE > "$TEMP" && mv "$TEMP" $FILE || exit 1
cat $FILE | jq '.Identity'
