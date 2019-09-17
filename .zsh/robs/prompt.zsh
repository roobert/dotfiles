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

HOST=$(hostname -f | tr '.' '\n' | tac | tr '\n' '.' | sed 's/\.$//')
PHOST="%{$FG[240]%}${HOST}"

#PHOST="%{$FG[240]%}%m"

PWHERE=" %{$FG[250]%}%~"

MODE_CMD="%{$FG[128]%}"
MODE_INS="%{$FG[156]%}"

RPS1=''

function exit_code() {
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    EXIT_STATUS="%(?..%{$FG[009]%}${LAST_EXIT_CODE}%{$FX[reset]%}) "
    echo "${EXIT_STATUS}"
  else
    echo ""
  fi
}

function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)      VI_MODE="$MODE_CMD" ;;
    (main|viins) VI_MODE="$MODE_INS" ;;
    (*)          VI_MODE="$MODE_INS" ;;
  esac

  if [[ -f ~/.shelld/global/k8s-current-context ]]; then
    . ~/.shelld/global/k8s-current-context

    unalias kubectl > /dev/null 2>&1

    # good
    if [[ ${PWD} =~ "kuber\/conf\/${K8S_CURRENT_CONTEXT_PROJECT}" ]]; then
      # kuber context dir matches k8s context
      #K8S_CONTEXT_COLOUR="002"
      K8S_CONTEXT_COLOUR="004"

    # bad
    elif [[ "${PWD}" =~ "kuber/conf" ]]; then
      # kuber context dir differs from k8s context
      K8S_CONTEXT_COLOUR="125"
      alias kubectl="echo 'wrong context!'"

    # ok
    else
      # outside of kuber dir structure
      K8S_CONTEXT_COLOUR="004"
    fi

    KUBERNETES_CONTEXT="%{$FG[248]%}:%{$FX[reset]%}%{$FG[${K8S_CONTEXT_COLOUR}]%}${K8S_CURRENT_CONTEXT_PROJECT}%{$FG[248]%}/%{$FX[reset]%}%{$FG[${K8S_CONTEXT_COLOUR}]%}${K8S_CURRENT_CONTEXT_CLUSTER}%{$FX[reset]%}"

  else
    KUBERNETES_CONTEXT=""
  fi

  if [[ -f ${HOME}/.shelld/pid.lock ]]; then
    SHELLD="${HOME}/.shelld/shells/$$"

    if kill -0 $(cat ${HOME}/.shelld/pid.lock) > /dev/null 2>&1; then
      SHELLD_PROMPT=""
    else
      rm -r ${HOME}/.shelld/global/*(N)
      rm -r ${HOME}/.shelld/shells/*(N)
      rm -f ${HOME}/.shelld/pid.lock
      SHELLD_PROMPT=" %{$FG[003]%}☠%{$FX[reset]%}"
      [ -f ~/.zsh/robs/shelld/shelld.zsh ] && source ~/.zsh/robs/shelld/shelld.zsh
    fi

    if [[ -f "$SHELLD/git" ]]; then
      . "$SHELLD/git"

      GIT_STATUS=" %{$FG[013]%}${GIT_CURRENT_BRANCH}%{$FX[reset]%}"

      if [[ ! -z "${GIT_CURRENT_STASHES}" ]]; then
        GIT_STASHES="(%{$FG[003]%}${GIT_CURRENT_STASHES}%{$FX[reset]%})"
      else
        GIT_STASHES=""
      fi
    else
      GIT_STATUS=""
      GIT_STASHES=""
    fi
  else
    SHELLD_PROMPT=""
    GIT_STATUS=""
    GIT_STASHES=""
  fi

  #PS1='$PHOST$KUBERNETES_CONTEXT$PWHERE$(git_super_status) ${GIT_STASHES}$EXIT_STATUS${VI_MODE}>%{$FX[reset]%} '
  PS1='${PHOST}${KUBERNETES_CONTEXT}${PWHERE}${GIT_STATUS}${GIT_STASHES}${SHELLD_PROMPT} $(exit_code)${VI_MODE}>%{$FX[reset]%} '
  zle reset-prompt
  echoti smkx
}

PS1='$PHOST $PWHERE >%{$FX[reset]%} '

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-finish () {
        echoti rmkx
    }
fi

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# tmux
#prmptcmd() { eval "$PROMPT_COMMAND" }
#precmd_functions=(prmptcmd)

# prevent 2*ESC-i insert-mode switch failure
noop () { }
zle -N noop
bindkey -M vicmd '\e' noop

