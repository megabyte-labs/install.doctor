#!/usr/bin/env bash
# @file DockerHub Login
# @brief Logs into DockerHub for Docker Desktop
# @description
#     This script logs into DockerHub so that Docker Desktop is pre-authenticated. This
#     functionality requires that the `DOCKERHUB_USER` be passed in as an environment variable (or
#     directly editted in the `~/.config/chezmoi/chezmoi.yaml` file) and that the `DOCKERHUB_TOKEN`
#     be passed in as a secret (either via the encrypted secret method or passed in as an environment
#     variable).

set -Eeuo pipefail
trap "logg error 'Script encountered an error!'" ERR

if command -v docker > /dev/null; then
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

  ### Ensure DOCKERHUB_TOKEN is available
  get-secret --exists DOCKERHUB_TOKEN

  ### Pre-authenticate with DockerHub
  if get-secret --exists DOCKERHUB_TOKEN; then
    if [ "$DOCKERHUB_USER" != 'null' ]; then
      logg info 'Headlessly authenticating with DockerHub registry'
      echo "$(get-secret DOCKERHUB_TOKEN)" | docker login -u "$DOCKERHUB_USER" --password-stdin > /dev/null
      logg success 'Successfully authenticated with DockerHub registry'
    else
      logg info 'Skipping logging into DockerHub because DOCKERHUB_USER is undefined'
    fi
  else
    logg info 'Skipping logging into DockerHub because DOCKERHUB_TOKEN is undefined'
  fi
fi
