```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gh
gh auth login
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone --bare git@github.com:roobert/dotfiles $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles show HEAD:install.sh | bash
```
