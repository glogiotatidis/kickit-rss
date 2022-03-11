#!/bin/bash
set -xe

USERNAMES="panospet kickitathens"

generate_yt_cmd() {
    JSON_DATA=$(mktemp --suffix .json)
    YT_CMD="youtube-dl --geo-bypass -f http https://www.mixcloud.com/${user}/ -J --skip-download | jq '.entries[].timestamp |= strftime(\"%a, %d %b %Y %H:%M:%S +0000\")' > ${JSON_DATA}"
}

for user in ${USERNAMES}
do
    generate_yt_cmd
    eval "${YT_CMD}"

    jinja render -d "${JSON_DATA}" -t ./template.yaml -lb -tb  > "docs/${user}.rss"
done
