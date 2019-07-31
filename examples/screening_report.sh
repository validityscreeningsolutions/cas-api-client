#!/bin/bash

# Retrieve the PDF report for a completed screening.

# Requires jq to parse JSON responses:
#    https://github.com/stedolan/jq

BASE_URL=https://validity-ejobapp-uat.herokuapp.com/api/v1
SCREENING_ID="218"

content=$(
  curl \
    -X POST \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -d '{"api_user":{"uid":"theapiuser", "password":"thepassword"}}' \
    "${BASE_URL}/login.json" 
  )

token=$(echo $content | jq -r '.token')

curl -i \
  -X GET \
  -H "Authorization: ${token}" \
  -H "Accept: application/pdf" \
  "${BASE_URL}/reports/${SCREENING_ID}"


