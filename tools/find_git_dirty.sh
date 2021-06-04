#!/bin/bash

UNTRACKED_FILES=${UNTRACKED_FILES}

for dir in $(fd -IH -td '.git' .)
do
    dir=$(dirname $dir)
    dir=$(realpath $dir)
    cd $dir
    

    STATE=""

	if [[ -n ${UNTRACKED_FILES} ]]; then 
    	if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        	STATE="untracked-files ${STATE}"
        fi
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
if [[ -n $STATE ]]; then
	exit 1
fi
