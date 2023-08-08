---
title: VirtualBox Extension Pack
description: Ensures the VirtualBox extension pack is installed.
sidebar_label: 46 VirtualBox Extension Pack
slug: /scripts/after/run_onchange_after_46_virtualbox.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_46_virtualbox.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_46_virtualbox.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_46_virtualbox.sh.tmpl
---
# VirtualBox Extension Pack

Ensures the VirtualBox extension pack is installed.

## Overview

This script ensures the VirtualBox extension pack that corresponds with VirtualBox's version is properly installed.



## Source Code

```
{{- if ne .host.distro.family "windows" -}}
#!/usr/bin/env bash
# @file VirtualBox Extension Pack
# @brief Ensures the VirtualBox extension pack is installed.
# @description
#     This script ensures the VirtualBox extension pack that corresponds with VirtualBox's version is properly installed.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Run logic if VirtualBox is installed
if command -v VirtualBox > /dev/null; then
  ### Install VirtualBox extension pack if it is not installed already
  if [ ! -d /usr/lib/virtualbox/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack ] && [ ! -d /Applications/VirtualBox.app/Contents/MacOS/ExtensionPacks/Oracle_VM_VirtualBox_Extension_Pack ]; then
    logg info 'Acquiring VirtualBox version information'
    VBOX_VERSION="$(VirtualBox --help | head -n 1 | cut -f 6 -d' ')"
    VBOX_VERSION="${VBOX_VERSION//v}"

    ### Set up folders
    # Check for macOS installation before creating ExtensionPacks folder on Linux machines
    if [ ! -d /Applications/VirtualBox.app ]; then
      sudo mkdir -p /usr/lib/virtualbox/ExtensionPacks
    fi
    mkdir -p /tmp/vbox
    cd /tmp/vbox

    ### Download extension pack
    logg info 'Downloading VirtualBox extension pack'
    curl -sSL https://download.virtualbox.org/virtualbox/$VBOX_VERSION/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack \
      -o /tmp/vbox/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack

    ### Install extension pack
    logg info 'Installing VirtualBox extension pack'
    echo 'y' | sudo VBoxManage extpack install --replace /tmp/vbox/Oracle_VM_VirtualBox_Extension_Pack-$VBOX_VERSION.vbox-extpack
    logg success 'Successfully installed VirtualBox extension pack'
  else
    logg info 'VirtualBox Extension pack is already installed'
  fi
else
  logg warn 'VirtualBox is not installed so VirtualBox Extension pack will not be installed'
fi

{{ end -}}
```
