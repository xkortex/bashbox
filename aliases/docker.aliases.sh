#!/usr/bin/env bash

alias d="docker"
alias doc="docker-compose"
alias dna="docker network ls"
alias updoc="docker-compose up -d"
alias docd="docker-compose down"

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

dlps() {
  docker ps --format '{{.ID}}\t{{.Status | printf "%-12s" }} {{.Names | printf "%-36s" }} {{.Image| printf "%s"}}'
}


dps() {
  docker-pretty-ps 2>/dev/null || dlps

}

in_container() {
    cat /proc/1/cgroup | grep docker
}

dstat() {
  docker stats $1 --no-stream --format "{\"container\":\"{{ .Name }}\",\"memory\":{\"raw\":\"{{ .MemUsage }}\",\"percent\":\"{{ .MemPerc }}\"},\"cpu\":\"{{ .CPUPerc }}\"}"
}

dg() {
  # docker regexp by name, return ID
  # This is primarly used to grab a single docker ID to operate on
  # pass any arguments after '--' directly to `docker ps`

  ARGS=( "$@" )
  LOCAL=()
  TO_PASS=()
  TRIPPED=
  TARGET=
  VERBOSE=
  DG_EXCLUSIVE=
  FILTER_FIELD="name"
  i=0
  for arg in "${ARGS[@]}"; do
    i=$((i+1))
    if [[ "$arg" == "--" ]]; then
      TRIPPED=true
      continue
    fi

    if [[ -z "$TRIPPED" ]]; then
      LOCAL+=("${ARGS[i]}")
    else
      TO_PASS+=("${ARGS[i]}")
    fi
  done

  for arg in "${LOCAL[@]}"; do
    if [[ ${arg:0:1} != "-" ]] ; then
      TARGET="${arg}" # assign the target if it isn't a flag
      continue
    fi

    if [[ "${arg:1:1}" == "v" ]]; then
           VERBOSE=true
    elif [[ "${arg:1:1}" == "1" ]]; then
           DG_EXCLUSIVE=true # fail if more than one container matches
    elif [[ "${arg:1:1}" == "a" ]]; then
           FILTER_FIELD="ancestor" # match ancestor (image name or descendant)
    fi

  done

  if [[ -n ${VERBOSE} ]]; then
      FULL_IMG_LIST=$(docker ps --filter "${FILTER_FIELD}=${TARGET}" "${TO_PASS[@]}")
      (>&2 echo -e "\e[33m${FULL_IMG_LIST}\e[0m")
  fi

  IMG_LIST=$(docker ps --format "{{.ID}}" --filter "name=$TARGET" "${TO_PASS[@]}")


    if [[ -z ${IMG_LIST} ]]; then
        errcho "No image names match pattern "
        return 1
    elif [[ $(echo ${IMG_LIST}  | wc -l) != '1' ]]; then
        errcho "Warning: More than one image matches, ambiguous"
        if [[ -n ${DG_EXCLUSIVE} ]]; then
            return 1
        fi
    fi

    echo ${IMG_LIST}
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
    NAME=$(dg -1 ${_ARG})
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
    docker run -ti --rm --network=host $@ ${TMP_NAME} ${DCMD}
}

dcleanup(){
    docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

dretag(){
  # $1 is initial URI, $2 is new tag
  if [[ -z "${1}" || -z "${2}" ]]; then
    echo "must provide url and tag arguments"
    return
  fi

  NEWTAG=`python -c "print('${1}'.split(':')[0]+':${2}')"`
  echo "\`docker tag ${1} ${NEWTAG}\`";
  echo " > Tag and push the following tag?"
  echo "${NEWTAG}"
  read yn
    case $yn in
        [Yy]* )  docker tag "${1}" "${NEWTAG}" ;;
        [Nn]* ) return;;
        * ) echo "Aborted" ;;
    esac
  echo "\`docker push ${NEWTAG}\`";
  echo " > Do you wish to push this tag to remote?"
  read yn
    case $yn in
        [Yy]* )  docker push "${NEWTAG}" ;;
        * ) echo "Aborted";;
    esac
}
