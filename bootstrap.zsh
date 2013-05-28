#!/usr/bin/env zsh 

for f in ~/.dotfiles/.?*; ln -sf ~/`basename $f` $f

