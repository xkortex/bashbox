#!/usr/bin/env bash

# This file is for super-transportable aliases, also useful for sh.

# we need Proper Grep everywhere (aka gnu grep) so we have to first monkeypatch mac's grep
if [[ "$OSTYPE" == "darwin"* ]]; then
  NEWGREP=g"$(type grep | sed 's/grep is an alias for //')"
  unalias grep
  alias grep="$NEWGREP"
fi


alias ..="cd .."
alias e="echo"
alias h="history -i | grep -Pv '^ *[0-9]+  [[:digit:]\:\- ]{16}  h '| grep "
alias hosts="cat /etc/hosts"
alias p="ping -c 1"
alias reso="cat /etc/resolv.conf"
alias rs="readlink -f"
alias wat="hostname && id -un"

if [[ $OS_NAME == "linux" ]]; then
      alias _color_ls="ls --color=tty"
    elif [[ $OS_NAME == "darwin" ]]; then
      alias _color_ls="ls -G"
    else
      alias _color_ls="ls"
fi

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
    if [ "${#}" -eq 0 ]; then # no arguments, boot up fzf, jump to that result
      to "$(fzf)"
    elif [ "${#}" -eq 1 ] && [ "${1}" = '-' ]; then               # last dir
      z '-'
    elif [[ -e "${1}" && ! -d "${1}" ]]; then                      # pointing to a file-like
#      errcho "file-like"
      z "$(dirname ${1})"
        _NAME="$(basename ${1})"
        _color_ls "$(pwd)/${_NAME}"
        _color_ls -lah "${_NAME}"

    else
        z "${@}"
        echo -e "\e[36m$(pwd)\e[0m"
        _color_ls
    fi
}

f () {
    find . -iname '*'${1}'*' 2> /dev/null
}
fud () {
    find . -type d -iname '*'${1}'*' 2> /dev/null
}

hist() {
    history | tail -"${1}"
}
