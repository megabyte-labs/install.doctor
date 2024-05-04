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
  DOCKERHUB_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "DOCKERHUB_TOKEN")) }}{{- includeTemplate "secrets/DOCKERHUB_TOKEN" | decrypt | trim -}}{{ else }}{{- env "DOCKERHUB_TOKEN" -}}{{ end }}"
  DOCKERHUB_USER="{{ .user.docker.username }}"
  if [ -d "/Applications/Docker.app" ] || [ -d "$HOME/Applications/Docker.app" ]; then
    logg info 'Ensuring Docker.app is open' && open --background -a Docker --args --accept-license --unattended
  fi
  logg info 'Headlessly authenticating with DockerHub registry' && echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin > /dev/null && logg success 'Successfully authenticated with DockerHub registry'
fi

### Symlink on macOS
if [ -f "$HOME/Library/Containers/com.docker.docker/Data/docker.raw.sock" ]; then
  logg info 'Symlinking /var/run/docker.sock to macOS Library location' && sudo ln -s "$HOME/Library/Containers/com.docker.docker/Data/docker.raw.sock" /var/run/docker.sock
fi
