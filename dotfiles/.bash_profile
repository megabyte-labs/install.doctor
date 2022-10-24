#!/usr/bin/env bash

chmod +x ~/.local/bin/*

if [ -e install-terminal-theme ]; then
  install-terminal-theme > /dev/null
fi

if [ -e dotfile-system-prune ]; then
  dotfile-system-prune > /dev/null
fi

. "$HOME/.bashrc"
