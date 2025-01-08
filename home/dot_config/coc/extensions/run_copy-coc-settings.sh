#!/usr/bin/env bash

if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json" ]; then
  cp -f "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.master.json" "${XDG_CONFIG_HOME:-$HOME/.config}/coc/extensions/package.json"
fi
