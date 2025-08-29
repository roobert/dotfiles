if [ ! -f /opt/homebrew/bin/mise ]; then
  return
fi

eval "$(/opt/homebrew/bin/mise activate zsh)"

function miseinit() {
  cat >.mise.toml <<EOF
[env]
_.python.venv = { path = ".venv", create = true }

[tools]
python = "3.12"
EOF
}

_check_mise_on_cd() {
  [[ -f .mise.toml ]] && mise-install-helper
}
add-zsh-hook chpwd _check_mise_on_cd
