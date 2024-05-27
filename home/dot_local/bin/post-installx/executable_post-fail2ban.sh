#!/usr/bin/env bash
# @file Fail2ban Configuration
# @brief Applies the system `fail2ban` jail configuration and then restarts the service
# @description
#     Fail2ban is an SSH security program that temporarily bans IP addresses that could possibly be
#     attempting to gain unauthorized system access. This script applies the "jail" configuration
#     located at `home/private_dot_ssh/fail2ban/` to the system location. It then enables and restarts
#     the `fail2ban` configuration.
#
#     ## Links
#
#     * [`fail2ban` configuration folder](https://github.com/megabyte-labs/install.doctor/tree/master/home/private_dot_ssh/fail2ban)

set -euo pipefail

if command -v fail2ban-client > /dev/null; then
  if [[ ! "$(test -d /proc && grep Microsoft /proc/version > /dev/null)" ]]; then
    if [ -f "$HOME/.ssh/fail2ban/jail.local" ]; then
      ### Linux
      FAIL2BAN_CONFIG=/etc/fail2ban
      if [ -d /Applications ] && [ -d /System ]; then
        ### macOS
        FAIL2BAN_CONFIG=/usr/local/etc/fail2ban
      fi
      sudo mkdir -p "$FAIL2BAN_CONFIG"
      sudo cp -f "$HOME/.ssh/fail2ban/jail.local" "$FAIL2BAN_CONFIG/jail.local"
      if [ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/fail2ban" ] && [ ! -f "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/fail2ban/jail.local" ]; then
        logg info "Symlinking $FAIL2BAN_CONFIG/jail.local to ${HOMEBREW_PREFIX:-/opt/homebrew}/etc/fail2ban/jail.local"
        ln -s "$FAIL2BAN_CONFIG/jail.local" "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/fail2ban/jail.local"
      fi
      if [ -d /Applications ] && [ -d /System ]; then
        ### macOS
        logg info 'Enabling the fail2ban Homebrew service' && sudo brew services restart fail2ban
      else
        ### Linux
        logg info 'Enabling the fail2ban service' && sudo systemctl enable fail2ban
        logg info 'Restarting the fail2ban service' && sudo systemctl restart fail2ban
      fi
    else
      logg info "The $HOME/.ssh/fail2ban/jail.local configuration is missing so fail2ban will not be set up"
    fi
  else
    logg info 'The environment is a WSL environment so the fail2ban sshd_config will be skipped'
  fi
else
  logg info 'The fail2ban-client executable is not available on the system so fail2ban configuration will be skipped'
fi