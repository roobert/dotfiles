function haste_client {

  # originally jacked from here: https://gist.github.com/flores/3670953
  # added file type detection and personal aliases..

  server=$HASTE_SERVER

  usage="$0 pastes into $HASTE_SERVER
    usage: $0 something
    example: '$0 pie' or 'ps aufx |$0'"

  if [ -z $1 ]; then
    str=`cat /dev/stdin`;
  else
    str=`cat $1`;

    # attempt to detect file type by extension..
    EXTENSION="$(echo "$1" | rev | cut -d. -f1 | rev)"

    if [[ ! -z "$EXTENSION" ]]; then
      EXTENSION=".$EXTENSION"
    fi
  fi

  # try and guess type from contents of paste
  if [[ -z "$EXTENSION" ]]; then
    if $(echo "$str" | grep "#!/" | grep ruby > /dev/null 2>&1); then
      EXTENSION=".rb"
    fi

    if $(echo "$str" | grep "#!/" | grep zsh > /dev/null 2>&1); then
      EXTENSION=".zsh"
    fi

    if $(echo "$str" | grep "#!/" | grep sh > /dev/null 2>&1); then
      EXTENSION=".sh"
    fi

    if $(echo "$str" | grep "#!/" | grep python > /dev/null 2>&1); then
      EXTENSION=".py"
    fi

    # hope to god i never have to do any php..
    if $(echo "$str" | grep "<php" > /dev/null 2>&1); then
      EXTENSION=".php"
    fi

    # or perl..!
    if $(echo "$str" | grep "#!/" | grep perl > /dev/null 2>&1); then
      EXTENSION=".pl"
    fi
  fi

  if [ -z "$str" ]; then
    echo $usage;
    return 1;
  fi

  output=`curl -s -X POST -d "$str" $HASTE_SERVER/documents |perl -pi -e 's|.+:\"(.+)\"}|$1|'`

  if [[ ! -z $DISPLAY ]] && type -f xclip > /dev/null 2>&1; then
    echo $HASTE_SERVER/$output$EXTENSION | copy
  fi

  echo $HASTE_SERVER/$output$EXTENSION
}

function pasti {
  HASTE_SERVER="http://pasti.co"
  haste_client $*
}

function haste {
  HASTE_SERVER="http://hastebin.com"
  haste_client $*
}
