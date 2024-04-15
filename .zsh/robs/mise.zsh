if [ -f $HOME/.local/bin/mise ]; then
	eval "$($HOME/.local/bin/mise activate zsh)"

	function pyinit() {
		cat >.mise.toml <<EOF
[env]
_.python.venv = { path = ".venv", create = true }

[tools]
python = "3.10"
EOF
	}
fi
