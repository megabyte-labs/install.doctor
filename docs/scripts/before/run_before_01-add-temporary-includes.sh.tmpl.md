---
title: Logger Setup
description: Ensures environment variables are utilized and that logging functionality is available to Install Doctor
sidebar_label: 01 Logger Setup
slug: /scripts/before/run_before_01-add-temporary-includes.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_before_01-add-temporary-includes.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_before_01-add-temporary-includes.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_before_01-add-temporary-includes.sh.tmpl
---
# Logger Setup

Ensures environment variables are utilized and that logging functionality is available to Install Doctor

## Overview

This script pipes environment variables and a logger function to a temporary file that is included by other scripts.
It is included as a temporary external file to aid in debugging since if the included files were inlined in scripts
the scripts would be verbose when debugging.



## Source Code

```
{{- if (ne .host.distro.family "windows") -}}
#!/usr/bin/env bash
# @file Logger Setup
# @brief Ensures environment variables are utilized and that logging functionality is available to Install Doctor
# @description
#     This script pipes environment variables and a logger function to a temporary file that is included by other scripts.
#     It is included as a temporary external file to aid in debugging since if the included files were inlined in scripts
#     the scripts would be verbose when debugging.

### Ensure /tmp/tmp-profile is created
# Add pre-scaffolding profile to /tmp/tmp-profile so it's easier to navigate through scripts
cat <<'EOF' > /tmp/tmp-profile
{{ includeTemplate "universal/profile-inline" }}
EOF

### Ensure /tmp/tmp-logg is created and owned by root
# Add pre-scaffolding /tmp/tmp-logg
cat <<'EOF' > /tmp/tmp-logg
{{ includeTemplate "universal/logg-inline" }}
EOF

{{ end -}}
```
