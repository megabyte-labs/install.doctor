#!/usr/bin/env bash
# @file git-o-matic Configuration
# @brief Starts service on Linux systems to monitor Git repositories
# @description
#     git-o-matic is a tool to monitor git repositories and automatically pull/push changes. Multiple repositories can be
#     monitored by running multiple instances of `gitomatic`. This script supports SSH Key based authentication only.
#
#     If the `gitomatic` program is installed, this script creates and starts a Systemd service to monitor the repositories.
#     The repositories are cloned if they are not available at the path.
#
#     ## Notes
#     * The author name and email address for commits are the same as `.user.name` and `.user.email` (configured in the `home/.chezmoi.yaml.tmpl` file)
#     * `gitomatic` automatically pushes and pulls changes. The script does not change this behavior
#     * `gitomatic` checks for changes every minute. This setting is not changed by this script
#     * The User's default SSH Key is used for authentication
#
#     ## Links
#
#     * [gitomatic GitHub repository](https://github.com/muesli/gitomatic/)
#     * [Systemd Unit file](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/gitomatic/gitomatic.service.tmpl)
#     * [Helper script](https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_local/bin/executable_gitomatic_service.tmpl

set -euo pipefail

if command -v gitomatic > /dev/null; then
  ### Copy bin to /usr/local/bin
  logg info "Copying $HOME/.local/bin/gitomatic-service to /usr/local/bin/gitomatic-service" && sudo cp -f "$HOME/.local/bin/gitomatic-service" /usr/local/bin/gitomatic-servic
  ### Copy gitomatic to global directory
  if [ ! -f /usr/local/bin/gitomatic ]; then
    logg info 'Copying gitomatic executable to /usr/local/bin/gitomatic' && sudo cp -f "$(which gitomatic)" /usr/local/bin/gitomatic
  f
  if [ -d /Applications ] && [ -d /System ]; then
    ### macOS
    logg info 'Copying gitomatic plist file to /Library/LaunchDaemons' && sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/gitomatic/com.github.muesli.gitomatic.plist" /Library/LaunchDaemons/com.github.muesli.gitomatic.plist
    if ! sudo launchctl list | grep 'gitomatic' > /dev/null; then
      logg info 'Running sudo launchctl load /Library/LaunchDaemons/com.github.muesli.gitomatic.plist' && sudo launchctl load /Library/LaunchDaemons/com.github.muesli.gitomatic.plist
      logg info 'Running sudo launchctl start /Library/LaunchDaemons/com.github.muesli.gitomatic.plist' && sudo launchctl start /Library/LaunchDaemons/com.github.muesli.gitomatic.plist
    else
      logg info "gitomatic services appear to already be loaded"
    fi
  else
    ### Linux
    logg info 'Copying gitomatic systemd unit file to /etc/systemd/system/' && sudo cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/gitomatic/gitomatic.service" /etc/systemd/system/gitomatic.service
    logg info 'Reloading systemd daemon' && sudo systemctl daemon-reload
    logg info 'Enabling and starting gitomatic service' && sudo systemctl enable --now gitomatic
  fi
else
  logg info 'gitomatic is not installed or it is not available in PATH'
fi
