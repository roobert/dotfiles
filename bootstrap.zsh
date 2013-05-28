#!/usr/bin/env zsh 

for new_file in ~/.dotfiles/.?*; do
  cp -Rv $new_file $HOME
done

