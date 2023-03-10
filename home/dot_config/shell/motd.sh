#!/usr/bin/env sh

### MOTD
# Add file named .hushlogin in the user's home directory to disable the MOTD
if [ "$BASH_SUPPORT" = 'true' ] && [ ! -f ~/.hushlogin ] && [ "$SHLVL" -eq 1 ]; then
  if [ -f "$HOME/.local/scripts/motd.bash" ] && { [ -n "$SSH_CONNECTION" ] && [[ $- == *i* ]]; } || command -v qubes-vmexec > /dev/null || command -v qubes-dom0-update > /dev/null || { [ -d /Applications ] && [ -d /System ]; }; then
    if { [ -z "$MOTD" ] || [ "$MOTD" -ne 0 ]; } && [[ "$(hostname)" != *'-minimal' ]]; then
      . "$HOME/.local/scripts/motd.bash"
      # TODO - -- services
      if [ -n "$SSH_CONNECTION" ]; then
        # SSH
        bash_motd --banner --processor --memory --diskspace --docker --updates --letsencrypt --login
      elif command -v qubes-vmexec > /dev/null; then
        # Qubes AppVM
        bash_motd --banner --memory --diskspace --docker --updates
      elif command -v qubes-dom0-update > /dev/null; then
        # Qubes dom0
        bash_motd --banner --updates
      elif [ -d /Applications ] && [ -d /System ]; then
        # macOS
        bash_motd --banner
      else
        bash_motd --banner --processor --memory --diskspace --docker --updates --letsencrypt --login
      fi
    fi
  fi
fi
