#!/usr/bin/env bash

alias d="docker"
alias doc="docker-compose"
alias dps="docker-pretty-ps 2>/dev/null || docker ps"
alias dna="docker network ls"
alias updoc="docker-compose up -d"
alias docd="docker-compose down"
alias dstat='docker stats $1 --no-stream --format "{\"container\":\"{{ .Name }}\",\"memory\":{\"raw\":\"{{ .MemUsage }}\",\"percent\":\"{{ .MemPerc }}\"},\"cpu\":\"{{ .CPUPerc }}\"}"'

errcho() {
    if [[ -z ${ERR_QUIET} ]]; then
        (>&2 echo -e "\e[31m$1\e[0m")
    fi
}

vprint2() {
# Verbose print on stderr
    if [[ -n ${VERBOSE} ]]; then
        (>&2 echo -e "\e[33m$1\e[0m")
    fi
}

_printfred() {
    (printf "\e[31m$@\e[0m")
}
_printfyel() {
    (printf "\e[33m$@\e[0m")
}
_printfblue() {
    (printf "\e[34m$@\e[0m")
}

isint() {
    re='^[0-9]+$'
    if  [[ $1 =~ $re ]] ; then
       echo "true"
    fi
}

in_container() {
    cat /proc/1/cgroup | grep docker
}

dg() {
# docker grep for name
    if [[ ${1:0:1} == "-" ]] ; then
        _ALL=
        FLAG=
        VERBOSE=
        ERR_QUIET=
        _ARG="${2}"
        if [[ "${1}" == *"v"* ]]; then
           _printfyel "Verbose\n"
           VERBOSE=true
        fi
        if [[ "${1}" == *"a"* ]]; then
            _ALL="-a"
        fi
        if [[ "${1}" == *"q"* ]]; then
            ERR_QUIET=true
        fi
    else
        _ARG="${1}"
    fi
    if [[ -n ${_ALL} ]]; then
        IMG_LIST=$(docker ps -a)
    else
        IMG_LIST=$(docker ps)
    fi
    if [[ -n ${IMG_LIST} ]]; then
        vprint2 "${IMG_LIST}"
        IMG_LIST=$(echo ${IMG_LIST} | grep ${_ARG})
    fi

    if [[ -z ${IMG_LIST} ]]; then
        errcho "No image names match grep "
    elif [[ $(echo ${IMG_LIST}  | wc -l) != '1' ]]; then
        errcho "Warning: More than one image matches, ambiguous"
        if [[ -n ${DG_SAFE} ]]; then
            return 1
        fi
        DOIT=true
    else
        DOIT=true

    fi

    if [[ -n $DOIT ]]; then
        echo ${IMG_LIST} | awk '{ print $1 }'
    fi
}

dn() {
        if [ -z "$1" ]; then
                docker ps --format "{{.Names}}"
        else
                docker ps --format "{{.Names}}" | tail -n"+$1" | head -n1
        fi
}

dlc() {
    if [[ -z ${1} ]]; then
        NAME=$(dn 1) # grab the first container if no number specified
    elif [[ -n $(isint ${1}) ]] ; then
        NAME=$(dn ${1})
    else
        NAME=$(dg ${1})
    fi
    echo "${NAME}" | head -1
}

dosh() {
    _ARG="${1}"
    NAME=$(dg ${_ARG})
    if [[ -z ${NAME} ]]; then
        ALL_IMGS=$(dg -aq ${_ARG})
        if [[ -n ${ALL_IMGS} ]]; then
            _printfblue "These containers match but have died: \n${ALL_IMGS}\n"
        else
            _printfred "No name found/specified, "
        fi
        errcho "cannot docker exec"
        return 1
    fi

    echo "starting ${NAME}"
    DOCKNUM=${1:-1}
    ENTRYPOINT=${2:-bash}
    docker exec -it ${NAME} ${ENTRYPOINT}
}

dofl() {
    docker logs -f $(dlc ${1})

}

gosh() {
        DOCKNAME=$( dg ${1} )
        ENTRYPOINT=${2:-bash}
        docker exec -it -e "DISPLAY" -e "QT_X11_NO_MITSHM=1" ${DOCKNAME} ${ENTRYPOINT}
}

dlast() {
# Get last container ID
docker ps -a --format "{{.ID}}" | head -1

}

dlastsh() {
# Get last container ID and jump into it
    DCMD=${DCMD:-bash}
    LAST_ID=$(docker ps -a --format "{{.ID}}" | head -1)
    TMP_NAME="$(docker ps -a --format "{{.Names}}" | head -1)_tmp"
    # report to user
    docker ps -a --format "{{.ID}} {{.Image}} {{.Status}}" | head -1
    docker commit ${LAST_ID} ${TMP_NAME}
    echo ">>> docker run -ti --rm $@ ${TMP_NAME} ${DCMD}"
    docker run -ti --rm $@ ${TMP_NAME} ${DCMD}
}