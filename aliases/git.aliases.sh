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

# cleaned up 
unset gloga
unset ggu 
#alias glogam='git log --oneline --decorate --graph --all --not origin/gh-pages'
# only show my branches 
alias glogam='git log --oneline --decorate --graph $(git branch --list --format="%(refname)" | tr "\n" " " )'
alias gloga='git log --oneline --decorate --graph --all'
alias glogab'git log --oneline --decorate --graph main origin/$(git rev-parse --abbrev-ref HEAD) $(git rev-parse --abbrev-ref HEAD)'
alias plf='git pull origin --ff-only' 
alias forcepush='git push --force-with-lease'

# diffing
# git diff at merge point
alias gdam='git diff $(git merge-base --fork-point $(git symbolic-ref refs/remotes/origin/HEAD))'

grevert() {
	mkdir -pv "~/tmp/grevert/${PWD}"
	git diff > "~/tmp/grevert/${PWD}/$(date -u +'%Y-%m-%dT%H:%M:%SZ').patch"
}
