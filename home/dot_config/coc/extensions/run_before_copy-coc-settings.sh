#!/usr/bin/env bash

if [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json" ]; then
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions"
  cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.master.json" "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json"
fi
