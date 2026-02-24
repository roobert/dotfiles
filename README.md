```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone --bare https://github.com/roobert/dotfiles $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles show HEAD:install.sh | bash
/opt/homebrew/bin/brew install gh
/opt/homebrew/bin/gh auth login
```
