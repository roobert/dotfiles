#!/usr/bin/env zsh

# usage: $0 /var/log/sams_server/access_log*~*.gz
function requests_per_minute () {
  for log in $*; do
    echo -n "$log: "

    cat $log | awk '{ print $4  }' | cut -d':' -f 2-3 | uniq -c | \
      awk 'BEGIN { count = 0; total = 0  } { count += 1; total += $1  } END { print total/count  }'
  done
}
