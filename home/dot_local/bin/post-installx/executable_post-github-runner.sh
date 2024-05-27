#!/usr/bin/env bash
# @file GitHub Runner Registration
# @brief Registers a GitHub action runner with GitHub
# @description
#     This script registers the host as a self-hosted GitHub runner with scope set
#     in the `.user.github.runnerOrg` input in the `.chezmoi.yaml.tmpl` file. If your organization is `megabyte-labs`, then
#     the value of `.user.github.runnerOrg` should be `megabyte-labs`. A self-hosted runner is an application
#     that that allows you to run tasks from GitHub CI.
#
#     This script adds 3 labels to the runner: self-hosted, _hostname_, and _operating-system family_.
#
#     The script automatically acquires the GitHub Action runner token (as long as you specify your `.user.github.runnerOrg` value in `.chezmoi.yaml.tmpl`).
#     In order to authenticate with GitHub, you should have the `GITHUB_TOKEN` environment variable in place with the appropriate permissions
#     specified when you generate the token.
#
#     ## Links
#
#     * [Secrets / Environment variables documentation](https://install.doctor/docs/customization/secrets)

set -euo pipefail

### Check if GitHub runner is installed
if [ -f "${XDG_DATA_HOME:-$HOME/.local/share}/github-runnerconfig.sh" ]; then
  if [ -f "${XDG_DATA_HOME:-$HOME/.local/share}/github-runner/.runner" ]; then
    logg info "GitHub Actions runner is already configured (${XDG_DATA_HOME:-$HOME/.local/share}/github-runner/.runner file is present)"
  else
    logg info 'Creating runner configuration'
    ### Configure labels
    HOST_DISTRO_FAMILY="$(yq '.data.host.distro.family' "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml")"
    HOST_DISTRO_ID="$(yq '.data.host.distro.id' "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml")"
    LABELS="self-hosted,$(yq '.data.host.hostname' "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml"),$HOST_DISTRO_FAMILY"
    if [ "$HOST_DISTRO_FAMILY" != "$HOST_DISTRO_ID" ]; then
      LABELS="${LABELS},$HOST_DISTRO_ID"
    fi
    if command -v VirtualBox > /dev/null; then
      LABELS="${LABELS},virtualbox"
    fi
    if command -v docker > /dev/null; then
      LABELS="${LABELS},docker"
    fi
    if [ -n "$GITHUB_TOKEN" ]; then
      if command -v jq > /dev/null; then
        ### Acquire token
        logg info 'Acquiring runner token'
        RUNNER_ORG="$(yq '.data.user.github.runnerOrg' "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.yaml")"
        RUNNER_TOKEN="$(curl -sSL -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/orgs/${RUNNER_ORG}/actions/runners/registration-token | jq -r '.token')"
        ### Generate the configuration
        logg info "Joining GitHub runner to https://github.com/${RUNNER_ORG}"
        "${XDG_DATA_HOME:-$HOME/.local/share}/github-runner/config.sh" --unattended --url https://github.com/${RUNNER_ORG} --token "$RUNNER_TOKEN" --labels "$LABELS" || EXIT_CODE=$?
        if [ -n "$EXIT_CODE" ]; then
          logg error 'GitHub runner configuration failed' && exit 1
        fi
        ### Install / start the service
        logg info 'Configuring runner service'
        "${XDG_DATA_HOME:-$HOME/.local/share}/github-runner/svc.sh" install && logg success 'Successfully installed the GitHub Actions runner service'
        logg info 'Starting runner service'
        "${XDG_DATA_HOME:-$HOME/.local/share}/github-runner/svc.sh" start && logg success 'Started the GitHub Actions runner service'
      else
        logg warn 'jq is required by the GitHub runner configuration script'
      fi
    else
      logg warn 'The GITHUB_TOKEN environment variable is not present'
    fi
  fi
else
  logg info "The GitHub Actions runner installation is not present at ${XDG_DATA_HOME:-$HOME/.local/share}/github-runner"
fi
