export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path -)"

function auto_active_env() {
  DEFAULT_ENV_PATH="venv"

  function activate_venv() {
    if [[ -f "${DEFAULT_ENV_PATH}/bin/activate" ]]; then
      source "${DEFAULT_ENV_PATH}/bin/activate"
    fi
  }

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    activate_venv
  else
    PARENT_DIR="$(dirname ${VIRTUAL_ENV})"

    if [[ "$PWD"/ != "${PARENT_DIR}"/* ]]; then
      #deactivate
      activate_venv
    fi
  fi
}

chpwd_functions=(${chpwd_functions[@]} "auto_active_env")
