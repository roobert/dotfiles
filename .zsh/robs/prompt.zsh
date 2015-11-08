###
### my prompt stuff
###

# colour chart:  http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png or use 'spectrum_ls'

source $HOME/.zsh/zsh-git-prompt/zshrc.sh

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR=""
ZSH_THEME_GIT_PROMPT_BRANCH=" %{$FG[060]%}"
ZSH_THEME_GIT_PROMPT_STAGED=" %{$fg[yellow]%}%{\u26ab%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS=" %{$fg[red]%}%{\u2716%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED=" %{$fg[blue]%}%{\u271a%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND=" %{\u2193%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$FG[166]%}%{\u2191%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg[red]%}%{\u2717%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$FG[028]%}%{\u2713%G%}"

HOST=$(echo -n $(hostname -f) | tac -s.|sed 's/\.$//')

PHOST="%{$FG[240]%}${HOST}"
PWHERE="%{$FG[250]%}%d"

MODE_CMD="%{$FG[088]%}"
MODE_INS="%{$FG[156]%}"

export RPS1=''

function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)      VI_MODE="$MODE_CMD" ;;
    (main|viins) VI_MODE="$MODE_INS" ;;
    (*)          VI_MODE="$MODE_INS" ;;
  esac

  EXIT_STATUS="%(?..%{$fg[red]%}%?%{$FX[reset]%})"

  export PS1='$PHOST $PWHERE$(git_super_status) $EXIT_STATUS${VI_MODE}>%{$FX[reset]%} '
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# prevent 2*ESC-i insert-mode switch failure
noop () { }
zle -N noop
bindkey -M vicmd '\e' noop
