#!/usr/bin/env bash

echo -e "\e[36mDEBUG: bootstrap-env.sh\e[0m"

# == === == bootstrap XDG path variables == === ==
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
# == === ==         end XDG              == === ==
export BASHBOX="${XDG_CONFIG_HOME}/bashbox"

# Initialize path variables so everything knows where to go
. ${BASHBOX}/zsh/.zshenv