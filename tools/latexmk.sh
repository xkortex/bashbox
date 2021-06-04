#!/usr/bin/env bash

(>&2 echo -e "latexmk" "$@")


unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
      docker run --rm -it -v $PWD:/workdir -e USER_ID="$(id -u)" -e GROUP_ID="$(id -g) "arkark/latexmk latexmk "$@"
      ;;
    Darwin*)
      docker run --rm -it -v "$PWD":"$PWD" -w "$PWD" arkark/latexmk latexmk "$@"
      ;;

    *)
      echo "UNKNOWN:${unameOut}"
      exit 1
esac


