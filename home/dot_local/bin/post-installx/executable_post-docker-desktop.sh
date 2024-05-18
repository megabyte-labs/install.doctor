#!/usr/bin/env bash
# @file DockerHub Login
# @brief Logs into DockerHub for Docker Desktop
# @description
#     This script logs into DockerHub so that Docker Desktop is pre-authenticated. This
#     functionality requires that the `DOCKERHUB_USER` be passed in as an environment variable (or
#     directly editted in the `~/.config/chezmoi/chezmoi.yaml` file) and that the `DOCKERHUB_TOKEN`
#     be passed in as a secret (either via the encrypted secret method or passed in as an environment
#     variable).

if command -v docker > /dev/null; then
  ### Acquire DOCKERHUB_TOKEN
  DOCKERHUB_TOKEN_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets/DOCKERHUB_TOKEN"
  if [ -f "$DOCKERHUB_TOKEN_FILE" ]; then
    logg info "Found DOCKERHUB_TOKEN in ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
    if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/age/chezmoi.txt" ]; then
      logg info 'Decrypting DOCKERHUB_TOKEN token with Age encryption key'
      DOCKERHUB_TOKEN="$(cat "$DOCKERHUB_TOKEN_FILE" | chezmoi decrypt)"
    else
      logg warn 'Age encryption key is missing from ~/.config/age/chezmoi.txt'
    fi
  else
    logg warn "DOCKERHUB_TOKEN is missing from ${XDG_DATA_HOME:-$HOME/.local/share}/chezmoi/home/.chezmoitemplates/secrets"
  fi

  ### Acquire DOCKERHUB_USER
  if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml" ]; then
    DOCKERHUB_USER="$(yq '.data.user.docker.username' ~/.config/chezmoi/chezmoi.yaml)"
  else
    logg info "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml is missing which is required for populating the DOCKERHUB_USER"
  fi

  ### Launch Docker.app
  if [ -d "/Applications/Docker.app" ] || [ -d "$HOME/Applications/Docker.app" ]; then
    logg info 'Ensuring Docker.app is open' && open --background -a Docker --args --accept-license --unattended
  fi

  ### Pre-authenticate with DockerHub
  if [ -n "$DOCKERHUB_TOKEN" ] && [ -n "$DOCKERHUB_USER" ]; then
    logg info 'Headlessly authenticating with DockerHub registry' && echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin > /dev/null && logg success 'Successfully authenticated with DockerHub registry'
  fi
fi

### Symlink on macOS
if [ -d /Applications ] && [ -d /System ]; then
  if [ -f "$HOME/Library/Containers/com.docker.docker/Data/docker.raw.sock" ]; then
    logg info 'Symlinking /var/run/docker.sock to macOS Library location' && sudo ln -s "$HOME/Library/Containers/com.docker.docker/Data/docker.raw.sock" /var/run/docker.sock
  else
    logg info "Skipping symlinking /var/run/docker.sock since $HOME/Library/Containers/com.docker.docker/Data/docker.raw.sock is missing"
  fi
fi
