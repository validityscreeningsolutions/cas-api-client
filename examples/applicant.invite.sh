#!/bin/bash

# Log in to receive a token, then invite an applicant using a JSON file for the payload.

# Requires jq to parse JSON:
#    https://github.com/stedolan/jq

set -e

USAGE="$(basename $0) path/to/secrets.json path/to/payload.json"

if [ $# -ne 2 ]
  then
    echo "usage:"
    echo $USAGE
    exit 1
fi

SECRETS_JSON=$1
PAYLOAD_FILE=$2

secrets=$(cat $SECRETS_JSON)
URL=$(echo $secrets | jq -r '.url')
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

# Invite an applicant
content=$(
  curl \
    -s \
    -X POST \
    -d @$PAYLOAD_FILE \
    -H "Authorization: ${token}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    "${URL}/screening/initiate"
  )

# Pretty print the JSON.  The -M means monochrome.
echo $content | jq -M



