{{- if (stat (joinPath .host.home ".config" "age" "chezmoi.txt")) -}}
#!/usr/bin/env sh

### Ansible
export ANSIBLE_GALAXY_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-ansible-galaxy-api-key")) }}{{ includeTemplate "secrets/key-ansible-galaxy-api-key" }}{{ else }}{{ env "ANSIBLE_GALAXY_TOKEN" }}{{ end }}"
export ANSIBLE_VAULT_PASSWORD="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-ansible-vault-password")) }}{{ includeTemplate "secrets/key-ansible-vault-password" }}{{ else }}{{ env "ANSIBLE_VAULT_PASSWORD" }}{{ end }}"
export AVP="$ANSIBLE_VAULT_PASSWORD"

### Google Cloud SDK
export CLOUDSDK_CORE_PROJECT="{{ .user.gcloud.coreProject }}"
export GCE_SERVICE_ACCOUNT_EMAIL="{{ .user.gcloud.email }}"
export GCE_CREDENTIALS_FILE="$HOME/.config/gcloud/gcp.json"

### CloudFlare
export LEXICON_CLOUDFLARE_TOKEN=""
export LEXICON_CLOUDFLARE_USERNAME="{{ .user.CLOUDFLARE_USERNAME }}"

### DockerHub
export DOCKERHUB_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-dockerhub-api-key")) }}{{ includeTemplate "secrets/key-dockerhub-api-key" }}{{ else }}{{ env "DOCKERHUB_TOKEN" }}{{ end }}"
export DOCKERHUB_REGISTRY_PASSWORD="$DOCKERHUB_TOKEN"

### GitHub
export GH_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-github-pat")) }}{{ includeTemplate "secrets/key-github-pat" }}{{ else }}{{ env "GITHUB_TOKEN" }}{{ end }}"
export GITHUB_TOKEN="$GH_TOKEN"

### GitLab
export GL_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-gitlab-pat")) }}{{ includeTemplate "secrets/key-gitlab-pat" }}{{ else }}{{ env "GITLAB_TOKEN" }}{{ end }}"
export GITLAB_TOKEN="$GL_TOKEN"

### Heroku
export HEROKU_API_KEY="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-heroku-api-key")) }}{{ includeTemplate "secrets/key-heroku-api-key" }}{{ else }}{{ env "HEROKU_API_KEY" }}{{ end }}"

### Megabyte Labs
export FULLY_AUTOMATED_TASKS=true

### NPM
export NPM_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-npm-api-key")) }}{{ includeTemplate "secrets/key-npm-api-key" }}{{ else }}{{ env "NPM_TOKEN" }}{{ end }}"

### PyPi
export PYPI_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-pypi-api-key")) }}{{ includeTemplate "secrets/key-pypi-api-key" }}{{ else }}{{ env "PYPI_TOKEN" }}{{ end }}"

### Snapcraft
export SNAPCRAFT_EMAIL="{{ .user.snapcraft.username }}"
export SNAPCRAFT_MACAROON="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-snapcraft-macaroon")) }}{{ includeTemplate "secrets/key-snapcraft-macaroon" }}{{ else }}{{ env "SNAPCRAFT_MACAROON" }}{{ end }}"
export SNAPCRAFT_UNBOUND_DISCHARGE="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-snapcraft-discharge")) }}{{ includeTemplate "secrets/key-snapcraft-discharge" }}{{ else }}{{ env "SNAPCRAFT_UNBOUND_DISCHARGE" }}{{ end }}"

### Vagrant Cloud
export VAGRANT_CLOUD_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" "secrets" "key-vagrant-cloud")) }}{{ includeTemplate "secrets/key-vagrant-cloud" }}{{ else }}{{ env "VAGRANT_CLOUD_TOKEN" }}{{ end }}"

{{ end -}}
