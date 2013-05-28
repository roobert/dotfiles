#!/usr/bin/env zsh 

for f in ~/.dotfiles/.?*; ln -vsf $f ~/`basename $f`

