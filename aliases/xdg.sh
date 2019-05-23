#!/usr/bin/env bash

if [[ -z ${XDG_CONFIG_HOME} ]]; then
    export XDG_CONFIG_HOME=$HOME/.config
fi

if [[ -z ${XDG_DATA_HOME} ]]; then
    export XDG_DATA_HOME=$HOME/.local/share
fi