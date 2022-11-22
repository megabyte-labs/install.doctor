# Prefer US English
export LANG="en_US"

# Detect support for advanced terminal features
if [ "$0" = 'bash' ] || [ "$0" = '/bin/bash' ]; then
  export BASH_SUPPORT=true
fi

chmod +x ~/.local/bin/*

### Clean Up
# Too many dotfiles are stressful :|
if [ -d /usr/local/src/professor-dotfiles ]; then
  if [ -f ~/.gtkrc-2.0-kde4 ]; then
    mkdir -p ~/.config > /dev/null
    mv -f ~/.gtkrc-2.0-kde4 ~/.config/gtkrc-2.0-kde4.bak > /dev/null
  fi
fi

if [ -e install-terminal-theme ]; then
  install-terminal-theme > /dev/null
fi

if [ -e dotfile-system-prune ]; then
  dotfile-system-prune > /dev/null
fi

. "$HOME/.bashrc"
