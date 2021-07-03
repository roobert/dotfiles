# include my paths in path
MY_PATHS=($HOME/bin $HOME/opt/node/bin $HOME/.local/bin)

for my_path in $MY_PATHS; do
  if [ -d "$my_path" ]; then
    export PATH="$my_path:$PATH"
  fi
done
