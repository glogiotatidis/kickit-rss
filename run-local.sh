#!/usr/bin/env sh

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/kickit-rss
git pull
./run.sh
