# Make home and end keys work.
[[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
[[ -z "$terminfo[kend]" ]] || bindkey -M emacs "$terminfo[kend]" end-of-line

# all taken from: https://github.com/tureba/myconfigfiles/blob/master/zshrc
# this fixes switching between vi-modes
bindkey -rpM viins '^['

bindkey -M vicmd k vi-up-line-or-history
bindkey -M vicmd j vi-down-line-or-history

bindkey -v
# fix backwards history search
bindkey -M viins "^r" history-incremental-search-backward
bindkey -M vicmd "^r" history-incremental-search-backward
# fix backspace key
bindkey -M viins "^H" backward-delete-char
bindkey -M vicmd "^H" backward-delete-char
bindkey -M viins "^?" backward-delete-char
bindkey -M vicmd "^?" backward-delete-char
# fix insert key
bindkey -M viins "^[[2~" overwrite-mode
bindkey -M vicmd "^[[2~" overwrite-mode
# fix delete key
bindkey -M viins "^[[3~" delete-char
bindkey -M vicmd "^[[3~" delete-char
# fix ctrl + left/right to jump word
bindkey -M viins "^[[1;5C" forward-word
bindkey -M viins "^[[1;5D" backward-word
bindkey -M vicmd "^[[1;5C" forward-word
bindkey -M vicmd "^[[1;5D" backward-word
# fix arrow keys
bindkey -M viins "^[[A" up-line-or-history
bindkey -M vicmd "^[[A" up-line-or-history
bindkey -M viins "^[[B" down-line-or-history
bindkey -M vicmd "^[[B" down-line-or-history
bindkey -M viins "^[[C" forward-char
bindkey -M vicmd "^[[C" forward-char
bindkey -M viins "^[[D" backward-char
bindkey -M vicmd "^[[D" backward-char
# line movements in commnad mode (needs home and end)
bindkey -M vicmd "0" beginning-of-line
bindkey -M vicmd "$" end-of-line
# line movements in insert mode
bindkey -M viins "^[[7~" beginning-of-line # home
bindkey -M viins "^[[8~" end-of-line # end

#changing mode clobbers the keybinds, so store the keybinds before and execute 
#them after
binds=`bindkey -L`
bindkey -v
for bind in ${(@f)binds}; do eval $bind; done
unset binds

