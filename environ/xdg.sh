#!/usr/bin/env bash

# Set up XDG user-configurable path bases and paths that depend on them

if [[ -z ${XDG_CONFIG_HOME} ]]; then
    export XDG_CONFIG_HOME=$HOME/.config
fi

if [[ -z ${XDG_DATA_HOME} ]]; then
    export XDG_DATA_HOME=$HOME/.local/share
fi

export BASHBOX="${XDG_CONFIG_HOME}/bashbox"
export BASHBOX_DATA="${XDG_DATA_HOME}/bashbox"

