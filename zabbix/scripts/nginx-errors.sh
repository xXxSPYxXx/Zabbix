#!/usr/bin/env bash


RESPONSE_STATUS="$2"

USER="$3"
PASS="$4"
SOURCE="$5"
RANGE="$6"
STREAMS="$7"

curl -sS -u ${USER}:${PASS} -H "Accept: application/json" -X GET "https://graylog.insave.ovh/api/search/universal/relative/terms?query=response_status%3A${RESPONSE_STATUS}+AND+source%3A${SOURCE}&range=${RANGE}&field=response_status&filter=streams%3A${STREAMS}" | jq -r '.total'
