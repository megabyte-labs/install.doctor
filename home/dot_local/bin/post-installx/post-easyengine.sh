#!/usr/bin/env bash
# @file EasyEngine
# @brief Configures EasyEngine to use the CloudFlare API for configuring Let's Encrypt

if command -v ee > /dev/null; then
  if [ -n "$CLOUDFLARE_EMAIL" ] && [ -n "$CLOUDFLARE_API_KEY" ]; then
    ee config set le-mail "$CLOUDFLARE_EMAIL"
    ee config set cloudflare-api-key "$CLOUDFLARE_API_KEY"
  fi
fi