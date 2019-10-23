#!/usr/bin/env bash

# Set up XDG user-configurable path bases and paths that depend on them
# See: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

if [[ -z ${HOME} ]]; then
    echo -e "\e[31mError: HOME not set. This script only works with logged in users\e[0m"
    echo -e "\e[31mIn fact, whatever you did to cause this is flat out wrong, fix it\e[0m"
    read  -n 1 -p "Press any key to continue (this will return):" lalalalaoops
    return
fi

# == === == bootstrap XDG path variables == === ==
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
#XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:=/etc/xdg}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
XDG_DATA_DIRS="${XDG_DATA_DIRS:=/usr/local/share/:/usr/share/}"
# == === ==         end XDG defaults     == === ==

if [[ -z ${XDG_RUNTIME_DIR} ]]; then
    XDG_RUNTIME_DIR="/tmp"
    echo -e "\e[31mError: XDG_RUNTIME_DIR not set. Setting to ${XDG_RUNTIME_DIR}\e[0m"
fi

export XDG_CONFIG_HOME
#export XDG_CONFIG_DIRS
export XDG_CACHE_HOME
export XDG_DATA_HOME
export XDG_DATA_DIRS
export XDG_RUNTIME_DIR
