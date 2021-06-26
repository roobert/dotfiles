export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'ytet5uy4/fzf-widgets'

if zplug check 'ytet5uy4/fzf-widgets'; then
  # # Map widgets to key
  # bindkey '^@'  fzf-select-widget
  # bindkey '^@.' fzf-edit-dotfiles
  # bindkey '^@c' fzf-change-directory
  # bindkey '^@n' fzf-change-named-directory
  # bindkey '^@f' fzf-edit-files
  # bindkey '^@k' fzf-kill-processes
  # bindkey '^@s' fzf-exec-ssh
  bindkey '^j'  fzf-change-recent-directory
  # bindkey '^r'  fzf-insert-history
  # bindkey '^xf' fzf-insert-files
  # bindkey '^xd' fzf-insert-directory
  # bindkey '^xn' fzf-insert-named-directory

  ## Git
  # bindkey '^@g'  fzf-select-git-widget
  # bindkey '^@ga' fzf-git-add-files
  # bindkey '^@gc' fzf-git-change-repository

  # GitHub
  # bindkey '^@h'  fzf-select-github-widget
  # bindkey '^@hs' fzf-github-show-issue
  # bindkey '^@hc' fzf-github-close-issue

  ## Docker
  # bindkey '^@d'  fzf-select-docker-widget
  # bindkey '^@dc' fzf-docker-remove-containers
  # bindkey '^@di' fzf-docker-remove-images
  # bindkey '^@dv' fzf-docker-remove-volumes

  # Enable Exact-match by fzf-insert-history
  # FZF_WIDGET_OPTS[insert-history]='--exact'

  # Start fzf in a tmux pane
  # FZF_WIDGET_TMUX=1
else
  zplug install 'ytet5uy4/fzf-widgets'
fi

