#!/usr/bin/env bash

# Setup things just the way I like
# You can alter the default configuration directory by first passing
# XDG_CONFIG_HOME

# === === === === === === === bootstrapping === === === === === === === ===

# Optionally set env paths here, or pass them into this script
#XDG_CONFIG_HOME=$HOME/.config
#XDG_DATA_HOME=$HOME/.local/share

# Determine if we are running in a container - this affects certain assumptions
if [[ -n $(cat /proc/1/cgroup | grep docker) ]]; then
    export IN_CONTAINER=true
fi

if [[ -z ${XDG_CONFIG_HOME} ]]; then
    export XDG_CONFIG_HOME=$HOME/.config
fi

if [[ -n ${IN_CONTAINER} ]]; then
    apt-get update -qq && apt-get install -y sudo
fi

export BASHBOX="${XDG_CONFIG_HOME}/bashbox"
# === === === === === === === install stuff === === === === === === === ===

# install zsh
sudo apt-get install -y zsh git

# pull down this repo
git clone https://github.com/xkortex/bashbox.git ${BASHBOX}

# Bring remaining environment variables into the env
source ${BASHBOX}/bootstrap-env.sh

echo "ZDOTDIR:    ${ZDOTDIR}"
echo "ZSH:        ${ZSH}"
echo "ZSH_CUSTOM: ${ZSH_CUSTOM}"


# Install oh my zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

#source zsh/.zshrc

# zsh plugins
mkdir -p ${ZSH_CUSTOM}/plugins/
git clone https://github.com/larkery/zsh-histdb ${ZSH_CUSTOM}/plugins/zsh-histdb
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions

# === === === === === === === Cleanup === === === === === === === ===
if [[ -n ${IN_CONTAINER} ]]; then
    apt-get clean
    rm -rf /var/lib/apt/lists/*
fi
