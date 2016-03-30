function install_rbenv {
  if type -f git 2>&1 >/dev/null; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  else
    echo "git is not installed!"
  fi
}
