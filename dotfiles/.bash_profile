# Prefer US English
export LANG="en_US"

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
