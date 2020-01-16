#!/bin/bash

# Log in to receive a token, then fetch a list of the available Positions.

# Requires jq to parse JSON:
#    https://github.com/stedolan/jq

set -e

USAGE="$(basename $0) path/to/secrets.json"

if [ $# -ne 1 ]
  then
    echo "usage:"
    echo $USAGE
    exit 1
fi

SECRETS_JSON=$1

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

# List the available Positions.
content=$(
  curl \
    -s \
    -X GET \
    -H "Authorization: ${token}" \
    -H "Accept: application/json" \
    "${URL}/positions"
  )

# Pretty print the JSON.  The -M means monochrome.
echo $content | jq -M



