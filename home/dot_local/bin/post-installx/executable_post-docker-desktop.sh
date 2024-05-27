#!/usr/bin/env bash
# @file DockerHub Login
# @brief Logs into DockerHub for Docker Desktop
# @description
#     This script logs into DockerHub so that Docker Desktop is pre-authenticated. This
#     functionality requires that the `DOCKERHUB_USER` be passed in as an environment variable (or
#     directly editted in the `~/.config/chezmoi/chezmoi.yaml` file) and that the `DOCKERHUB_TOKEN`
#     be passed in as a secret (either via the encrypted secret method or passed in as an environment
#     variable).

set -euo pipefail

if command -v docker > /dev/null; then
  ### Acquire DOCKERHUB_TOKEN
  get-secret --exists DOCKERHUB_TOKEN || exit 1

  ### Acquire DOCKERHUB_USER
  if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml" ]; then
    DOCKERHUB_USER="$(yq '.data.user.docker.username' ~/.config/chezmoi/chezmoi.yaml)"
  else
    logg error "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml is missing which is required for populating the DOCKERHUB_USER"
    exit 1
  fi

  ### Launch Docker.app
  if [ -d "/Applications/Docker.app" ] || [ -d "$HOME/Applications/Docker.app" ]; then
    logg info 'Ensuring Docker.app is open' && open --background -a Docker --args --accept-license --unattended
  fi

  ### Pre-authenticate with DockerHub
  DOCKERHUB_TOKEN="$(get-secret DOCKERHUB_TOKEN)"
  if [ -n "$DOCKERHUB_TOKEN" ] && [ -n "$DOCKERHUB_USER" ]; then
    logg info 'Headlessly authenticating with DockerHub registry' && echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin > /dev/null && logg success 'Successfully authenticated with DockerHub registry'
  fi
fi

### Symlink on macOS
if [ -d /Applications ] && [ -d /System ]; then
  if [ -S "$HOME/Library/Containers/com.docker.docker/Data/docker.raw.sock" ]; then
    logg info 'Symlinking /var/run/docker.sock to macOS Library location' && sudo ln -s "$HOME/Library/Containers/com.docker.docker/Data/docker.raw.sock" /var/run/docker.sock
  else
    logg info "Skipping symlinking /var/run/docker.sock since $HOME/Library/Containers/com.docker.docker/Data/docker.raw.sock is missing"
  fi
fi
