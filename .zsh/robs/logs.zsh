#!/usr/bin/env zsh

# useful for checking access logs for requests per minute..

# usage: $0 access_log*~*.gz

function requests_per_minute () {
  for log in $*; do
    echo -n "$log: average: "

    cat $log | awk '{ print $4  }' | cut -d':' -f 2-3 | uniq -c | \
      awk -F "^--" 'BEGIN { count = 0; total = 0  } { count += 1; total += $1  } END { print total/count  }'
  done
}

function requests_per_minute-percentile () {
  for log in $*; do

    REQUESTS_PER_MINUTE_DATA="$(cat $log| awk '{ print $4  }' | cut -d':' -f 2-3 | uniq -c | sort -n)"

    NUMBER_OF_REQUESTS_PER_MINUTE="$(echo ${REQUESTS_PER_MINUTE_DATA} | wc -l | awk '{ print $1  }')"

    NUMBER_OF_REQUESTS_IN_PERCENTILE="$(($(($NUMBER_OF_REQUESTS_PER_MINUTE * $PERCENTILE)) / 100))"

    PEAK="$(echo $REQUESTS_PER_MINUTE_DATA| tail -n 1)"

    echo -n "$log: (peak: $PEAK) - ${PERCENTILE}th percentile average: "

    echo $REQUESTS_PER_MINUTE_DATA | head -n $NUMBER_OF_REQUESTS_IN_PERCENTILE | \
      awk 'BEGIN { count = 0; total = 0  } { count += 1; total += $1  } END { print total/count  }'
  done
}
