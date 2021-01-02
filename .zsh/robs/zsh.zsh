# nicked from matthewfranglen..

# Enter command mode and v will provide a full $EDITOR for commands
# See https://news.ycombinator.com/item?id=5508341
# http://stackoverflow.com/questions/890620/unable-to-have-bash-like-c-x-e-in-zsh
# http://nuclearsquid.com/writings/edit-long-commands/
# etc etc
autoload -U edit-command-line
zle      -N         edit-command-line
bindkey  -M vicmd v edit-command-line

# Fix delete, home and end which would otherwise just caps a random bunch of
# characters. Thanks to Michael Francis for this fix!
# (Amazingly these bindings vary, so this may not work for you. inputrc is
# supposed to be the source for this sort of thing)
if [[ -r /etc/inputrc ]]; then
  source =(cat /etc/inputrc |
              sed -ne '/^#/d'    \
              -e 's/://'         \
              -e 's/^/bindkey /' \
              -e '/\(delete-char\|beginning-of-line\|end-of-line\)/p')
fi

# This allows alt-. to insert the last word of the last command (i.e. !$)
bindkey "^[." insert-last-word

autoload -U zmv

fpath=(~/.zsh/fpath $fpath)

# tmux+zsh/vi-mode paste fix
(( $+TMUX  )) && unset zle_bracketed_paste
