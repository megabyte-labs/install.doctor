#!/usr/bin/env bash
# @file EasyEngine
# @brief Configures EasyEngine to use the CloudFlare API for configuring Let's Encrypt

set -Eeuo pipefail
trap "gum log -sl error 'Script encountered an error!'" ERR

if command -v ee > /dev/null; then
  ### Ensure secrets
  if get-secret --exists CLOUDFLARE_EMAIL CLOUDFLARE_API_KEY; then
    ### Configure EasyEngine
    gum log -sl info 'Configuring EasyEngine with CloudFlare automatic SSL insuance'
    ee config set le-mail "$(get-secret CLOUDFLARE_EMAIL)"
    ee config set cloudflare-api-key "$(get-secret CLOUDFLARE_API_KEY)"
  else
    gum log -sl info 'Skipping automated setup of LetsEncrypt with EasyEngine because either CLOUDFLARE_EMAIL or CLOUDFLARE_API_KEY are not defined'
  fi
fi