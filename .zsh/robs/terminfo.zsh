# by default copying from an xterm includes trailing whitespace because the
# xterm-256color terminfo definition doesn't contain the BCE
function terminfo_install_xterm_256color_bce () {
  infocmp xterm-256color | sed -e 's/am, km,/am, bce, km,/' | tic -
}

if [[ ! -r $HOME/.terminfo/78/xterm-256color-italic ]]; then
file=$(mktemp)
cat <<EOT > "$file"
xterm-256color-italic|xterm with 256 colors and italic,
    sitm=\E[3m, ritm=\E[23m,
    use=xterm-256color,
EOT

tic "$file"
rm "$file"
fi
