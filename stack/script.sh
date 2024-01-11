#!/bin/bash

set -euo pipefail

REGION="eu-central-1"

for bucket in "av-definitions" "av-test"; do
    awslocal s3api \
        create-bucket --bucket "$bucket" \
        --create-bucket-configuration LocationConstraint="$REGION" \
        --region "$REGION"
done
