---
title: Qubes Passwordless Templates
description: Ensures unofficial templates defined in `.qubes.templatesUnofficial` in the `home/.chezmoidata.yaml` file are made available to dom0
sidebar_label: 15 Qubes Passwordless Templates
slug: /scripts/before/run_onchange_before_15-install-unofficial-templates.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_15-install-unofficial-templates.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_15-install-unofficial-templates.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_15-install-unofficial-templates.sh.tmpl
---
# Qubes Passwordless Templates

Ensures unofficial templates defined in `.qubes.templatesUnofficial` in the `home/.chezmoidata.yaml` file are made available to dom0

## Overview

This script downloads unofficial templates defined in the `.qubes.templatesUnofficial` data key of `home/.chezmoidata.yaml` and then
installs them in dom0 after transferring the downloads from a temporary Qube used for downloading the templates.



## Source Code

```
{{- if (eq .host.distro.id "qubes") -}}
#!/usr/bin/env bash
# @file Qubes Passwordless Templates
# @brief Ensures unofficial templates defined in `.qubes.templatesUnofficial` in the `home/.chezmoidata.yaml` file are made available to dom0
# @description
#     This script downloads unofficial templates defined in the `.qubes.templatesUnofficial` data key of `home/.chezmoidata.yaml` and then
#     installs them in dom0 after transferring the downloads from a temporary Qube used for downloading the templates.

### Ensure unofficial templates are installed
for TEMPLATE_URL of {{ .qubes.templatesUnofficial | toString | replace "[" "" | replace "]" "" }}; do
  logg info "Template URL: $TEMPLATE_URL"
  TEMPLATE="$(echo "$TEMPLATE_URL" | sed 's/^.*\/\(.*\)-\d+.\d+.\d+-\d+.noarch.rpm$/\1/')"
  logg info "Template: $TEMPLATE"
  FILE="$(echo "$TEMPLATE_URL" | sed 's/^.*\/\(.*-\d+.\d+.\d+-\d+.noarch.rpm\)$/\1/')"
  logg info "File: $FILE"
  if [ ! -f "/var/lib/qubes/vm-templates/$TEMPLATE" ]; then
    logg info "Downloading the unofficial $TEMPLATE TemplateVM via {{ .qubes.provisionVM }}"
    qvm-run --pass-io "{{ .qubes.provisionVM }}" "curl -sSL "$TEMPLATE_URL" -o "/home/Downloads/$FILE""
    logg info "Transferring the image to dom0"
    qvm-run --pass-io "{{ .qubes.provisionVM }}" "cat /home/Downloads/$FILE" > "/tmp/$FILE"
    logg info "Installing the TemplateVM via dnf"
    sudo dnf install --nogpgcheck "/tmp/$FILE"
    rm -f "/tmp/$FILE"
  else
    logg info "$TEMPLATE is already installed"
  fi
done
{{ end -}}
```
