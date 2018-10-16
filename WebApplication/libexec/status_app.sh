#!/bin/bash


#
# Stop selected service or all services
#
#   stop_app.sh [service]
#

here=$(dirname $0)
sys=$(uname -s)
if [ "$sys" != "Darwin" ]; then
  dir=$(readlink -e $here)
else
  dir=$here
  if [ "$dir" = "." ]; then 
    dir=$(pwd)
  elif [[ "$dir" == .* ]]; then 
    dir=${dir#*.}
    dir=$(pwd)${dir}
  elif ! [[ "$dir" == /* ]]; then 
    dir=$(pwd)/${dir}
  fi
fi


status_app () {

  docker-compose ps $@

}


cd "${dir}"/..

status_app $@
