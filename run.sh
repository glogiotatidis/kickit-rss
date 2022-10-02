#!/bin/bash
set -xe

git push --set-upstream origin master
python3 -m venv venv
. venv/bin/activate
pip install -r requirements.txt
./generate-rss.sh

NEW_FILES=$(git diff --quiet || echo "yes")

if [ "${NEW_FILES}" = "yes" ]
then
    git add docs
    git commit -m "New RSS"
    git push origin
fi
curl -s https://hc-ping.com/810f622a-404e-4d58-9d98-f659426c37b5
