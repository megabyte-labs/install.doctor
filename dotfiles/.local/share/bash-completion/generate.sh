#!/usr/bin/env bash

### Initialize
COMPLETION_DIR="$XDG_DATA_HOME/bash-completion/completions"
mkdir -p "$COMPLETION_DIR"
FALLBACK_URL="https://gitlab.com/megabyte-labs/misc/dotfiles/-/raw/master/dotfiles/.local/share/bash-completion/completions"

### Deno
if command -v deno > /dev/null; then
  deno completions bash > "$COMPLETION_DIR/deno.bash"
elif [ -f "$COMPLETION_DIR/deno.bash" ]; then
  rm "$COMPLETION_DIR/deno.bash"
fi

### direnv
if command -v direnv > /dev/null; then
  direnv hook bash > "$COMPLETION_DIR/direnv.bash"
elif [ -f "$COMPLETION_DIR/direnv.bash" ]; then
  rm "$COMPLETION_DIR/direnv.bash"
fi

### fd
if command -v fd > /dev/null && command -v brew > /dev/null && [ -f "$(brew --prefix fd)/etc/bash_completion.d/fd" ]; then
  cp "$(brew --prefix fd)/etc/bash_completion.d/fd" "$COMPLETION_DIR/fd.bash"
elif command -v fd > /dev/null; then
  curl -sSL "$FALLBACK_URL/fd.bash" > "$COMPLETION_DIR/fd.bash"
elif [ -f "$COMPLETION_DIR/fd.bash" ]; then
  rm "$COMPLETION_DIR/fd.bash"
fi

### fig
if command -v fig > /dev/null; then
  fig completion bash > "$COMPLETION_DIR/fig.bash"
elif [ -f "$COMPLETION_DIR/fig.bash" ]; then
  rm "$COMPLETION_DIR/fig.bash"
fi

### gh
if command -v gh > /dev/null; then
  gh completion -s bash > "$COMPLETION_DIR/gh.bash"
elif [ -f "$COMPLETION_DIR/gh.bash" ]; then
  rm "$COMPLETION_DIR/gh.bash"
fi

### Google Cloud SDK
if command -v gcloud > /dev/null && command -v brew > /dev/null; then
  if [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ]; then
    cat "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" > "$COMPLETION_DIR/google-cloud-sdk.bash"
  elif command -v 
fi

### Googler
if command -v googler > /dev/null && command -v brew > /dev/null && [ -f "$(brew --prefix googler)/etc/bash_completion.d/googler-completion.bash" ]; then
  cp "$(brew --prefix googler)/etc/bash_completion.d/googler-completion.bash" "$COMPLETION_DIR/googler.bash"
elif command -v googler > /dev/null; then
  curl -sSL "$FALLBACK_URL/googler.bash" > "$COMPLETION_DIR/googler.bash"
elif [ -f "$COMPLETION_DIR/googler.bash" ]; then
  rm "$COMPLETION_DIR/googler.bash"
fi

### Gradle
if command -v gradle > /dev/null; then
  curl -sSL https://raw.githubusercontent.com/eriwen/gradle-completion/master/gradle-completion.bash > "$COMPLETION_DIR/gradle.bash"
fi

### Helm
if command -v helm > /dev/null; then
  helm completion bash > "$COMPLETION_DIR/helm.bash"
fi

### Hyperfine
if command -v hyperfine > /dev/null && command -v brew > /dev/null && [ -f "$(brew --prefix hyperfine)/etc/bash_completion.d/hyperfine.bash" ]; then
  cp "$(brew --prefix hyperfine)/etc/bash_completion.d/hyperfine.bash" "$COMPLETION_DIR/hyperfine.bash"
elif command -v hyperfine > /dev/null; then

fi

### kubectl
if command -v kubectl > /dev/null; then
  kubectl completion bash > "$COMPLETION_DIR/kubectl.bash"
fi

### mcfly
export MCFLY_KEY_SCHEME=vim
if command -v mcfly > /dev/null; then
  mcfly init bash > "$COMPLETION_DIR/mcfly.bash"
fi

### npm
if command -v npm > /dev/null; then
  npm completion > "$COMPLETION_DIR/npm.bash"
fi

### Poetry
if command -v poetry > /dev/null; then
  poetry completions bash > "$COMPLETION_DIR/poetry.bash"
fi

### Volta
if command -v volta > /dev/null; then
  volta completions bash > "$COMPLETION_DIR/volta.bash"
fi

### wp-cli (only bash available)
if command -v wp > /dev/null && [ -f /usr/local/src/wp-cli/wp-completion.bash ]; then
  cp /usr/local/src/wp-cli/wp-completion.bash "$COMPLETION_DIR/wp.bash"
elif command -v wp > /dev/null; then
  curl -sSL https://raw.githubusercontent.com/wp-cli/wp-cli/v2.7.1/utils/wp-completion.bash > "$COMPLETION_DIR/wp.bash"
fi

### zoxide
if command -v zoxide >/dev/null; then
  zoxide init bash > "$COMPLETION_DIR/zoxide.bash"
fi
