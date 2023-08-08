---
title: Qubes Update TemplateVMs
description: Ensures the templates available in dom0 are all up-to-date
sidebar_label: 16 Qubes Update TemplateVMs
slug: /scripts/before/run_onchange_before_16-update-template-vms.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_16-update-template-vms.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_16-update-template-vms.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_16-update-template-vms.sh.tmpl
---
# Qubes Update TemplateVMs

Ensures the templates available in dom0 are all up-to-date

## Overview

This script ensures the dom0 Qube VM templates are all up-to-date by using the recommended `qubesctl` command.
Due to issues with the Whonix Qubes, the update process will timeout after 15 minutes which should be enough time
for the updates to finish.



## Source Code

```
{{- if (eq .host.distro.id "qubes") -}}
#!/usr/bin/env bash
# @file Qubes Update TemplateVMs
# @brief Ensures the templates available in dom0 are all up-to-date
# @description
#     This script ensures the dom0 Qube VM templates are all up-to-date by using the recommended `qubesctl` command.
#     Due to issues with the Whonix Qubes, the update process will timeout after 15 minutes which should be enough time
#     for the updates to finish.

### Update TemplateVMs
logg info 'Updating TemplateVMs via `qubesctl`'
timeout 900 qubesctl --show-output --skip-dom0 --templates state.sls update.qubes-vm
{{ end -}}
```
