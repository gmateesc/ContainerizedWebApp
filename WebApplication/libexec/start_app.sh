#!/bin/bash

#
# Start selected service or all services
#
#   start_app.sh [service] [-d]
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



start_app() {
    
  docker-compose up $@
}


cd "${dir}"/..

start_app $@

