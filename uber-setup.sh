#!/usr/bin/env bash

# Setup things just the way I like
# You can alter the default configuration directory by first passing
# XDG_CONFIG_HOME
echo "Installing BASHBOX"

# === === === === === === === flags === === === === === === === ===
for arg in "$@" ; do
    if [[ "${arg}" == "-u" || "${arg}" == "--user" ]] ; then USERMODE=true ; fi
    if [[ "${arg}" == "-i" || "${arg}" == "--install" ]] ; then INSTALL_PACKAGES=true ; fi

done

# === === === === === === === bootstrapping === === === === === === === ===

# Optionally set env paths here, or pass them into this script
#XDG_CONFIG_HOME=$HOME/.config
#XDG_DATA_HOME=$HOME/.local/share

# == === == bootstrap XDG path variables == === ==
OS_NAME=`uname -s | tr '[:upper:]' '[:lower:]'`
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"

if [[ $OS_NAME != 'linux' ]]; then
  echo "Error: this script is for linux only!"
  exit 1
fi
# == === ==         end XDG              == === ==
export BASHBOX="${XDG_CONFIG_HOME}/bashbox"

# Determine if we are running in a container - this affects certain assumptions
if [[ -n $(cat /proc/1/cgroup | grep docker) ]]; then
    export IN_CONTAINER=true
fi

if [[ -n ${IN_CONTAINER} ]]; then
  if [[ -n ${INSTALL_PACKAGES} ]]; then
    apt-get update -qq && apt-get install -y sudo
  fi
fi

# === === === === === === === install stuff === === === === === === === ===

# install zsh, sqlite for histdb
if [[ -z ${USERMODE} ]]; then
    if [[ -n ${INSTALL_PACKAGES} ]]; then
      sudo apt-get install -y zsh git sqlite3
    fi
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

#echo "ZDOTDIR:    ${ZDOTDIR}"
#echo "ZSH:        ${ZSH}"
#echo "ZSH_CUSTOM: ${ZSH_CUSTOM}"
#echo "BASHBOX:    ${BASHBOX}"

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
if [[ ! -d ${ZSH_CUSTOM}/plugins/zsh-histdb ]]; then
    git clone https://github.com/larkery/zsh-histdb ${ZSH_CUSTOM}/plugins/zsh-histdb
fi
if [[ ! -d ${ZSH_CUSTOM}/plugins/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi 
# === === === === === === === Linking === === === === === === === ===

# todo: prevent flattening
ln -sf ${BASHBOX}/zsh/.zshenv ${HOME}/.zshenv
ln -sf ${BASHBOX}/zsh/.zshenv ${ZDOTDIR}/.zshenv
ln -sf ${BASHBOX}/zsh/.zshrc ${ZDOTDIR}/.zshrc
ln -sf ${BASHBOX}/aliases/aliases.sh ${HOME}/.zsh_aliases
#ln -sf ${BASHBOX}/tmux/.tmux.conf ${HOME}/.tmux.conf

# todo: install virtualenvwrapper.


# === === === === === === === Cleanup === === === === === === === ===
if [[ -n ${IN_CONTAINER} ]] && [[ -n ${INSTALL_PACKAGES} ]]; then
    apt-get clean
    rm -rf /var/lib/apt/lists/*
fi

echo -e "\e[42mBashbox install complete!\e[0m"

zsh
