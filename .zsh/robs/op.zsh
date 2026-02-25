if (( $+commands[op] )); then
  eval "$(op completion zsh)"
  ops() { eval $(op signin) }
fi
