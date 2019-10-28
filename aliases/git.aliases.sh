#!/usr/bin/env bash

alias ga.="git add . && git status"
alias gcm="git commit -m"
alias gpuom="git push -u origin master"
alias gacam="git add . && git commit -m"
alias ggraph="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(rese
t)%C(bold yellow)%d%C(reset)' --all"
alias grp="git rev-parse --short HEAD"
alias pls="git pull"
alias plsub="git pull --recurse-submodules && git submodule update --init --recursive"
