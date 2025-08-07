#!/usr/bin/env bash
# Misc aliases

alias rsp="rsync -a --info=progress2"
alias ips="ip -c -br addr"
alias pingo="ping -c 1 google.com"
alias pingd="ping -c 1 8.8.8.8"

alias sapt="sudo apt-get install"
alias sapty="sudo apt-get install -y"
alias supt="sudo apt-get update"

# openssl
alias showcert='openssl x509  -noout -text -in'
alias showcsr='openssl req -noout -text -in'
alias showrsakey='openssl rsa -noout -text -in'
