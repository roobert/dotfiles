PYTHON_VERSION=$(python3 -V | cut -d ' ' -f2 | cut -d. -f -2)
PATH="${HOME}/Library/Python/${PYTHON_VERSION}/bin:$PATH"

# include my paths in path
MY_PATHS=($HOME/bin $HOME/.local/bin)

for my_path in $MY_PATHS; do
  if [ -d "$my_path" ]; then
    export PATH="$my_path:$PATH"
  fi
done
