#!/bin/bash
set -xe

USER="kickitathens"
NEW_RSS=$(mktemp --suffix .rss)
MIXCLOUD_JSON_DATA=$(mktemp --suffix .json)
FORCE=false

while getopts "f" arg; do
  case $arg in
    f)
      FORCE=true
      ;;
  esac
done

mkdir -vp docs

# Fetch mixcloud data
youtube-dl --geo-bypass -f http https://www.mixcloud.com/${USER}/ -J --skip-download | jq '.entries[].timestamp |= strftime("%a, %d %b %Y %H:%M:%S +0000")' > ${MIXCLOUD_JSON_DATA}

# GENERATE RSS
jinja render -d "${MIXCLOUD_JSON_DATA}" -t ./template.yaml -lb -tb  > ${NEW_RSS}

# Check if contents of file are newer
CURRENT_DATE=$(date --date "$(cat docs/${USER}.rss |  grep -oP "<pubDate>\K(.+)(?=</pubDate>)" | head -n 1)" +%s)
NEW_DATE=$(date --date "$(cat ${NEW_RSS} |  grep -oP "<pubDate>\K(.+)(?=</pubDate>)" | head -n 1)" +%s)

if [ ${FORCE} = true ] || [[ ${NEW_DATE} -gt ${CURRENT_DATE} ]]
then
   echo "New file moving"
   mv ${NEW_RSS} docs/${USER}.rss
fi
