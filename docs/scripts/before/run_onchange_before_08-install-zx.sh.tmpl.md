---
title: Node.js / Volta / ZX Install
description: Ensures Node.js, Volta, and ZX are installed prior to Chezmoi applying the dotfile state.
sidebar_label: 08 Node.js / Volta / ZX Install
slug: /scripts/before/run_onchange_before_08-install-zx.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_08-install-zx.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_08-install-zx.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_08-install-zx.sh.tmpl
---
# Node.js / Volta / ZX Install

Ensures Node.js, Volta, and ZX are installed prior to Chezmoi applying the dotfile state.

## Overview

This script ensures required dependencies are installed. These dependencies include:

1. **[Node.js](https://nodejs.org/en)**: JavaScript runtime engine which is installed to ensure any user with Homebrew configured can access Node.js
2. **[Volta](https://volta.sh/)**: Node.js version manager that provides the capability of automatically using `package.json` defined Node.js versions
3. **[ZX](https://github.com/google/zx)**: Used for the script that installs the software packages on any OS

The Volta setup process will ensure that the user is configured to use the latest Node.js version, by default. It then
also ensures the user's `~/.bashrc` and `~/.zshrc` profiles are setup for use with Volta.



## Source Code

```
{{- if (ne .host.distro.family "windows") -}}
#!/usr/bin/env bash
# @file Node.js / Volta / ZX Install
# @brief Ensures Node.js, Volta, and ZX are installed prior to Chezmoi applying the dotfile state.
# @description
#     This script ensures required dependencies are installed. These dependencies include:
#
#     1. **[Node.js](https://nodejs.org/en)**: JavaScript runtime engine which is installed to ensure any user with Homebrew configured can access Node.js
#     2. **[Volta](https://volta.sh/)**: Node.js version manager that provides the capability of automatically using `package.json` defined Node.js versions
#     3. **[ZX](https://github.com/google/zx)**: Used for the script that installs the software packages on any OS
#
#     The Volta setup process will ensure that the user is configured to use the latest Node.js version, by default. It then
#     also ensures the user's `~/.bashrc` and `~/.zshrc` profiles are setup for use with Volta.

{{ includeTemplate "universal/profile-before" }}
{{ includeTemplate "universal/logg-before" }}

### Ensure node is installed
if ! command -v node > /dev/null; then
  if command -v brew; then
    logg 'Installing `node` via Homebrew'
    brew install node || NODE_EXIT_CODE=$?
    if [ -n "$NODE_EXIT_CODE" ]; then
      logg warn 'Calling `brew link --overwrite node` because the Node.js installation seems to be misconfigured'
      brew link --overwrite node
    fi
  else
    logg '`brew` is unavailable. Cannot use it to perform a system installation of node.'
  fi
else
  logg '`node` is available'
fi

### Ensure Volta is installed
if ! command -v volta > /dev/null; then
  if command -v brew > /dev/null; then
    logg 'Installing `volta` via `brew`'
    brew install volta
  else
    logg warn '`brew` needs to be available to install Volta'
  fi
else
  if ! node --version > /dev/null; then
    volta install node@latest
  fi
fi

### Setup Volta
if command -v volta > /dev/null; then
  ### Handle scenario where VOLTA_HOME is not defined yet
  if [ -z "$VOLTA_HOME" ]; then
    logg warn 'VOLTA_HOME is not defined'
    logg info 'Running `volta setup`'
    volta setup
  fi

  ### Source .bashrc
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  else
    logg warn 'Could not find `~/.bashrc` to source the results of `volta setup` from'
  fi

  ### Set PATH and install latest Node.js version via Volta
  export PATH="$VOLTA_HOME/bin:$PATH"
  logg 'Installing `node` via `volta`'
  volta install node@latest
else
  logg warn '`volta` needs to be installed'
fi

### Ensure zx is installed
if ! command -v zx > /dev/null; then
  if command -v volta > /dev/null; then
    logg 'Installing `zx` via `volta`'
    volta install zx
  else
    logg '`volta` is missing'
  fi
else
  logg '`zx` is already installed'
fi
{{ end -}}
```
