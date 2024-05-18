#!/usr/bin/env bash
# @file NGINX Amplify Join
# @brief Set up NGINX Amplify and joins the cloud monitoring service dashboard
# @description
#     This script installs NGINX Amplify and connects with the user's NGINX Amplify instance, assuming the `NGINX_AMPLIFY_API_KEY`
#     is defined. NGINX Amplify is a free web application that serves as a way of browsing through metrics of all your connected
#     NGINX instances.
#
#     ## Links
#
#     * [NGINX Amplify login](https://amplify.nginx.com/login)
#     * [NGINX Amplify documentation](https://docs.nginx.com/nginx-amplify/#)

if command -v nginx > /dev/null; then
  if [ -d /Applications ] && [ -d /System ]; then
    ### macOS
    logg info 'Skipping installation of NGINX Amplify because macOS is not supported'
    NGINX_CONFIG_DIR=/usr/local/etc/nginx
  else
    ### Linux
    NGINX_CONFIG_DIR=/etc/nginx
    logg info 'Downloading the NGINX Amplify installer script'
    TMP="$(mktemp)"
    curl -sSL https://github.com/nginxinc/nginx-amplify-agent/raw/master/packages/install.sh > "$TMP"
    logg info 'Running the NGINX Amplify setup script'
    API_KEY="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "NGINX_AMPLIFY_API_KEY")) }}{{- includeTemplate "secrets/NGINX_AMPLIFY_API_KEY" | decrypt | trim -}}{{ else }}{{- env "NGINX_AMPLIFY_API_KEY" -}}{{ end }}" sh "$TMP"
  fi
  logg info "Ensuring $NGINX_CONFIG_DIR is present" && sudo mkdir -p "$NGINX_CONFIG_DIR"
  logg info "Copying configuration files from $HOME/.local/etc/nginx to $NGINX_CONFIG_DIR"
  sudo rsync -av "$HOME/.local/etc/nginx" "$NGINX_CONFIG_DIR"
  if [ -d /Applications ] && [ -d /System ]; then
    ### macOS
    if [ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/nginx" ] && [ ! -L "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/nginx" ]; then
      logg info "Removing directory at ${HOMEBREW_PREFIX:-/opt/homebrew}/etc/nginx"
      sudo rm -rf "{HOMEBREW_PREFIX:-/opt/homebrew}/etc/nginx"
      logg info "Symlinking /usr/local/etc/nginx to ${HOMEBREW_PREFIX:-/opt/homebrew}/etc/nginx"
      ln -s /usr/local/etc/nginx "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/nginx"
    else
      logg info "Skipping symlinking of /usr/local/etc/nginx to ${HOMEBREW_PREFIX:-/opt/homebrew}/etc/nginx because directory symlink already appears to be there"
    fi
  fi
fi
