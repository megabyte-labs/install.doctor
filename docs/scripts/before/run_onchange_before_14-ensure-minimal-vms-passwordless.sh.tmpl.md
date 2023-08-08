---
title: Qubes Passwordless Templates
description: Ensures the minimal templates defined in `.qubes.templates` in the `home/.chezmoidata.yaml` file are configured to be passwordless
sidebar_label: 14 Qubes Passwordless Templates
slug: /scripts/before/run_onchange_before_14-ensure-minimal-vms-passwordless.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_before_14-ensure-minimal-vms-passwordless.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_before_14-ensure-minimal-vms-passwordless.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_before_14-ensure-minimal-vms-passwordless.sh.tmpl
---
# Qubes Passwordless Templates

Ensures the minimal templates defined in `.qubes.templates` in the `home/.chezmoidata.yaml` file are configured to be passwordless

## Overview

This script runs in dom0 and ensures the templates defined in the `.qubes.templates` data key of `home/.chezmoidata.yaml` all have
the `qubes-core-agent-passwordless-root` package installed so that they can be provisioned headlessly.



## Source Code

```
{{- if (eq .host.distro.id "qubes") -}}
#!/usr/bin/env bash
# @file Qubes Passwordless Templates
# @brief Ensures the minimal templates defined in `.qubes.templates` in the `home/.chezmoidata.yaml` file are configured to be passwordless
# @description
#     This script runs in dom0 and ensures the templates defined in the `.qubes.templates` data key of `home/.chezmoidata.yaml` all have
#     the `qubes-core-agent-passwordless-root` package installed so that they can be provisioned headlessly.

### Ensure Qubes minimal templates have passwordless sudo
for TEMPLATE of {{ .qubes.templates | toString | replace "[" "" | replace "]" "" }}; do
  if [[ "$TEMPLATE" == *'-minimal' ]]; then
    if [[ "$TEMPLATE" == 'debian'* ]] || [[ "$TEMPLATE" == 'ubuntu'* ]]; then
      logg info "Installing qubes-core-agent-passwordless-root on $TEMPLATE"
      qvm-run -u root "$TEMPLATE" apt-get update
      qvm-run -u root "$TEMPLATE" apt-get install -y qubes-core-agent-passwordless-root
    elif [[ "$TEMPLATE" == 'fedora'* ]]; then
      logg info "Installing qubes-core-agent-passwordless-root on $TEMPLATE"
      qvm-run -u root "$TEMPLATE" dnf install -y qubes-core-agent-passwordless-root
    fi
  fi
done
{{ end -}}
```
