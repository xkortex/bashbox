#!/usr/bin/env bash

# == === == bootstrap XDG path variables == === ==
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
# == === ==         end XDG              == === ==

# Sets up the bashbox environment.
export BASHBOX="${XDG_CONFIG_HOME}/bashbox"
export BASHBOX_DATA="${XDG_DATA_HOME}/bashbox"
