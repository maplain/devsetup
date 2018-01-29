#!/bin/bash

#set -euo pipefail

quiet_pushd() {
  pushd $1 > /dev/null
}

quiet_popd() {
  popd $1 > /dev/null
}

PATH_TO_PKS_LOCKS=${PATH_TO_PKS_LOCKS:-/Users/fangyuanl/development/go/src/gitlab.eng.vmware.com/pks-locks}
if [ ! -d "$PATH_TO_PKS_LOCKS" ]; then
  echo "$PATH_TO_PKS_LOCKS doesn't exist"
  exit 1
fi

unclaim_lock() {
  quiet_pushd "$PATH_TO_PKS_LOCKS"
    git pull origin master > /dev/null 2>&1
    quiet_pushd nimbus-opsman-bosh
      {
      git mv claimed/"$1".yml unclaimed
      git commit -am "$(whoami) BOT:unclaim $1"
      git push origin master
      } > /dev/null 2>&1
      echo "$1 unclaimed successfully"
    quiet_popd
  quiet_popd
}

claim_lock() {
  quiet_pushd "$PATH_TO_PKS_LOCKS"
    git pull origin master > /dev/null 2>&1
    quiet_pushd nimbus-opsman-bosh
      {
      git mv unclaimed/"$1".yml claimed
      git commit -am "$(whoami) BOT:claim $1"
      git push origin master
      } > /dev/null 2>&1
      echo "$1 claimed successfully"
    quiet_popd
  quiet_popd
}

list_claimed_locks() {
  quiet_pushd "$PATH_TO_PKS_LOCKS"
    git pull origin master > /dev/null 2>&1
    quiet_pushd nimbus-opsman-bosh
      for i in `ls claimed`; do
        echo ${i%.yml}
      done
    quiet_popd
  quiet_popd
}

list_my_claimed_locks() {
  me="$(whoami)"
  if [ ${#@} -ge 1 ]; then
    me="${1}"
  fi
  for i in $(list_claimed_locks); do
    quiet_pushd "${PATH_TO_PKS_LOCKS}"
       if git log -n1 -- ./nimbus-opsman-bosh/claimed/${i}.yml | grep ${me} > /dev/null; then
          echo $i
       fi
    quiet_popd
  done
}

list_my_unclaimed_locks() {
  me="$(whoami)"
  if [ ${#@} -ge 1 ]; then
    me="${1}"
  fi
  for i in $(list_unclaimed_locks); do
    quiet_pushd "${PATH_TO_PKS_LOCKS}"
       if git log -n1 -- ./nimbus-opsman-bosh/unclaimed/${i}.yml | grep ${me} > /dev/null; then
          echo $i
       fi
    quiet_popd
  done
}

list_unclaimed_locks() {
  quiet_pushd "$PATH_TO_PKS_LOCKS"
    git pull origin master > /dev/null 2>&1
    quiet_pushd nimbus-opsman-bosh
      for i in `ls unclaimed`; do
        echo ${i%.yml}
      done
    quiet_popd
  quiet_popd
}

get_value_from() {
  f=$1
  t=$2
  v=$3
  quiet_pushd "$PATH_TO_PKS_LOCKS"
    git pull origin master > /dev/null 2>&1
    quiet_pushd nimbus-opsman-bosh
      echo $(bosh int $1/$2.yml --path=/$3 2>/dev/null)
    quiet_popd
  quiet_popd
}
