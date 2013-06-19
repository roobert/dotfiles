# if at work, include puppet stuff in CDPATH
if [ -d "$HOME/work/systems/pm" ]; then
  export CDPATH=".:$HOME/work/systems/pm/:$HOME/work/systems/trunk"
fi

# include my paths in path
MY_PATHS=($HOME/bin /opt/semantico/bin)

for my_path in $MY_PATHS; do
  if [ -d "$my_path" ]; then
    export PATH="$PATH:$my_path"
  fi
done

# if you've installed brew using coreutils on osx then prefer gnu 'ls' etc over osx bsd utils
if [ -d "/usr/local/opt/coreutils/libexec/gnubin" ]; then
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi