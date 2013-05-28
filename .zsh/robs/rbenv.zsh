# initialize rbenv
if [[ -d "$HOME/.rbenv/bin" ]]; then
  PATH="$HOME/.rbenv/bin:$PATH"
fi

type rbenv > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  eval "$(rbenv init -)"
fi

