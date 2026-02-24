# colour chart:  http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png or use 'spectrum_ls'

autoload -U colors
colors
setopt PROMPT_SUBST

# detect terminal background: "light" or "dark"
function _detect_terminal_background() {
  # try OSC 11 query (skip for Terminal.app which doesn't support it)
  if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
    local old_stty=$(stty -g)
    stty raw -echo min 0 time 5
    printf '\e]11;?\a'
    local response=""
    local char
    while IFS= read -rs -k 1 char 2>/dev/null; do
      response+="$char"
      if [[ "$char" == $'\a' ]] || [[ "$response" == *$'\e\\' ]]; then
        break
      fi
    done
    stty "$old_stty"

    if [[ "$response" =~ 'rgb:([0-9a-fA-F]+)/([0-9a-fA-F]+)/([0-9a-fA-F]+)' ]]; then
      local r g b
      if (( ${#match[1]} == 4 )); then
        r=$(( 16#${match[1][1,2]} ))
        g=$(( 16#${match[2][1,2]} ))
        b=$(( 16#${match[3][1,2]} ))
      else
        r=$(( 16#${match[1]} ))
        g=$(( 16#${match[2]} ))
        b=$(( 16#${match[3]} ))
      fi
      if (( (299 * r + 587 * g + 114 * b) / 1000 > 128 )); then
        echo "light"
      else
        echo "dark"
      fi
      return
    fi
  fi

  # fallback: macOS system appearance
  if [[ "$(uname)" == "Darwin" ]]; then
    if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
      echo "dark"
    else
      echo "light"
    fi
    return
  fi

  echo "dark"
}

TERMINAL_BACKGROUND=$(_detect_terminal_background)

zle -N zle-line-init
zle -N zle-keymap-select

if [[ "$TERMINAL_BACKGROUND" == "light" ]]; then
  MODE_CMD="%{$FG[128]%}"
  MODE_INS="%{$FG[022]%}"
  PATH_COLOR="%{$FG[238]%}"
else
  MODE_CMD="%{$FG[128]%}"
  MODE_INS="%{$FG[156]%}"
  PATH_COLOR="%{$FG[250]%}"
fi

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
  WHERE="${PATH_COLOR}%~"
else
  # include hostname in prompt
  WHERE="${PATH_COLOR}%m:%~"
fi
PS1='${VIRTUAL_ENV_SIGN}${WHERE} ${EXIT_STATUS}${VI_MODE}>%{$FX[reset]%} '
RPS1=''


if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-finish
fi
