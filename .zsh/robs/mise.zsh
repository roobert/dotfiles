eval "$(/Users/rw/.local/bin/mise activate zsh)"

function pyinit() {
	cat >.mise.toml <<EOF
[env]
_.python.venv = { path = ".venv", create = true }

[tools]
python = "3.10"
EOF
}
