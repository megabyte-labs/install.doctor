---
title: Qubes Install Templates
description: Ensures the templates defined in `.qubes.templates` in the `home/.chezmoidata.yaml` file are installed
sidebar_label: 13 Qubes Install Templates
slug: /scripts/before/run_onchange_before_13-install-official-templates.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_13-install-official-templates.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_13-install-official-templates.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_13-install-official-templates.sh.tmpl
---
# Qubes Install Templates

Ensures the templates defined in `.qubes.templates` in the `home/.chezmoidata.yaml` file are installed

## Overview

This script runs in dom0 and ensures the templates defined in `home/.chezmoidata.yaml` are all installed.



## Source Code

```
{{- if (eq .host.distro.id "qubes") -}}
#!/usr/bin/env bash
# @file Qubes Install Templates
# @brief Ensures the templates defined in `.qubes.templates` in the `home/.chezmoidata.yaml` file are installed
# @description
#     This script runs in dom0 and ensures the templates defined in `home/.chezmoidata.yaml` are all installed.

### Ensure Qubes templates exist and download if they are not present
for TEMPLATE of {{ .qubes.templates | toString | replace "[" "" | replace "]" "" }}; do
  if [ ! -f "/var/lib/qubes/vm-templates/$TEMPLATE" ]; then
    logg info "Installing $TEMPLATE"
    sudo qubes-dom0-update "qubes-template-$TEMPLATE"
  fi
done
{{ end -}}
```
