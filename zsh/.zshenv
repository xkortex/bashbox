#echo -e "\e[35mDEBUG: zshENV\e[0m"

# == === == bootstrap XDG path variables == === ==
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
# == === ==         end XDG              == === ==

ZDOTDIR="${XDG_DATA_HOME}/zsh"

# oh-my-zsh
ZSH="${XDG_CONFIG_HOME}/oh-my-zsh"
ZSH_CUSTOM=$ZSH/custom

PATH="${HOME}/.local/bin:${PATH}"

export ZDOTDIR
export ZSH
export ZSH_CUSTOM
export PATH
export XDG_DATA_HOME
export XDG_CONFIG_HOME

. "$HOME/.cargo/env"
