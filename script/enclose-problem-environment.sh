#!/bin/bash

# get paths and extension
fullPath="$@"
fullPathWoExt=${fullPath%.*}
filename=${fullPathWoExt##*/}

# batch prepare problems
title=$(echo "$filename" | sed -e 's/-/ /g' -e 's/_/-/g')
printf "<div class="Problem">**$title**\n\n" | cat - "$@" > temp
printf "\n</div>\n\n" >> temp
mv temp "$@"
