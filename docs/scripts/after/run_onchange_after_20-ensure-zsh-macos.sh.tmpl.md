---
title: macOS Ensure ZSH Default Shell
description: Ensures ZSH is configured to be used as the default command-line shell
sidebar_label: 20 macOS Ensure ZSH Default Shell
slug: /scripts/after/run_onchange_after_20-ensure-zsh-macos.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_20-ensure-zsh-macos.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_20-ensure-zsh-macos.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_20-ensure-zsh-macos.sh.tmpl
---
# macOS Ensure ZSH Default Shell

Ensures ZSH is configured to be used as the default command-line shell

## Overview

This script ensures ZSH is used as the default shell by ensuring it is added to `/etc/shells`. The script
also ensures ZSH is available at `/usr/local/bin/zsh` on ARM64 systems by symlinking the Homebrew ZSH shell
to `/usr/local/bin/zsh` if it is missing.



## Source Code

```
{{- if (ne .host.distro.family "darwin") -}}
#!/usr/bin/env bash
# @file macOS Ensure ZSH Default Shell
# @brief Ensures ZSH is configured to be used as the default command-line shell
# @description
#     This script ensures ZSH is used as the default shell by ensuring it is added to `/etc/shells`. The script
#     also ensures ZSH is available at `/usr/local/bin/zsh` on ARM64 systems by symlinking the Homebrew ZSH shell
#     to `/usr/local/bin/zsh` if it is missing.

{{ includeTemplate "universal/logg" }}

{{- if (not .host.restricted) }}
logg 'Ensuring ZSH is set as the default shell'
if ! grep -qc "/usr/local/bin/zsh" /etc/shells; then
  echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells > /dev/null
fi

{{- if eq .host.arch "arm64" }}
if [[ ! -e /usr/local/bin/zsh ]]; then
  sudo ln -sf /opt/homebrew/bin/zsh /usr/local/bin/zsh
fi
{{- end -}}
{{- end }}
{{ end -}}
```
