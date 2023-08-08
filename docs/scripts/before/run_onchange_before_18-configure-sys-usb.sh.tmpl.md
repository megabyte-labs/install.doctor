---
title: Qubes `sys-usb`
description: Enables `sys-usb` and configures it with ideal security settings
sidebar_label: 18 Qubes `sys-usb`
slug: /scripts/before/run_onchange_before_18-configure-sys-usb.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_18-configure-sys-usb.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_18-configure-sys-usb.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_18-configure-sys-usb.sh.tmpl
---
# Qubes `sys-usb`

Enables `sys-usb` and configures it with ideal security settings

## Overview

This script ensures that Qubes uses `sys-usb` for USB connections. It also optimizes the configuration
by applying security configurations that the Qubes documentation recommends.



## Source Code

```
{{- if (eq .host.distro.id "qubes") -}}
#!/usr/bin/env bash
# @file Qubes `sys-usb`
# @brief Enables `sys-usb` and configures it with ideal security settings
# @description
#     This script ensures that Qubes uses `sys-usb` for USB connections. It also optimizes the configuration
#     by applying security configurations that the Qubes documentation recommends.

### Enable sys-usb
logg info 'Modifying Salt configuration to be able to enable sys-usb'
qubesctl top.enabled pillar=True || EXIT_CODE=$?
qubesctl state.highstate || EXIT_CODE=$?
logg info 'Ensuring sys-net-as-usbvm is removed'
qubesctl top.disable qvm.sys-net-as-usbvm pillar=True || EXIT_CODE=$?
logg info 'Ensuring sys-usb is setup and that it is properly configured with the keyboard'
qubesctl state.sls qvm.usb-keyboard

### Configure USB keyboard settings
if [ "{{ .qubes.promptKeyboards }}" = 'true' ]; then
  logg info 'Ensure USB keyboards are only allows to connect after prompt is answered'
  logg warn 'This can potentially lock you out if all you have are USB keyboards'
  echo "sys-usb dom0 ask,user=root,default_target=dom0" | sudo tee /etc/qubes-rpc/policy/qubes.InputKeyboard
else
  logg info 'Ensuring USB keyboards can connect without a prompt'
  echo "sys-usb dom0 allow,user=root" | sudo tee /etc/qubes-rpc/policy/qubes.InputKeyboard
fi

### Configure USB mouse settings
logg info 'Ensuring newly connected USB mouse devices are only allowed to connect after a prompt is accepted'
echo "sys-usb dom0 ask,default_target=dom0" | sudo tee /etc/qubes-rpc/policy/qubes.InputMouse
{{ end -}}
```
