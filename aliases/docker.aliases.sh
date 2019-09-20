#!/usr/bin/env bash

alias d="docker"
alias doc="docker-compose"
alias dps="docker-pretty-ps 2>/dev/null || docker ps"
alias dna="docker network ls"
alias updoc="docker-compose up -d"
alias docd="docker-compose down"
alias dstat='docker stats $1 --no-stream --format "{\"container\":\"{{ .Name }}\",\"memory\":{\"raw\":\"{{ .MemUsage }}\",\"percent\":\"{{ .MemPerc }}\"},\"cpu\":\"{{ .CPUPerc }}\"}"'

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
        docker ps | grep ${1} | awk '{ print $1 }'
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
    NAME=$(dlc ${1})
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