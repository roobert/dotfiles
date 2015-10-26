function install_rbenv {
  if type -f git 2>&1 >/dev/null; then
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  else
    echo "git is not installed!"
  fi
}
