#!/usr/bin/env bash

# This file is for super-transportable aliases, also useful for sh.

alias ..="cd .."
alias e="echo"
alias h="history -i | grep -Pv '^ *[0-9]+  [[:digit:]\:\- ]{16}  h '| grep "
alias hosts="cat /etc/hosts"
alias rs="readlink -f"
alias wat="hostname && id -un"

errcho() {
    (>&2 echo -e "\e[31m$1\e[0m")
}

to () {
    cd "${1}" && success=true || echo "pwd: $PWD"
    if [[ -n $success ]]; then
        ls --color=tty
    fi
}

f () {
    find . -iname '*'${1}'*' 2> /dev/null
}

hist() {
    history | tail -"${1}"
}