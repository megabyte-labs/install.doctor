---
title: ZSH Pre-Initialization
description: Ensures ZSH is pre-initialized by invoking ZSH and allowing it to perform "first-run" tasks
sidebar_label: 95 ZSH Pre-Initialization
slug: /scripts/after/run_onchange_after_95-bootstrap-zsh-plugins.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_95-bootstrap-zsh-plugins.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_95-bootstrap-zsh-plugins.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_95-bootstrap-zsh-plugins.sh.tmpl
---
# ZSH Pre-Initialization

Ensures ZSH is pre-initialized by invoking ZSH and allowing it to perform "first-run" tasks

## Overview

This script ensures that the first time you open a ZSH terminal session everything is loaded as fast as possible.
It does this by invoking ZSH in the background during the provisioning process so that "first-run" tasks such
as cache-building are handled ahead of time.



## Source Code

```
{{- if (eq .host.headless true) }}
#!/usr/bin/env bash
# @file ZSH Pre-Initialization
# @brief Ensures ZSH is pre-initialized by invoking ZSH and allowing it to perform "first-run" tasks
# @description
#     This script ensures that the first time you open a ZSH terminal session everything is loaded as fast as possible.
#     It does this by invoking ZSH in the background during the provisioning process so that "first-run" tasks such
#     as cache-building are handled ahead of time.

# .zshrc hash: {{ include (joinPath .chezmoi.homeDir ".zshrc") | sha256sum }}

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Initialize ZSH so plugin bootstrap process is done ahead of time
if command -v zsh > /dev/null; then
  logg info 'Bootstrapping ZSH by running `exec zsh`'
  exec zsh
fi
{{ end -}}
```
