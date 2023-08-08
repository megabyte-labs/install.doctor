---
title: Linux VMWare Workstation Install
description: Installs VMWare Workstation Pro on Linux devices, applies a "publicly-retrieved" license key (see disclaimer), and automatically accepts the terms and conditions
sidebar_label: 44 Linux VMWare Workstation Install
slug: /scripts/after/run_onchange_after_44-vmware-install.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_44-vmware-install.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_44-vmware-install.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_44-vmware-install.sh.tmpl
---
# Linux VMWare Workstation Install

Installs VMWare Workstation Pro on Linux devices, applies a "publicly-retrieved" license key (see disclaimer), and automatically accepts the terms and conditions

## Overview

This script ensures the user included `vmware` in their software installation list. It then checks for presence of the `vmware` utility. If it is not present, then the script:

1. Downloads the [VMWare Workstation Pro](https://www.vmware.com/content/vmware/vmware-published-sites/us/products/workstation-pro.html.html) Linux installer
2. Installs VMWare Workstation Pro
3. Passes options to the installation script that automatically apply a publicly retrived license key and accept the Terms & Conditions

**DISCLAIMER:** If you plan on using VMWare Workstation for anything but evaluation purposes, then we highly suggest purchasing a copy
of VMWare Workstation. The "publicly-retrived" license keys are scattered throughout GitHub and we are not exactly
sure why they work. You can pass in your own key by utilizing the `VMWARE_WORKSTATION_LICENSE_KEY` environment variable. More details on
using environment variables or repository-housed encrypted secrets can be found in our [Secrets documentation](https://install.doctor/docs/customization/secrets).

## VMWare on macOS

This script only installs VMWare Workstation on Linux. The macOS-variant titled VMWare Fusion can be installed using a Homebrew
cask so a "work-around" script does not have to be used.

## VMWare vs. Parallels vs. VirtualBox vs. KVM vs. Hyper-V

There are a handful of VM virtualization providers you can choose from. VMWare is a nice compromise between OS compatibility and performance.
Parallels, on the hand, might be better for macOS since it is designed specifically for macOS. Finally, VirtualBox is a truly free,
open-source option that does not come with the same optimizations that VMWare and Parallels provide.

Other virtualization options include KVM (Linux / macOS) and Hyper-V (Windows). These options are better used for headless
systems.

## Links

* [VMWare Workstation homepage](https://www.vmware.com/content/vmware/vmware-published-sites/us/products/workstation-pro.html.html)



## Source Code

```
{{- if eq .host.distro.family "linux" -}}
{{- $softwareGroup := nospace (cat "_" .host.softwareGroup) -}}
{{- $softwareList := list (index .softwareGroups $softwareGroup | toString | replace "[" "" | replace "]" "") | uniq | join " " -}}
{{- if (contains " vmware" $softwareList) -}}
#!/usr/bin/env bash
# @file Linux VMWare Workstation Install
# @brief Installs VMWare Workstation Pro on Linux devices, applies a "publicly-retrieved" license key (see disclaimer), and automatically accepts the terms and conditions
# @description
#     This script ensures the user included `vmware` in their software installation list. It then checks for presence of the `vmware` utility. If it is not present, then the script:
#
#     1. Downloads the [VMWare Workstation Pro](https://www.vmware.com/content/vmware/vmware-published-sites/us/products/workstation-pro.html.html) Linux installer
#     2. Installs VMWare Workstation Pro
#     3. Passes options to the installation script that automatically apply a publicly retrived license key and accept the Terms & Conditions
#
#     **DISCLAIMER:** If you plan on using VMWare Workstation for anything but evaluation purposes, then we highly suggest purchasing a copy
#     of VMWare Workstation. The "publicly-retrived" license keys are scattered throughout GitHub and we are not exactly
#     sure why they work. You can pass in your own key by utilizing the `VMWARE_WORKSTATION_LICENSE_KEY` environment variable. More details on
#     using environment variables or repository-housed encrypted secrets can be found in our [Secrets documentation](https://install.doctor/docs/customization/secrets).
#
#     ## VMWare on macOS
#
#     This script only installs VMWare Workstation on Linux. The macOS-variant titled VMWare Fusion can be installed using a Homebrew
#     cask so a "work-around" script does not have to be used.
#
#     ## VMWare vs. Parallels vs. VirtualBox vs. KVM vs. Hyper-V
#
#     There are a handful of VM virtualization providers you can choose from. VMWare is a nice compromise between OS compatibility and performance.
#     Parallels, on the hand, might be better for macOS since it is designed specifically for macOS. Finally, VirtualBox is a truly free,
#     open-source option that does not come with the same optimizations that VMWare and Parallels provide.
#
#     Other virtualization options include KVM (Linux / macOS) and Hyper-V (Windows). These options are better used for headless
#     systems.
#
#     ## Links
#
#     * [VMWare Workstation homepage](https://www.vmware.com/content/vmware/vmware-published-sites/us/products/workstation-pro.html.html)


{{- $secretKey := "" -}}
{{- if (stat (joinPath (.chezmoi.sourceDir ".chezmoitemplates" "secrets" "VMWARE_WORKSTATION_LICENSE_KEY"))) -}}
{{-   $secretKey = (default "4C21U-2KK9Q-M8130-4V2QH-CF810" (includeTemplate "secrets/VMWARE_WORKSTATION_LICENSE_KEY" | decrypt)) -}}
{{- else -}}
{{-   $secretKey = (default "4C21U-2KK9Q-M8130-4V2QH-CF810" (env "VMWARE_WORKSTATION_LICENSE_KEY")) -}}
{{- end }}

# Source: https://gist.github.com/PurpleVibe32/30a802c3c8ec902e1487024cdea26251
# key: {{ $secretKey }}

{{ includeTemplate "universal/profile-before" }}
{{ includeTemplate "universal/logg-before" }}

### Install VMware Workstation
if ! command -v vmware > /dev/null; then
  ### Download VMWare Workstation
  logg info 'VMware Workstation is not installed'
  VMWARE_WORKSTATION_URL=https://www.vmware.com/go/getworkstation-linux
  VMWARE_WORKSTATION_DIR=/tmp/workstation-downloads
  mkdir -p $VMWARE_WORKSTATION_DIR
  logg info 'Downloading VMware Workstation Installer'
  curl -sSLA "Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20220101 Firefox/102.0" "$VMWARE_WORKSTATION_URL" -o "$VMWARE_WORKSTATION_DIR/tryworkstation-linux-64.sh"

  ### Register product key / license
  VMWARE_WORKSTATION_LICENSE_KEY='{{- $secretKey -}}'
  if [ -n "$VMWARE_WORKSTATION_LICENSE_KEY" ]; then
    logg info 'Registering VMware Workstation Pro license with serial number'
    sudo "$VMWARE_WORKSTATION_DIR/tryworkstation-linux-64.sh" --eulas-agreed --console --required --set-setting vmware-workstation serialNumber "$VMWARE_WORKSTATION_LICENSE_KEY"
  else
    logg info 'Agreeing to VMWare Workstation Pro license (without serial number)'
    sudo "$VMWARE_WORKSTATION_DIR/tryworkstation-linux-64.sh" --eulas-agreed --console --required
  fi
  logg success 'VMware Workstation installed successfully'
else
  logg info 'VMware Workstation is already installed'
fi
{{ end -}}
{{ end -}}
```
