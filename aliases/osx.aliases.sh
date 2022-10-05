#!/usr/bin/env bash
# Mac OSX aliases

unalias grep &>/dev/null
alias grep="ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
