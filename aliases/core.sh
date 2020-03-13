#!/usr/bin/env bash

# This file is for super-transportable aliases, also useful for sh.

alias ..="cd .."
alias e="echo"
alias h="history -i | grep -Pv '^ *[0-9]+  [[:digit:]\:\- ]{16}  h '| grep "
alias hosts="cat /etc/hosts"
alias p="ping -c 1"
alias reso="cat /etc/resolv.conf"
alias rs="readlink -f"
alias wat="hostname && id -un"

errcho() {
    (>&2 echo -e "\e[31m$1\e[0m")
}

vprint2() {
# Verbose print on stderr
    if [[ -n ${VERBOSE} ]]; then
        (>&2 echo -e "\e[33m$1\e[0m")
    fi
}

to () {
    if [[ ! -e "${1}" ]]; then
        errcho "File/dir does not exist: ${1}"
    fi
    if [[ $OS_NAME == "linux" ]]; then
      _FLAG="--color=tty"
    elif [[ $OS_NAME == "darwin" ]]; then
      _FLAG="-G"
    else
      _FLAG="--"
    fi
    if [[ -d "${1}" ]]; then
        cd "${1}"
        ls "${_FLAG}"
    else
        cd "$(dirname ${1})"
        _NAME="$(basename ${1})"
        ls "$(pwd)/${_NAME}"
        ls -lah "${_NAME}"
    fi

}

f () {
    find . -iname '*'${1}'*' 2> /dev/null
}

hist() {
    history | tail -"${1}"
}