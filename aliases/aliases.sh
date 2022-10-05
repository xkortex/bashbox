#!/usr/bin/env bash
#echo -e "\e[34mDEBUG: bashbox aliases\e[0m"

# Activate the aliases. Switch them on and off from here.
# Depends on $BASHBOX being set

. ${BASHBOX}/aliases/core.sh
. ${BASHBOX}/aliases/docker.aliases.sh
. ${BASHBOX}/aliases/git.aliases.sh
. ${BASHBOX}/aliases/misc.aliases.sh

if [[ "$(uname)" == "Darwin" ]]; then
  . ${BASHBOX}/aliases/osx.aliases.sh
fi
