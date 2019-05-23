#!/usr/bin/env bash

alias d="docker"
alias doc="docker-compose"
alias dps="docker-pretty-ps 2>/dev/null || docker ps"
alias dna="docker network ls"
alias updoc="docker-compose up -d"
alias docd="docker-compose down"

in_container() {
    cat /proc/1/cgroup | grep docker

}
