# Workstation Config

## Keyboard
* Switch § and ` keys:

* * https://apple.stackexchange.com/questions/329085/tilde-and-plus-minus-%C2%B1-in-wrong-place-on-keyboard

* Switch escape key:

* * https://stackoverflow.com/questions/127591/using-caps-lock-as-esc-in-mac-os-x/40254864#40254864

* Switch to Australian keyboard layout to remap shift-3 to '#'

* Under Keyboard -> Text disable double spacebar full-stop

* Disable smart quotes

* Set key repeat to fastest/shortest

## Programs
* iterm2
* slack
* signal
* whatsapp
* homebrew
* docker
* istatmenus
* bitwarden
* fzf
* gcloud sdk:

```
curl https://sdk.cloud.google.com | bash
gcloud components update --version=...
```

* gist:
```
brew install gh
gh auth login
```

## Configure iTerm2
* Unlimited scrollback
* Tabs -> show tab bar even when there is one tab
* Disable show tab numbers
* Disable tab close
* Appearance -> panes -> disable show per-pane titlebar
* Profiles -> session -> status bar enabled
* Configure status bar -> git, rainbow, set background as same as left panel
  (color picker)
* Apperance -> status bar location -> bottom
* Enable icons (search icons)
* Left tabs
* Mouse follow focus
* Adjust colour to blue
* Enable git hint thing
* Select DroidSansMono Nerd Font from iterm2
* Line cursor
* Tab order, remap control-tab to next tab: https://gitlab.com/gnachman/iterm2/-/issues/8219
* Disable beep
```
brew tap caskroom/fonts
brew cask install font-hack-nerd-font
```

## Shell
* Add dotfiles
* Install FZF
```
brew install zplug
brew tap vmware-tanzu/carvel
brew install coreutils wget pyenv fzf jq tfenv kapp \
  util-linux ripgrep graphviz qemu

# language servers and linters for neovim - also install with LspInfo
brew install hashicorp/tap/terraform-ls
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
brew install efm-langserver shellcheck
luarocks install --server=https://luarocks.org/dev luaformatter
```

## Python
```
pyenv install 3.9.5
pyenv global 3.9.5
```

## Neovim
```
pip install neovim
brew install neovim --HEAD
```

## Neovide
A fancy NeoVIM client in Rust
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
brew install cmake
git clone https://github.com/Kethku/neovide
cd neovide
cargo build --release
```
