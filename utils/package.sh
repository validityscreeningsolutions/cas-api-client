#!/bin/bash
#
# Zip up the smoke test script and the integrator credentials file.

USAGE="$(basename $0) integrator_name path/to/secret.json"

if [ $# -ne 2 ]
  then
    echo "usage:"
    echo $USAGE
    exit 1
fi

NAME=$1
SECRETS_JSON=$2

#zip -j build/$NAME.zip examples/intro.sh $SECRETS_JSON
zip -j build/$NAME.zip \
  examples/intro.sh  \
  examples/screening.create.sh \
  examples/data/screening.create.json \
  $SECRETS_JSON

