#!/bin/bash

# Log in to receive a token, then create a screening using a JSON file for the payload.

# Requires jq to parse JSON:
#    https://github.com/stedolan/jq
#
# The secret.json file should contain an object with attributes "username" and "password".

set -e

USAGE="$(basename $0) api_url path/to/secret.json path/to/payload.json"

if [ $# -ne 3 ]
  then
    echo "usage:"
    echo $USAGE
    exit 1
fi

URL=$1
SECRETS_JSON=$2
PAYLOAD_FILE=$3

secrets=$(cat $SECRETS_JSON)
USERNAME=$(echo $secrets | jq -r '.username')
PASSWORD=$(echo $secrets | jq -r '.password')

# Log in to retrieve an authorization token.
content=$(
  curl \
    -s \
    -X POST \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -d "{\"api_user\":{\"uid\":\"$USERNAME\", \"password\":\"$PASSWORD\"}}" \
    "${URL}/login.json" 
  )

# Extract the token from the JSON body.
token=$(echo $content | jq -r '.token')

# Create a Screening.
content=$(
  curl \
    -v \
    -s \
    -X POST \
    -d @$PAYLOAD_FILE \
    -H "Authorization: ${token}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    "${URL}/screening/create"
  )

# Pretty print the JSON.  The -M means monochrome.
echo $content | jq -M



