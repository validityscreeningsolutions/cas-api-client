#!/bin/bash

# Examples of searching for Applicants and Screenings

# Requires jq to parse JSON responses:
#    https://github.com/stedolan/jq

set -e

BASE_URL=https://sandbox.validityidsource.com/api/v1
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
  "${BASE_URL}/applicants?email=joe@example.com&page=1&size=4"

# Search for applicants by your "external_id".
curl -i \
  -X GET \
  -H "Authorization: ${token}" \
  -H "Accept: application/json" \
  "${BASE_URL}/applicants?external_id=c46ed331a"

# Search for screenings by applicant email address.
curl -i \
  -X GET \
  -H "Authorization: ${token}" \
  -H "Accept: application/json" \
  "${BASE_URL}/screenings?email=joe@example.com"

# Search for screenings by your "external_id".
curl -i \
  -X GET \
  -H "Authorization: ${token}" \
  -H "Accept: application/json" \
  "${BASE_URL}/screenings?external_id=816e332b"

