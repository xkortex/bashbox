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

ghsh() {
  local GITDESC=$(git describe --dirty --always --tags)
  local SHASUM=
  if [[ "${GITDESC}" == *"dirty"* ]]; then
    SHASUM=$(git diff | shasum | cut -c 1-7)
  fi
  echo "${GITDESC} ${SHASUM}"
}


git_remote_uri() {
  REM_PUSH=$(git remote -v | grep -P -o -e "(^${1})(.+)(?=\s\(push\))")
  echo "${REM_PUSH}" | awk '{print $2}'
}
# handy oneliner
#  REM_PUSH=$(git remote -v | grep -P -o -e '(?<=^athena\sathena\:)(?P<uri>.+)(?=\s\(push\))')

git_remote_path() {
  URI=$(git_remote_uri "${1}")
  echo "${URI}"| grep -P -o '(?<=\:)(.+)'
}

git_extract_patch() {
  __HERE__="Extracts file/path '$1' and generates patch (probably should redirect to a file). https://stackoverflow.com/a/11426261"
  git log --pretty=email --patch-with-stat --reverse -- "${@}"
}

git_apply_patch() {
  __HERE__="Applies patch file '$1' to the current repository"
  git am --committer-date-is-author-date < "${1}"
}

git_sync() {
  __HERE__="Sync a remote repository's state to the current repo's state. CAVEAT: Only works in repo root and only if the directory structure matches!"
  BRANCH=$(git branch --show-current)
  URI=$(git_remote_path "${1}")
  ssh "${1}" "cd ${URI} ; git checkout ${BRANCH} ; git reset --hard ${BRANCH}" # may need to be git reset --hard
  git diff | ssh "${1}" "cd ${URI} ; cat - | git apply"
}