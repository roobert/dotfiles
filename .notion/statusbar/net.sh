#!/usr/bin/env bash

# work out which interface we're connected using
INTERFACE="$(ip r s |grep default|grep -o 'dev \(.*\)'|awk '{print $2}')"
IP="$(ip a s $INTERFACE|grep -v inet6|grep inet|awk '{ print $2 }')"
ROUTE="$(ip r s|grep default|awk '{print $3}')"
LATENCY="$(ping -c1 -W2 8.8.8.8 -q | grep 'min/avg/max/mdev' | awk '{ print $4 }'|cut -d/ -f 2)"

if [[ $(echo "if ($LATENCY > 100) 1 else 0" | bc) -eq 1 ]]; then
  echo -n "$IP[$ROUTE] | $(printf "%.1f" $LATENCY)"
else
  echo -n "$IP[$ROUTE]"
fi
