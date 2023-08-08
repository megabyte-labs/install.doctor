---
title: SDKMAN Install
description: Ensures SDKMAN is installed.
sidebar_label: 18 SDKMAN Install
slug: /scripts/after/run_onchange_after_18-install-sdkman.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_18-install-sdkman.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_18-install-sdkman.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_18-install-sdkman.sh.tmpl
---
# SDKMAN Install

Ensures SDKMAN is installed.

## Overview

This script ensures SDKMAN (a Java version manager) is installed using the method recommended on [their
website](https://sdkman.io/).



## Source Code

```
#!/usr/bin/env bash
# @file SDKMAN Install
# @brief Ensures SDKMAN is installed.
# @description
#     This script ensures SDKMAN (a Java version manager) is installed using the method recommended on [their
#     website](https://sdkman.io/).

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Ensure SDKMan is installed (https://sdkman.io/)
if [ ! -d "$SDKMAN_DIR" ]; then
  logg info 'Installing SDKMan via `curl -s "https://get.sdkman.io?rcupdate=false`'
  logg info "Install directory: $SDKMAN_DIR"
  curl -s "https://get.sdkman.io?rcupdate=false" | bash
  logg info 'Running `sdk install java`'
  sdk install java
else
  logg info 'SDKMan appears to already be installed.'
fi
```
