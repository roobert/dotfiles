# colour chart:  http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png or use 'spectrum_ls'

autoload -U colors
colors
setopt PROMPT_SUBST

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

MODE_CMD="%{$FG[128]%}"
MODE_INS="%{$FG[156]%}"

function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)      VI_MODE="$MODE_CMD" ;;
    (main|viins) VI_MODE="$MODE_INS" ;;
    (*)          VI_MODE="$MODE_INS" ;;
  esac
  zle reset-prompt
}

# prevent 2*ESC-i insert-mode switch failure
noop () { }

zle -N noop
bindkey -M vicmd '\e' noop

preexec() {
  PREEXEC_CALLED=1
}

precmd() {
  local LAST_EXIT_CODE=$?
  if [ "${LAST_EXIT_CODE}" != 0 ] && [ "${PREEXEC_CALLED}" = 1 ]; then
    EXIT_STATUS="%(?..%{$FG[009]%}${LAST_EXIT_CODE}%{$FX[reset]%}) "
    unset PREEXEC_CALLED;
  else
    unset EXIT_STATUS
  fi

  if [ -n "${VIRTUAL_ENV}" ]; then
    VIRTUAL_ENV_SIGN="v "
  else
    VIRTUAL_ENV_SIGN=""
  fi
}

if [[ $HOSTNAME == "mbp0.local" ]]; then
  WHERE="%{$FG[250]%}%~"
else
  # include hostname in prompt
  WHERE="%{$FG[250]%}%m:%~"
fi
PS1='${VIRTUAL_ENV_SIGN}${WHERE} ${EXIT_STATUS}${VI_MODE}>%{$FX[reset]%} '
RPS1=''


if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-finish () {
        echoti rmkx
    }
fi
