---
title: Default SSH Key
description: Create a default `id_rsa` SSH key if one is not present in the repository / fork of Install Doctor
sidebar_label: 07 Default SSH Key
slug: /scripts/after/run_onchange_after_07-ensure-private-key.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_07-ensure-private-key.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_07-ensure-private-key.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_07-ensure-private-key.sh.tmpl
---
# Default SSH Key

Create a default `id_rsa` SSH key if one is not present in the repository / fork of Install Doctor

## Overview

This script generates a pair of default `id_rsa` and `id_rsa.pub` keys if one is not already present
on the system after the Install Doctor provisioning process completes. It also ensures the private
key is only readable and writable the provisioning user.



## Source Code

```
#!/usr/bin/env bash
# @file Default SSH Key
# @brief Create a default `id_rsa` SSH key if one is not present in the repository / fork of Install Doctor
# @description
#     This script generates a pair of default `id_rsa` and `id_rsa.pub` keys if one is not already present
#     on the system after the Install Doctor provisioning process completes. It also ensures the private
#     key is only readable and writable the provisioning user.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Ensure id_rsa is present and create one if it does not exist
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
  logg 'Generating missing default private key / public key (~/.ssh/id_rsa)'
  ssh-keygen -b 4096 -t rsa -f "$HOME/.ssh/id_rsa" -q -N ""
  chmod 600 "$HOME/.ssh/id_rsa"
fi
```
