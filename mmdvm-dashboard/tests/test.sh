#!/bin/sh

_PAT1="is starting"
do_parse(){
  #echo "$1" | gawk '{ match($0, /#([0-9]+)/, arr); if(arr[1] != "") print arr[1] }'
  echo "$1" | gawk '{ match($0, /(.+) is starting/, arr); if(arr[1] != "") print arr[1] }'
}

while read line;do
  #echo "> $line"
  do_parse $line
done
