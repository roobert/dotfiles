# add some extra stuff to man
function man {

  # list all man pages
  if [[ $# -eq 0 ]]; then
    man -k .
    return
  fi

  # list man sections
  if [[ $1 == "--list" ]]; then
    if [[ -z "$2" ]]; then

    cat <<"    EOF"

    man(1) sections

      1   Executable programs or shell commands
      2   System calls (functions provided by the kernel)
      3   Library calls (functions within program libraries)
      4   Special files (usually found in /dev)
      5   File formats and conventions eg /etc/passwd
      6   Games
      7   Miscellaneous (including macro packages and conventions), e.g. man(7), groff(7)
      8   System administration commands (usually only for root)
      9   Kernel routines [Non standard]

    EOF

      return 1
    fi

    whatis -s $2 -r .
    return
  fi

  echo $@
  command man $*
}
