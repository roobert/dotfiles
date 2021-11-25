# Workstation Config

## Display
* Accessibility -> Reduce motion (no animation on desktop switch)

## Keyboard
* Switch `§` and `\`` keys:
* -> https://apple.stackexchange.com/questions/329085/tilde-and-plus-minus
```
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064},{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}'
cat << 'EOF' > ~/.tilde-switch && chmod +x ~/.tilde-switch
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064},{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}'
EOF
sudo /usr/bin/env bash -c "cat > /Library/LaunchDaemons/org.custom.tilde-switch.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.custom.tilde-switch</string>
    <key>Program</key>
    <string>${HOME}/.tilde-switch</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
  </dict>
</plist>
EOF
sudo launchctl load -w -- /Library/LaunchDaemons/org.custom.tilde-switch.plist
```

* Switch escape key:
* * https://stackoverflow.com/a/40254864
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

gnu tools
```
brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
```

## Configure iTerm2
```
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
```
* Select Mono Nerd Font from iterm2
* dim interactive split panes
* dimming affects text ~100%
* background colour: #1c2240
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
* Line cursor
* Tab order, remap control-tab to next tab: https://gitlab.com/gnachman/iterm2/-/issues/8219
* Disable beep

* Keybindings
```
{"Key Mappings":{"0xf72d-0x20000":{"Action":8,"Text":""},"0xf72b-0x100000":{"Action":4,"Text":""},"0xf700-0x300000-0x7e":{"Label":"","Action":20,"Text":""},"0xf701-0x300000-0x7d":{"Label":"","Action":21,"Text":""},"0xf72d-0x100000":{"Action":8,"Text":""},"0x9-0x40000-0x0":{"Label":"","Action":0,"Text":""},"0xf702-0x300000-0x7b":{"Label":"","Action":18,"Text":""},"0xf700-0x320000-0x7e":{"Label":"","Action":55,"Text":""},"0x19-0x60000-0x0":{"Label":"","Action":2,"Text":""},"0xf703-0x320000-0x7c":{"Label":"","Action":29,"Text":"88C029F2-350F-49CC-96D1-24912313B78C"},"0xf702-0x320000-0x7b":{"Label":"","Action":53,"Text":""},"0xf72c-0x100000":{"Action":9,"Text":""},"0xf729-0x100000":{"Action":5,"Text":""},"0xf701-0x320000-0x7d":{"Label":"","Action":28,"Text":"88C029F2-350F-49CC-96D1-24912313B78C"},"0xf72c-0x20000":{"Action":9,"Text":""},"0xf703-0x300000-0x7c":{"Label":"","Action":19,"Text":""}},"Touch Bar Items":{}}
```

## Shell
* Add dotfiles
* Install fzf
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc
```
* Add other stuff..
```
brew install zplug
brew tap vmware-tanzu/carvel
brew install coreutils wget pyenv fzf jq tfenv kapp \
  util-linux ripgrep graphviz qemu npm neovim libgit2 libgit2-dev

# language servers and linters for neovim - also install with LspInfo
brew install hashicorp/tap/terraform-ls
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
brew install efm-langserver shellcheck shfmt
brew install luarocks

luarocks install --server=https://luarocks.org/dev luaformatter
luarocks install luacheck

brew install rust
cargo install stylua
```

## Python
```
# NOTE: gnutools must not be in path when compiling python on m1 macs..
pyenv install 3.10.0
pyenv global 3.10.0
```
