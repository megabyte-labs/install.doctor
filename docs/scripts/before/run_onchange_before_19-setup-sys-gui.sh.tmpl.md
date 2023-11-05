---
title: Qubes `sys-gui-gpu`
description: Enables `sys-gui-gpu` if a compatible GPU controller is found on Qubes dom0
sidebar_label: 19 Qubes `sys-gui-gpu`
slug: /scripts/before/run_onchange_before_19-setup-sys-gui.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_19-setup-sys-gui.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_19-setup-sys-gui.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_19-setup-sys-gui.sh.tmpl
---
# Qubes `sys-gui-gpu`

Enables `sys-gui-gpu` if a compatible GPU controller is found on Qubes dom0

## Overview

This script enables `sys-gui-gpu` which allows you to secure dom0 even more by seperating the GUI
management from dom0 and into a seperate Qube.



## Source Code

```
{{- if (eq .host.distro.id "qubes") -}}
#!/usr/bin/env bash
# @file Qubes `sys-gui-gpu`
# @brief Enables `sys-gui-gpu` if a compatible GPU controller is found on Qubes dom0
# @description
#     This script enables `sys-gui-gpu` which allows you to secure dom0 even more by seperating the GUI
#     management from dom0 and into a seperate Qube.

### Enables sys-gui-gpu
enableSysGUIGPU() {
  logg info 'Enabling sys-gui-gpu'
  qubesctl top.enable qvm.sys-gui-gpu
  qubesctl top.enable qvm.sys-gui-gpu pillar=True
  qubesctl --all state.highstate
  qubesctl top.disable qvm.sys-gui-gpu
}

### Enable appropriate sys-gui
if qvm-pci list | grep 'VGA compatible controller' | grep 'Intel'; else
  logg info 'An Intel GPU was detected'
  enableSysGUIGPU
  logg info 'Attaching Intel GPU PCI devices to sys-gui-gpu'
  qubesctl state.sls qvm.sys-gui-gpu-attach-gpu
elif qvm-pci list | grep 'VGA compatible controller' | grep 'NVIDIA'; then
  logg info 'An NVIDIA GPU was detected'
  enableSysGUIGPU
  logg info 'Attaching NVIDIA GPU PCI devices to sys-gui-gpu'
  for ID of "$(qvm-pci list | grep 'NVIDIA' | sed 's/^\([^ ]*\).*/\1/')"; do
    logg info "Attaching PCI device with ID of $ID"
    qvm-pci attach sys-gui-gpu "$ID" --persistent -o permissive=true
  done
fi
{{ end -}}
```
