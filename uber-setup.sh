#!/usr/bin/env bash

# Setup things just the way I like
# You can alter the default configuration directory by first passing
# XDG_CONFIG_HOME
echo "Installing BASHBOX"

# === === === === === === === flags === === === === === === === ===
for arg in "$@" ; do
    if [[ "${arg}" == "-u" || "${arg}" == "--user" ]] ; then USERMODE=true ; fi

done

# === === === === === === === bootstrapping === === === === === === === ===

# Optionally set env paths here, or pass them into this script
#XDG_CONFIG_HOME=$HOME/.config
#XDG_DATA_HOME=$HOME/.local/share

# == === == bootstrap XDG path variables == === ==
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
# == === ==         end XDG              == === ==
export BASHBOX="${XDG_CONFIG_HOME}/bashbox"

# Determine if we are running in a container - this affects certain assumptions
if [[ -n $(cat /proc/1/cgroup | grep docker) ]]; then
    export IN_CONTAINER=true
fi

if [[ -n ${IN_CONTAINER} ]]; then
    apt-get update -qq && apt-get install -y sudo
fi

# === === === === === === === install stuff === === === === === === === ===

# install zsh
if [[ -z ${USERMODE} ]]; then
    sudo apt-get install -y zsh git
fi

# pull down this repo
if [[ -d ${BASHBOX} ]]; then
    echo "Bashbox already downloaded"
    lastpwd=${PWD}
#    cd ${BASHBOX}
#    git pull
#    cd ${lastpwd}
else
    git clone https://github.com/xkortex/bashbox.git ${BASHBOX}
fi

# Bring remaining environment variables into the env
# This ensures oh my zsh is installed in the right place and such
ln -sf ${BASHBOX}/environ/xdg-paths.sh ~/.xdg-paths.sh
. ${HOME}/.xdg-paths.sh
. ${BASHBOX}/bootstrap-env.sh

echo "ZDOTDIR:    ${ZDOTDIR}"
echo "ZSH:        ${ZSH}"
echo "ZSH_CUSTOM: ${ZSH_CUSTOM}"
echo "BASHBOX:    ${BASHBOX}"


#exit 0
# Install oh my zsh
if [[ -d ${ZSH} ]]; then
    echo "oh-my-zsh already downloaded"
    lastpwd=${PWD}
#    cd ${BASHBOX}
#    git pull
#    cd ${lastpwd}
else
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "${ZSH}" || {
        printf "Error: git clone of oh-my-zsh repo failed\n"
        exit 1
    }
fi
#source zsh/.zshrc

# zsh plugins
mkdir -p ${ZSH_CUSTOM}/plugins/
mkdir -p ${ZDOTDIR}
#git clone https://github.com/larkery/zsh-histdb ${ZSH_CUSTOM}/plugins/zsh-histdb
#git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions

# === === === === === === === Linking === === === === === === === ===

# todo: prevent flattening
ln -sf ${BASHBOX}/zsh/.zshenv ${HOME}/.zshenv
ln -sf ${BASHBOX}/zsh/.zshenv ${ZDOTDIR}/.zshenv
ln -sf ${BASHBOX}/zsh/.zshrc ${ZDOTDIR}/.zshrc


# === === === === === === === Cleanup === === === === === === === ===
if [[ -n ${IN_CONTAINER} ]]; then
    apt-get clean
    rm -rf /var/lib/apt/lists/*
fi


echo "ZDOTDIR:    ${ZDOTDIR}"
echo "ZSH:        ${ZSH}"
echo "ZSH_CUSTOM: ${ZSH_CUSTOM}"
echo "BASHBOX:    ${BASHBOX}"
head ${ZDOTDIR}/.zshrc

echo -e "\e[42mBashbox install complete!\e[0m"

zsh
