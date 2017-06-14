###
### my prompt stuff
###

# colour chart:  http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png or use 'spectrum_ls'

autoload -U colors
colors
setopt PROMPT_SUBST

#source $HOME/.zsh/zsh-git-prompt/zshrc.sh

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

HOST=$(hostname -f | tr '.' '\n' | tac | tr '\n' '.' | sed 's/\.$/\n/')
PHOST="%{$FG[240]%}${HOST}"

#PHOST="%{$FG[240]%}%m"

PWHERE="%{$FG[250]%}%d"

MODE_CMD="%{$FG[088]%}"
MODE_INS="%{$FG[156]%}"

RPS1=''

function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)      VI_MODE="$MODE_CMD" ;;
    (main|viins) VI_MODE="$MODE_INS" ;;
    (*)          VI_MODE="$MODE_INS" ;;
  esac

  if [[ -f ~/.shelld/global/k8s-current-context ]]; then
    . ~/.shelld/global/k8s-current-context
    KUBERNETES_CONTEXT="%{$FG[248]%}:%{$FX[reset]%}%{$FG[004]%}${K8S_CURRENT_CONTEXT_PROJECT}%{$FG[248]%}/%{$FX[reset]%}%{$FG[004]%}${K8S_CURRENT_CONTEXT_CLUSTER}%{$FX[reset]%} "
  else
    KUBERNETES_CONTEXT=""
  fi

  SHELLD="${HOME}/.shelld/shells/$$"

  if [[ -f "$SHELLD/git" ]]; then
    . "$SHELLD/git"
    GIT_STATUS=" %{$FG[013]%}${GIT_CURRENT_BRANCH}%{$FX[reset]%}"
  else
    GIT_STATUS=""
  fi

  unset GIT_STASHES
  STASHES="$(git stashes)"

  if [[ ! -z ${STASHES} ]]; then
    GIT_STASHES="(%{$FG[003]%}${STASHES}%{$FX[reset]%})"
  fi

  EXIT_STATUS="%(?..%{$fg[red]%}%?%{$FX[reset]%})"

  #PS1='$PHOST$KUBERNETES_CONTEXT$PWHERE$(git_super_status) ${GIT_STASHES}$EXIT_STATUS${VI_MODE}>%{$FX[reset]%} '
  PS1='${PHOST}${KUBERNETES_CONTEXT}${PWHERE}${GIT_STATUS}${GIT_STASHES} $EXIT_STATUS${VI_MODE}>%{$FX[reset]%} '
  zle reset-prompt
}

PS1='$PHOST $PWHERE >%{$FX[reset]%} '

zle -N zle-line-init
zle -N zle-keymap-select

# tmux
#prmptcmd() { eval "$PROMPT_COMMAND" }
#precmd_functions=(prmptcmd)

# prevent 2*ESC-i insert-mode switch failure
noop () { }
zle -N noop
bindkey -M vicmd '\e' noop

