function wrap-cli-input() {
	BUFFER="\$($BUFFER)"
}

zle -N wrap-cli-input
bindkey -M viins '^g' wrap-cli-input

function prepend-cli-input-vim() {
	BUFFER="vim $BUFFER"
}

zle -N prepend-cli-input-vim
bindkey -M viins '^e' prepend-cli-input-vim

function help {
	bash -c "help $*"
}
