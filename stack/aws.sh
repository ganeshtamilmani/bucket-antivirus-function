#!/bin/bash

set -euo pipefail

export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_REGION="${AWS_REGION:-eu-central-1}"
export AWS_DEFAULT_REGION="$AWS_REGION"

ENDPOINT="http://localhost:4566"

aws --endpoint-url="$ENDPOINT" "$@"