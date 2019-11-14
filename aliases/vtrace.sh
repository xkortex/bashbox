#!/usr/bin/env bash


# You can use this by linking into your PATH and `source vtrace.sh`
vtrace() {
# Verbose print on stderr
    if [[ -n ${VTRACE_ON} ]]; then
    # This gives you the filename of the script which calls vtrace, not the source
    # Handy!
        (>&2 echo -e "\e[1m\e[37m<$(realpath ${0})> \e[33m$1\e[0m")
    fi
}