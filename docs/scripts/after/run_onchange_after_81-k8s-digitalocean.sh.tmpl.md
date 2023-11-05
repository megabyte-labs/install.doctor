---
title: DigitalOcean Kubernetes
description: Connects to DigitalOcean Kubernetes cluster
sidebar_label: 81 DigitalOcean Kubernetes
slug: /scripts/after/run_onchange_after_81-k8s-digitalocean.sh.tmpl
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/.chezmoiscripts/universal/run_onchange_after_81-k8s-digitalocean.sh.tmpl
scriptLocation: https://github.com/megabyte-labs/install.doctor/raw/master/home/.chezmoiscripts/universal/run_onchange_after_81-k8s-digitalocean.sh.tmpl
repoLocation: home/.chezmoiscripts/universal/run_onchange_after_81-k8s-digitalocean.sh.tmpl
---
# DigitalOcean Kubernetes

Connects to DigitalOcean Kubernetes cluster

## Overview

This script runs when `DIGITALOCEAN_ACCESS_TOKEN` is defined as an environment variable or as an encrypted key (see
[Secrets documentation](https://install.doctor/docs/customization/secrets#encrypted-secrets)). If the check passes,
then the script ensures the DigitalOcean CLI is installed (i.e. `doctl`). Then, it uses `doctl` to connect to the Kubernetes
cluster defined by the the configuration stored under `.user.digitalOceanClusterId` in `home/.chezmoi.yaml.tmpl`.



## Source Code

```
{{- if (and (stat (joinPath .host.home ".config" "age" "chezmoi.txt")) (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "DIGITALOCEAN_ACCESS_TOKEN")) (env "DIGITALOCEAN_ACCESS_TOKEN")) -}}
#!/usr/bin/env bash
# @file DigitalOcean Kubernetes
# @brief Connects to DigitalOcean Kubernetes cluster
# @description
#     This script runs when `DIGITALOCEAN_ACCESS_TOKEN` is defined as an environment variable or as an encrypted key (see
#     [Secrets documentation](https://install.doctor/docs/customization/secrets#encrypted-secrets)). If the check passes,
#     then the script ensures the DigitalOcean CLI is installed (i.e. `doctl`). Then, it uses `doctl` to connect to the Kubernetes
#     cluster defined by the the configuration stored under `.user.digitalOceanClusterId` in `home/.chezmoi.yaml.tmpl`.

{{ includeTemplate "universal/profile" }}
{{ includeTemplate "universal/logg" }}

### Ensure `DIGITALOCEAN_ACCESS_TOKEN` is defined (used for headlessly connecting to the k8s cluster)
export DIGITALOCEAN_ACCESS_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "DIGITALOCEAN_ACCESS_TOKEN")) }}{{ includeTemplate "secrets/DIGITALOCEAN_ACCESS_TOKEN" | decrypt }}{{ else }}{{ env "DIGITALOCEAN_ACCESS_TOKEN" }}{{ end }}"

if [ -n "$DIGITALOCEAN_ACCESS_TOKEN" ] && [ -n '{{ .user.digitalOceanClusterId }}' ]; then
    ### Ensure DigitalOcean CLI is instaled
    if ! command -v doctl > /dev/null; then
        logg info 'doctl is missing - installing via Homebrew'
        brew install doctl
    fi

    ### Connect to the k8s cluster with `doctl`
    logg info 'Connecting to the DigitalOcean k8s cluster with doctl'
    doctl kubernetes cluster kubeconfig save {{ .user.digitalOceanClusterId }}
else
    logg info 'Skipping connecting to the DigitalOcean k8s cluster because either the DIGITALOCEAN_ACCESS_TOKEN or the .user.digitalOceanClusterId is not defined'
fi

{{ end -}}
```
