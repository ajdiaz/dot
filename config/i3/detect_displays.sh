#!/bin/bash

XRANDR="xrandr"
CMD="${XRANDR}"
declare -A VOUTS
eval VOUTS=$(${XRANDR}|awk 'BEGIN {printf("(")} /^\S.*connected/{printf("[%s]=%s ", $1, $2)} END{printf(")")}')
declare -A POS
#XPOS=0
#YPOS=0
#POS="${XPOS}x${YPOS}"

POS=([X]=0 [Y]=0)

find_mode() {
  echo $(${XRANDR} |grep ${1} -A1|awk '{FS="[ x]"} /^\s/{printf("WIDTH=%s\nHEIGHT=%s", $4,$5)}')
}

xrandr_params_for() {
  if [ "${2}" == 'connected' ]
  then
    if [ "${1:0:4}" == 'HDMI' ]; then
      local scale="--scale 2x2"
    else
      local scale="--scale 1x1"
    fi
    eval $(find_mode ${1})  #sets ${WIDTH} and ${HEIGHT}
    MODE="${WIDTH}x${HEIGHT}"
    CMD="${CMD} --output ${1} --mode ${MODE} --pos ${POS[X]}x${POS[Y]} ${scale}"
    POS[X]=$((${POS[X]}+${WIDTH}))
    return 0
  else
    CMD="${CMD} --output ${1} --off"
    return 1
  fi
}

for VOUT in ${!VOUTS[*]}
do
  xrandr_params_for ${VOUT} ${VOUTS[${VOUT}]}
  feh --bg-scale /home/ajdiaz/img/bg/montains-bw.png
done
set -x
${CMD}
set +x
