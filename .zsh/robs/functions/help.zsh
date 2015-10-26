# list useful stuff like aliases and functions along with description
function help {
cat <<- EOF
	# cheat sheet
	^e            - prefix line with 'vim', e.g: ^e^g would create 'vim \$()'
	^g            - wrap cli input in '\$()' (group command)
	hl            - highlight <string>
	g             - grep (ignore .git)
	f             - find . -name '<string>'   (find)
	fw            - find . -name '*<string>*' (find wild)
	mcd           - make and cd into (nested) dir
	dus           - du sorted by size
	mhi           - make html index for images
	
	# FZF
	^r                 - reverse-i-search fzf
	^f                 - fzf find
	<cmd> <path>@<tab> - fzf find from path
	fgrep              - fzf grep
	kill <tab>         - fzf kill

  # vim
  ^f                 - fzf (open C-{T,X,V} - tab, horizontal, vertical)
EOF
}
