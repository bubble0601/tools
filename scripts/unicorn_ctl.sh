#!/usr/bin/env bash
if [ $# -eq 0 ];then
  echo "USAGE: $0 [start|stop|restart]"
  exit
fi

readlink_cmd="readlink"
if [[ $OSTYPE == darwin* ]]; then
  # Use greadlink on the mac
  readlink_cmd="greadlink"
fi

PIDFILE="deploy/pid/unicorn.pid"
cd "$(dirname $("${readlink_cmd}" -f "$0"))"/..

case "$1" in
start)
  if [ -e "$PIDFILE" ];then
    echo "$PIDFILE found. maybe unicorn is already running"
    exit
  fi
  if [ $# -ge 2 ]; then
    bundle exec unicorn -E production -c deploy/unicorn.rb -l $2 -D && echo "unicorn started"
  else
    bundle exec unicorn -E production -c deploy/unicorn.rb -D && echo "unicorn started"
  fi
  ;;
stop)
  if ! [ -e "$PIDFILE" ];then
    echo "$PIDFILE not found. maybe unicorn is not running"
    exit
  fi
  pid=$(cat "$PIDFILE")
  echo "killing pid=$pid"
  kill $pid
  ;;
restart)
  if ! [ -e "$PIDFILE" ];then
    echo "$PIDFILE not found. maybe unicorn is not running"
    exit
  fi
  pid=$(cat "$PIDFILE")
  echo "killing pid=$pid"
  kill $pid
  if [ $# -ge 2 ]; then
    bundle exec unicorn -E production -c deploy/unicorn.rb -l $2 -D && echo "unicorn started"
  else
    bundle exec unicorn -E production -c deploy/unicorn.rb -D && echo "unicorn started"
  fi
  ;;
esac
