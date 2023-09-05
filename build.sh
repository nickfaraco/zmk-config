#!/usr/bin/env bash

usage() {
  cat << EOF >&2
Usage: $PROGNAME [-p] [-b <board>] [<shield>] [<split_side>]

-p           : pristine build, empty the build directory and start from scratch (useful for new boards and/or shields)
-b <board>   : board, specify the board (default: nice_nano_v2)
<shield>     : specify the name of the board to be built
<split_side> : specify the side of the board to be built, for split keyboards (default: left)

EOF
  exit 1
}

(( $# )) || usage

PRISTINE=0
BOARD="nice_nano_v2"

while getopts pb: option; do
    case "${option}" in
    p)
        PRISTINE=1
        shift;;
    b)
        BOARD=$OPTARG
        shift; shift;;
    *)
        echo "entering"
        usage
    esac
done
shift "$((OPTIND - 1))"
ARG1=${1:-chocofi}
ARG2=${2:-left}

if [ "$PRISTINE" -eq 1 ]; then
west build -p -b ${BOARD} -d ./build/${ARG2} -s /workspaces/zmk-urob/app -- -DZMK_CONFIG="/workspaces/zmk-config/config" -DSHIELD=${ARG1}_${ARG2}
else
west build -d ./build/${ARG2} -s /workspaces/zmk-urob/app
fi

cp ./build/${ARG2}/zephyr/zmk.uf2 ./${ARG1}_${ARG2}.uf2