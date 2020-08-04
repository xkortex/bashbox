#!/usr/bin/env bash
# Misc aliases

alias rsp="rsync -a --info=progress2"
alias ips="ip -c -br addr"
alias pingo="ping -c 1 google.com"
alias pingd="ping -c 1 8.8.8.8"

alias sapt="sudo apt-get install"
alias sapty="sudo apt-get install -y"
alias supt="sudo apt-get update"

alias whitespace="sed 's/ /·/g;s/\t/￫/g;s/\r/§/g;s/$/¶/g'"

# disk info with labels
alias diskinfo="lsblk -o name,mountpoint,label,size,uuid"

# output df -h as json-formatted
dfj() {
  df -Ph | \
  jq -R -s '
    [
      split("\n") |
      .[] |
      if test("^/") then
        gsub(" +"; " ") | split(" ") | {mount: .[0], spacetotal: .[1], spaceavail: .[2]}
      else
        empty
      end
    ]'
}

autoar() {
  __here__="Automatically archive a file or directory with rar and 10% error correction"
    rar a -r -ol -rr10p "${1}.rar" "$1"
}

