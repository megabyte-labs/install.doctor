---
title: macOS Common Dependencies
description: Ensures common system dependencies are installed via Homebrew on macOS
sidebar_label: 10 macOS Common Dependencies
slug: /scripts/before/run_onchange_before_10-install-darwin-dependencies.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_10-install-darwin-dependencies.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_10-install-darwin-dependencies.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_10-install-darwin-dependencies.sh.tmpl
---
# macOS Common Dependencies

Ensures common system dependencies are installed via Homebrew on macOS

## Overview

This script ensures packages that are commonly used by other packages or needed by Install Doctor, are installed
via Homebrew. The list of packages is defined in `home/.chezmoitemplates/darwin/Brewfile`.



## Source Code

```
{{- if (ne .host.distro.family "darwin") -}}
#!/usr/bin/env bash
# @file macOS Common Dependencies
# @brief Ensures common system dependencies are installed via Homebrew on macOS
# @description
#     This script ensures packages that are commonly used by other packages or needed by Install Doctor, are installed
#     via Homebrew. The list of packages is defined in `home/.chezmoitemplates/darwin/Brewfile`.

# darwin/Brewfile hash: {{ include (joinPath ".chezmoitemplates" "darwin" "Brewfile") | sha256sum }}

{{ includeTemplate "universal/profile-before" }}
{{ includeTemplate "universal/logg-before" }}

if command -v brew > /dev/null; then
  logg 'Installing base dependencies for macOS using brew bundle'
  logg info 'Dependencies: age asdf jq node glow go go-task/tap/go-task gnupg gum m-cli progress volta yq m-cli yq zx'
  logg info 'GNU compatibility dependencies: coreutils findutils'

  brew bundle --verbose --no-lock --file=/dev/stdin <<EOF
  {{ includeTemplate "darwin/Brewfile" . -}}
  EOF
else
  logg error 'brew was not found in the PATH'
fi
{{ end -}}
```
