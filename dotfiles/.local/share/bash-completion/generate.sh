#!/usr/bin/env bash

### Deno
if command -v deno > /dev/null; then
  deno completions bash > "$HOME/.local/share/bash-completion/completions/deno.bash"
fi

### direnv
if command -v direnv > /dev/null; then
  direnv hook bash > "$HOME/.local/share/bash-completion/completions/direnv.bash"
fi

### fd
if command -v fd > /dev/null && [ -f /usr/local/src/fd/autocomplete/fd.bash-completion ]; then
  cp /usr/local/src/fd/autocomplete/fd.bash-completion "$HOME/.local/share/bash-completion/completions/fd.bash"
fi

### gh
if command -v gh > /dev/null; then
  gh completion -s bash > "$HOME/.local/share/bash-completion/completions/gh.bash"
fi

### Google Cloud SDK
if command -v brew >/dev/null; then
  if [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ]; then
    cat "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" > "$HOME/.local/share/bash-completion/completions/google-cloud-sdk.bash"
  fi
fi

### Googler
if command -v googler > /dev/null; then
  if [ -f /usr/local/src/googler/googler-completion.bash ]; then
    cp /usr/local/src/googler/googler-completion.bash "$HOME/.local/share/bash-completion/completions/googler.bash"
  fi
  if [ -f /usr/local/src/googler/googler_at ]; then
    cp /usr/local/src/googler/googler_at "$HOME/.local/share/bash-completion/completions/googler-at.bash"
  fi
fi

### Helm
if command -v helm > /dev/null; then
  helm completion bash > "$HOME/.local/share/bash-completion/completions/helm.bash"
fi

### Hyperfine
if command -v hyperfine > /dev/null && [ -f /usr/local/src/hyperfine/autocomplete/hyperfine.bash-completion ]; then
  cp /usr/local/src/hyperfine/autocomplete/hyperfine.bash-completion "$HOME/.local/share/bash-completion/completions/hyperfine.bash"
fi

### kubectl
if command -v kubectl > /dev/null; then
  kubectl completion bash > "$HOME/.local/share/bash-completion/completions/kubectl.bash"
fi

### mcfly
export MCFLY_KEY_SCHEME=vim
if command -v mcfly > /dev/null; then
  mcfly init bash > "$HOME/.local/share/bash-completion/completions/mcfly.bash"
fi

### Poetry
if command -v poetry > /dev/null; then
  poetry completions bash > "$HOME/.local/share/bash-completion/completions/poetry.bash"
fi

### Volta
if command -v volta > /dev/null; then
  volta completions bash > "$HOME/.local/share/bash-completion/completions/volta.bash"
fi

### wp-cli (only bash available)
if command -v wp > /dev/null && [ -f /usr/local/src/wp-cli/wp-completion.bash ]; then
  cp /usr/local/src/wp-cli/wp-completion.bash "$HOME/.local/share/bash-completion/completions/wp.bash"
fi

### zoxide
if command -v zoxide >/dev/null; then
  zoxide init bash > "$HOME/.local/share/bash-completion/completions/zoxide.bash"
fi
