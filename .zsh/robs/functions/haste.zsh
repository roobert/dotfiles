function haste_client {

  # jacked from: https://gist.github.com/flores/3670953

  server=$HASTE_SERVER

  usage="$0 pastes into $server
    usage: $0 something
    example: '$0 pie' or 'ps aufx |$0'"

  if [ -z $1 ]; then
    str=`cat /dev/stdin`;
  else
    str=$1;
  fi

  if [ -z "$str" ]; then
    echo $usage;
    exit 1;
  fi

  output=`curl -s -X POST -d "$str" $server/documents |perl -pi -e 's|.+:\"(.+)\"}|$1|'`

  echo $server/$output
}

function pasti {
  HASTE_SERVER="http://pasti.co"
  haste_client $*
}

function haste {
  HASTE_SERVER="http://hastebin.com"
  haste_client $*
}
