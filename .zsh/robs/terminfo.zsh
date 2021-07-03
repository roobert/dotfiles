# by default copying from an xterm includes trailing whitespace because the
# xterm-256color terminfo definition doesn't contain the BCE
function terminfo_install_xterm_256color_bce () {
  infocmp xterm-256color | sed -e 's/am, km,/am, bce, km,/' | tic -
}
