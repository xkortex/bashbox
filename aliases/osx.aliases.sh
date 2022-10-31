#!/usr/bin/env bash
# Mac OSX aliases

if ! command -v ggrep &> /dev/null
then
    warn_command_not_found ggrep "${0}"
else
  unalias grep &>/dev/null
  alias grep="ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
fi


