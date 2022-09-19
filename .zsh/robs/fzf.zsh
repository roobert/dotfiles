export PATH="$PATH:$HOME/.fzf/bin"
export FZF_COMPLETION_TRIGGER='@'
export FZF_TMUX_HEIGHT="25%"
export FZF_DEFAULT_OPTS='
  --layout=default
  --extended-exact
  +s
  --color=fg:-1,bg:-1,hl:118,fg+:-1,bg+:-1,hl+:200
  --color=info:060,prompt:118,spinner:208,pointer:156,marker:208
'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zle      -N   fzf-file-widget
bindkey '^F' fzf-file-widget

function fzf-cdr () {
  local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf --layout reverse-list --height 21 --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf-cdr
bindkey "^J" fzf-cdr


function fzf-kubectl-ctx () {
  local selected_context=$(kubectl ctx | awk '{ print $1 }' | fzf --layout reverse-list --height 12 --query "$LBUFFER")
  if [ -n "$selected_context" ]; then
    BUFFER="kubectl config use-context ${selected_context}"
    zle accept-line
  fi
  zle reset-prompt
}

zle      -N   fzf-kubectl-ctx
bindkey '^K' fzf-kubectl-ctx
