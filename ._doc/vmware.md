FIXME: tidy this up..
minimal install
full screen resolution for retina
disable screen lock
disable screen blanking, etc.
disable side channel mitigations
disable all the keyboard bindings
  use cmd+ctrl+f to fullscreen

disable bell
install zsh
install kitty
install notion
screen flash? is that visual bell?
for keybindings: vert make big, make term full screen, splitting, window moving, window navigation
pasting between vm and 
adjust "fusion shortcuts"
adjust "key mappings"

--Mac Host Shortcuts->Enable Mac host key shortcuts -> disable

# ctrl+shift+c/v
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

flip ctrl and command in vmware
use alt for window management
ctrl for application shortcuts

rw ALL=(ALL) NOPASSWD:ALL

make a command key to control mapping in vmware preferences

fix ~

pyenv

neovim: unstable: https://github.com/neovim/neovim/wiki/Installing-Neovim

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

apt install build-essential

* key-bindings
* then look
  
  needs vmware bullshit running for escape key to work - start ubuntu then logout

create /usr/share/xsessions/xsession.desktop file in  desktops dir
[Desktop Entry]
Name=Xsession
Comment=Xsession window manager
Exec=/etc/X11/Xsession
Type=Application

xinitrc
sudo vmware-user-suid-wrapper &
bash bin/escape.sh
xrandr --output Virtual1 --scale 0.60x0.60
exec ssh-agent notion


neovim font

bin/escape.sh
xmodmap -e "clear Lock"
xmodmap -e "keycode 9 = Escape NoSymbol Escape"
xmodmap -e "keycode 66 = Caps_Lock NoSymbol Caps_Lock"



enable running hypervisor stuff (for docker?)

install nvm and npm
install exuberant-ctags

