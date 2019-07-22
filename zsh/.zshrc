#!/usr/bin/env bash
#echo -e "\e[32mDEBUG: zshrc\e[0m"
# == === == .zshrc powered by xkortex/bashbox ! == === ==

# path stuff
# == === == bootstrap XDG/bashbox path variables == === ==
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
. "${XDG_CONFIG_HOME}/bashbox/environ/bashbox-paths.sh"
# == === ==         end path setup               == === ==

ZDOTDIR="${XDG_DATA_HOME}/zsh"
# Path to your oh-my-zsh installation.
ZSH="${ZSH:=$HOME/.oh-my-zsh}"
# Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM="${ZSH_CUSTOM:=${ZSH}/custom"

export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

# allow proper terminal colors
export TERM=xterm-256color



# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
 DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
 DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"



# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions docker docker-compose)

# User configuration

## go
export GOPATH=$HOME/go
export PATH=${PATH:+${PATH}:}/usr/local/go/bin

export TRASHPATH="/home/$USER/.local/share/Trash/files"


# plugins and stuff
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

#Change first day of week to Monday
export LC_TIME=en_GB.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n ${SSH_CONNECTION} ]]; then
   export EDITOR='nano'
 else
   export EDITOR='nano'
 fi


## histdb
if [[ -e $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/ ]]; then
    source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd histdb-update-outcome
fi

## virtualenvwrapper
if [[ -e $HOME/.virtualenvs ]]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source $HOME/.local/bin/virtualenvwrapper.sh
fi

## custom plugins
# todo: make this an import
[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"

# Load all custom aliases

. $HOME/.zsh_aliases



#end
