#!/bin/bash

set -euo pipefail

cd "$( dirname "${BASH_SOURCE[0]}")"

echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > /tmp/av-test-eicar.txt
echo "foobar" > /tmp/av-test-clean.txt

for filename in av-test-eicar.txt av-test-clean.txt; do
    ./aws.sh s3 rm "s3://av-test/${filename}" || true
    ./aws.sh s3 cp "/tmp/${filename}" s3://av-test/
    av_status="$(./aws.sh s3api get-object-tagging --bucket av-test --key "$filename" | jq -r '.TagSet[] | select(.Key=="av-status").Value')"
    if test -n "$av_status"; then
        echo "Unexpected av-status value: $av_status"
        exit 1
    fi

    curl -sS "http://localhost:9001/2015-03-31/functions/function/invocations" -d "{
        \"Records\": [
            {
                \"s3\": {
                    \"bucket\": {\"name\": \"av-test\"},
                    \"object\": {\"key\": \"${filename}\"}
                }
            }
        ]
    }" | jq .
done


eicar_status="$(./aws.sh s3api get-object-tagging --bucket av-test --key "av-test-eicar.txt" | jq -r '.TagSet[] | select(.Key=="av-status").Value')"
if [[ "$eicar_status" != "INFECTED" ]]; then
    echo "Expecting INFECTED got $eicar_status"
fi

clean_status="$(./aws.sh s3api get-object-tagging --bucket av-test --key "av-test-clean.txt" | jq -r '.TagSet[] | select(.Key=="av-status").Value')"
if [[ "$clean_status" != "CLEAN" ]]; then
    echo "Expecting CLEAN got $eicar_status"
fi

echo "Test OK"
