#!/bin/bash

# Examples of searching for Applicants and Screenings

# Requires jq to parse JSON responses:
#    https://github.com/stedolan/jq

set -e

BASE_URL=https://api.validityidsource.com/api/v1
API_LOGIN=yourlogin
API_PASSWORD=yourpassword



# Log in to retrieve an authorization token.
content=$(
  curl \
    -X POST \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -d "{\"api_user\":{\"uid\":\"$API_LOGIN\", \"password\":\"$API_PASSWORD\"}}" \
    "${BASE_URL}/login.json" 
  )

# Extract the token from the JSON body.
token=$(echo $content | jq -r '.token')

# Search for applicants by email address.  Pagination params are optional.
curl -i \
  -X GET \
  -H "Authorization: ${token}" \
  -H "Accept: application/json" \
  "${BASE_URL}/applicants?email=lglenn@mnu.edu&page=1&size=4"

echo

