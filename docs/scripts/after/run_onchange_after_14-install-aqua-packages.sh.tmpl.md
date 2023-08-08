---
title: Aqua Initialization
description: Updates and installs any Aqua dependencies that are defined in Aqua's configuration file.
sidebar_label: 14 Aqua Initialization
slug: /scripts/after/run_onchange_after_14-install-aqua-packages.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_14-install-aqua-packages.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_14-install-aqua-packages.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_14-install-aqua-packages.sh.tmpl
---
# Aqua Initialization

Updates and installs any Aqua dependencies that are defined in Aqua's configuration file.

## Overview

This script updates Aqua and then installs any Aqua dependencies that are defined.



## Source Code

```
#!/usr/bin/env bash
# @file Aqua Initialization
# @brief Updates and installs any Aqua dependencies that are defined in Aqua's configuration file.
# @description
#     This script updates Aqua and then installs any Aqua dependencies that are defined.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

if command -v aqua > /dev/null; then
  logg info 'Updating Aqua'
  aqua update-aqua
  logg info 'Installing Aqua dependencies (if any are defined)'
  aqua install -a
else
  logg info 'Skipping aqua install script because aqua was not installed'
fi
```
