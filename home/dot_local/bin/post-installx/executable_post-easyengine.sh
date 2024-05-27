#!/usr/bin/env bash
# @file EasyEngine
# @brief Configures EasyEngine to use the CloudFlare API for configuring Let's Encrypt

set -euo pipefail

if command -v ee > /dev/null; then
  ### Ensure secrets
  get-secret --exists CLOUDFLARE_EMAIL CLOUDFLARE_API_KEY

  ### Configure EasyEngine
  logg info 'Configuring EasyEngine with CloudFlare automatic SSL insuance'
  ee config set le-mail "$(get-secret CLOUDFLARE_EMAIL)"
  ee config set cloudflare-api-key "$(get-secret CLOUDFLARE_API_KEY)"
fi