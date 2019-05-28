if [[ -z ${XDG_DATA_HOME} ]]; then
    export XDG_DATA_HOME=$HOME/.local/share
fi

export ZDOTDIR="${XDG_DATA_HOME}/zsh"
export ZSH="${ZDOTDIR}"