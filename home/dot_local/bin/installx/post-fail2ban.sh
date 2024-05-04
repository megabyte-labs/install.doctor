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

### Notify of script start
logg info 'Configuring fail2ban'

### Restart fail2ban
function restartFailToBan() {
  if [ -d /Applications ] && [ -d /System ]; then
    ### macOS
    logg info 'Enabling the fail2ban Homebrew service'
    brew services restart fail2ban
  else
    # Linux
    logg info 'Enabling the fail2ban service'
    sudo systemctl enable fail2ban
    logg info 'Restarting the fail2ban service'
    sudo systemctl restart fail2ban
  fi
}

### Update the jail.local file if environment is not WSL
logg info 'Checking if script is being run in WSL environment'
if [[ ! "$(test -d /proc && grep Microsoft /proc/version > /dev/null)" ]]; then
  if [ -d /etc/fail2ban ]; then
    logg info 'Copying ~/.ssh/fail2ban/jail.local to /etc/fail2ban/jail.local'
    sudo cp -f "$HOME/.ssh/fail2ban/jail.local" /etc/fail2ban/jail.local
    restartFailToBan
  elif [ -d /usr/local/etc/fail2ban ]; then
    logg info 'Copying ~/.ssh/fail2ban/jail.local to /usr/local/etc/fail2ban/jail.local'
    sudo cp -f "$HOME/.ssh/fail2ban/jail.local" /usr/local/etc/fail2ban/jail.local
    restartFailToBan
  elif [ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/fail2ban" ]; then
    logg info "Copying ~/.ssh/fail2ban/jail.local to ${HOMEBREW_PREFIX:-/opt/homebrew}/etc/fail2ban/jail.local"
    sudo cp -f "$HOME/.ssh/fail2ban/jail.local" "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/fail2ban/jail.local"
    restartFailToBan
  else
    logg warn 'The /etc/fail2ban (Linux), the /usr/local/etc/fail2ban, and the ${HOMEBREW_PREFIX:-/opt/homebrew}/etc/fail2ban (macOS) folder do not exist'
  fi
else
  logg info 'Skipping sshd_config application since environment is WSL'
fi
