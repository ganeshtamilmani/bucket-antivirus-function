#!/bin/bash

set -euo pipefail

cd "$( dirname "${BASH_SOURCE[0]}")"

timeout 30s bash -c 'until ./aws.sh s3 ls "s3://av-test/" 2> /dev/null; do sleep 3; done'

curl -sS "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}' | jq .
