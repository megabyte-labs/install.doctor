#!/usr/bin/env bash

# Prefer US English
export LANG="en_US"
export LC_ALL="en_US.UTF-8"

chmod +x ~/.local/bin/*

if [ -e install-terminal-theme ]; then
  install-terminal-theme > /dev/null
fi

if [ -e dotfile-system-prune ]; then
  dotfile-system-prune > /dev/null
fi

. "$HOME/.bashrc"
