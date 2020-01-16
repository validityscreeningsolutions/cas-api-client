#!/bin/bash
#
# Zip up the smoke test script and the integrator credentials file.

USAGE="$(basename $0) integrator_name"

if [ $# -ne 1 ]
  then
    echo "usage:"
    echo $USAGE
    exit 1
fi

NAME=$1

set -x 
zip -j build/$NAME.zip \
  examples/intro.sh  \
  examples/screening.create.sh \
  examples/data/screening.create.json \
  secrets/$NAME/*

