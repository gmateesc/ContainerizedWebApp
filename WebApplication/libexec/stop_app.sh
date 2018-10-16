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


stop_app () {

  if [ $# -gt 0 ]; then 
     docker-compose rm -s -f $@
  else
     docker-compose rm -s -f web-app redis
  fi

  return
}


cd "${dir}"/..

stop_app $@

