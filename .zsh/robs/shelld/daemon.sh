#!/usr/bin/env bash
set -euo pipefail

# kill self if last shell exits

# start self from .zshrc on new shell

watch '~/.zsh/robs/shelld/k8s-current-context.sh; ~/.zsh/robs/shelld/shells.rb'
