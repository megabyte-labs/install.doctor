---
title: NvChad NVIM Customization Symlink
description: Symlinks `${XDG_CONFIG_HOME:-$HOME/.config}/nvim-custom` to the main NVIM configuration
sidebar_label: 08 NvChad NVIM Customization Symlink
slug: /scripts/after/run_onchange_after_08-symlink-custom.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_08-symlink-custom.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_08-symlink-custom.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_08-symlink-custom.sh.tmpl
---
# NvChad NVIM Customization Symlink

Symlinks `${XDG_CONFIG_HOME:-$HOME/.config}/nvim-custom` to the main NVIM configuration

## Overview

NVIM is a visual text editor for the terminal. It is like a fancy, improved version of VIM with compatibility
for the same plugins and some other ones as well. The default configuration of Install Doctor integrates
a well-received and popular shared NVIM configuration called [NvChad](https://github.com/NvChad/NvChad).

To make it easy to update NVIM to the latest version as well as introduce custom configuration parameters for NvChad,
this script symlinks the custom configuration from `${XDG_CONFIG_HOME:-$HOME/.config}/nvim-custom` to `${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lua/custom`
which is the location that NvChad's documentation recommends placing custom settings in.



## Source Code

```
{{- if (ne .host.distro.family "windows") -}}
#!/usr/bin/env bash
# @file NvChad NVIM Customization Symlink
# @brief Symlinks `${XDG_CONFIG_HOME:-$HOME/.config}/nvim-custom` to the main NVIM configuration
# @description
#     NVIM is a visual text editor for the terminal. It is like a fancy, improved version of VIM with compatibility
#     for the same plugins and some other ones as well. The default configuration of Install Doctor integrates
#     a well-received and popular shared NVIM configuration called [NvChad](https://github.com/NvChad/NvChad).
#
#     To make it easy to update NVIM to the latest version as well as introduce custom configuration parameters for NvChad,
#     this script symlinks the custom configuration from `${XDG_CONFIG_HOME:-$HOME/.config}/nvim-custom` to `${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lua/custom`
#     which is the location that NvChad's documentation recommends placing custom settings in.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Symlink custom code for Neovim configuration
if [ ! -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lua/custom" ]; then
    logg info "Linking ${XDG_CONFIG_HOME:-$HOME/.config}/nvim-custom to ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lua/custom"
    logg info "Changes should go in ${XDG_CONFIG_HOME:-$HOME/.config}/nvim-custom"
    ln -s "${XDG_CONFIG_HOME:-$HOME/.config}/nvim-custom" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lua/custom"
else
    logg info "${XDG_CONFIG_HOME:-$HOME/.config}/nvim-custom appears to already be symlinked to ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lua/custom"
fi

{{ end -}}
```
