---
title: Qubes Mirage Firewall
description: Ensures the Mirage firewall kernel VM is installed in dom0
sidebar_label: 17 Qubes Mirage Firewall
slug: /scripts/before/run_onchange_before_17-install-mirage-firewall.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_17-install-mirage-firewall.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_17-install-mirage-firewall.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_17-install-mirage-firewall.sh.tmpl
---
# Qubes Mirage Firewall

Ensures the Mirage firewall kernel VM is installed in dom0

## Overview

This script first ensures the TemplateVMs are updated and then downloads the Mirage firewall. It configures
Mirage firewall so it can be used as a unikernel firewall VM.



## Source Code

```
{{- if (eq .host.distro.id "qubes") -}}
#!/usr/bin/env bash
# @file Qubes Mirage Firewall
# @brief Ensures the Mirage firewall kernel VM is installed in dom0
# @description
#     This script first ensures the TemplateVMs are updated and then downloads the Mirage firewall. It configures
#     Mirage firewall so it can be used as a unikernel firewall VM.

### Update TemplateVMs
logg info 'Updating TemplateVMs via `qubesctl`'
timeout 900 qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm

### Ensure mirage-firewall kernel folder setup
if [ ! -d /var/lib/qubes/vm-kernels/mirage-firewall ]; then
  logg info 'Creating the /var/lib/qubes/vm-kernels/mirage-firewall directory'
  sudo mkdir -p /var/lib/qubes/vm-kernels/mirage-firewall
fi

### Install the mirage-firewall kernel
if [ ! -f /var/lib/qubes/vm-kernels/mirage-firewall/vmlinuz ]; then
  logg info 'Downloading the pre-compiled mirage firewall kernel in the {{ .qubes.provisionVM }} VM'
  qvm-run provision 'curl -sSL {{ .qubes.mirageUrl }} > ~/Downloads/mirage-firewall.tar.gz && tar xjf ~/Downloads/mirage-firewall.tar.gz -C ~/Downloads'
  logg info 'Transferring mirage-firewall kernel to dom0 from the {{ .qubes.provisionVM }} VM'
  qvm-run --pass-io {{ .qubes.provisionVM }} 'cat /home/user/Downloads/mirage-firewall/vmlinuz' > /var/lib/qubes/vm-kernels/mirage-firewall/vmlinuz
fi

### Create dummy initrmfs for the mirage-firewall kernel
if [ ! -f/var/lib/qubes/vm-kernels/mirage-firewall/initramfs ]; then
  logg info 'Adding dummy initrmfs file to the mirage-firewall kernel folder'
  gzip -n9 < /dev/null > /var/lib/qubes/vm-kernels/mirage-firewall/initramfs
fi
{{ end -}}
```
