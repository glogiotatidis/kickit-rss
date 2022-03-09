#!/usr/bin/env bash
set -xe

USERNAMES="panospet kickitathens"

mkdir -vp docs

generate_yt_cmd() {
    JSON_DATA=$(mktemp --suffix .json)
    YT_CMD="youtube-dl --geo-bypass -f http https://www.mixcloud.com/${user}/ -J --skip-download > ${JSON_DATA}"
}

for user in ${USERNAMES}
do
    generate_yt_cmd
    eval "${YT_CMD}"

    jinja render -d "${JSON_DATA}" -t ./template.yaml -lb -tb  > "docs/${user}.rss"
done
