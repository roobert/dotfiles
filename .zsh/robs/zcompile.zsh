# speed up zsh starting by generating zwc files
function zshrc-compile () {
  for f in ${ZSH_ROOT}/**/*.zsh; do
    zcompile $f
  done
}

function z () {
  zshrc-compile
  exec zsh
}

