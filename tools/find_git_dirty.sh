#!/bin/bash

for dir in $(fd -IH -td '.git' .)
do
    dir=$(dirname $dir)
    dir=$(realpath $dir)
    cd $dir
    

    STATE=""

    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        STATE="untracked-files ${STATE}"
    fi

    if ! git diff --quiet 2> /dev/null; then
        STATE="\e[1;31;mmodified ${STATE}\e[0m"
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        STATE="staged ${STATE}"
    fi

    if [[ -n $STATE ]]; then
        printf  "${dir}: ${STATE}\n"
    fi

    cd - > /dev/null
done
