# include my paths in path
MY_PATHS=($HOME/bin $HOME/opt/node/bin)

for my_path in $MY_PATHS; do
  if [ -d "$my_path" ]; then
    export PATH="$my_path:$PATH"
  fi
done

# prefer coreutils over bsdutils
if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi
