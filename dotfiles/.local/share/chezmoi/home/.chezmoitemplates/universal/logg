# @description Installs glow (a markdown renderer) from GitHub releases
# @example installGlow
installGlow() {
  # TODO: Add support for other architecture types
  if [ -d '/Applications' ] && [ -d '/Library' ] && [ -d '/Users' ]; then
    GLOW_DOWNLOAD_URL="https://github.com/charmbracelet/glow/releases/download/v1.4.1/glow_1.4.1_Darwin_x86_64.tar.gz"
  elif [ -f '/etc/ubuntu-release' ] || [ -f '/etc/debian_version' ] || [ -f '/etc/redhat-release' ] || [ -f '/etc/SuSE-release' ] || [ -f '/etc/arch-release' ] || [ -f '/etc/alpine-release' ]; then
    GLOW_DOWNLOAD_URL="https://github.com/charmbracelet/glow/releases/download/v1.4.1/glow_1.4.1_linux_x86_64.tar.gz"
  fi
  if type curl &> /dev/null; then
    if { [ -d '/Applications' ] && [ -d '/Library' ] && [ -d '/Users' ]; } || [ -f '/etc/ubuntu-release' ] || [ -f '/etc/debian_version' ] || [ -f '/etc/redhat-release' ] || [ -f '/etc/SuSE-release' ] || [ -f '/etc/arch-release' ] || [ -f '/etc/alpine-release' ]; then
      TMP="$(mktemp)"
      TMP_DIR="$(dirname "$TMP")"
      curl -sSL "$GLOW_DOWNLOAD_URL" > "$TMP"
      tar -xzf "$TMP" -C "$TMP_DIR"
      if [ -n "$HOME" ]; then
        if mkdir -p "$HOME/.local/bin" && mv "$TMP_DIR/glow" "$HOME/.local/bin/glow"; then
          GLOW_PATH="$HOME/.local/bin/glow"
        else
          GLOW_PATH="$(dirname "${BASH_SOURCE[0]}")/glow"
          mv "$TMP_DIR/gum" "$GLOW_PATH"
        fi
        chmod +x "$GLOW_PATH"
      else
        echo "WARNING: The HOME environment variable is not set! (Glow)"
      fi
    else
      echo "WARNING: Unable to detect system type. (Glow)"
    fi
  fi
}

# @description Installs gum (a logging CLI) from GitHub releases
# @example installGum
installGum() {
  # TODO: Add support for other architecture types
  if [ -d '/Applications' ] && [ -d '/Library' ] && [ -d '/Users' ]; then
    GUM_DOWNLOAD_URL="https://github.com/charmbracelet/gum/releases/download/v0.4.0/gum_0.4.0_Darwin_x86_64.tar.gz"
  elif [ -f '/etc/ubuntu-release' ] || [ -f '/etc/debian_version' ] || [ -f '/etc/redhat-release' ] || [ -f '/etc/SuSE-release' ] || [ -f '/etc/arch-release' ] || [ -f '/etc/alpine-release' ]; then
    GUM_DOWNLOAD_URL="https://github.com/charmbracelet/gum/releases/download/v0.4.0/gum_0.4.0_linux_x86_64.tar.gz"
  fi
  if type curl &> /dev/null; then
    if { [ -d '/Applications' ] && [ -d '/Library' ] && [ -d '/Users' ]; } || [ -f '/etc/ubuntu-release' ] || [ -f '/etc/debian_version' ] || [ -f '/etc/redhat-release' ] || [ -f '/etc/SuSE-release' ] || [ -f '/etc/arch-release' ] || [ -f '/etc/alpine-release' ]; then
      TMP="$(mktemp)"
      TMP_DIR="$(dirname "$TMP")"
      curl -sSL "$GUM_DOWNLOAD_URL" > "$TMP"
      tar -xzf "$TMP" -C "$TMP_DIR"
      if [ -n "$HOME" ]; then
        if mkdir -p "$HOME/.local/bin" && mv "$TMP_DIR/gum" "$HOME/.local/bin/gum"; then
          GUM_PATH="$HOME/.local/bin/gum"
        else
          GUM_PATH="$(dirname "${BASH_SOURCE[0]}")/gum"
          mv "$TMP_DIR/gum" "$GLOW_PATH"
        fi
        chmod +x "$GUM_PATH"
      else
        echo "WARNING: The HOME environment variable is not set! (Gum)"
      fi
    else
      echo "WARNING: Unable to detect system type. (Gum)"
    fi
  fi
}

# @description Configure the logger to use echo or gum
if [ "${container:=}" != 'docker' ]; then
  # Acquire gum's path or attempt to install it
  if type gum &> /dev/null; then
    GUM_PATH="$(which gum)"
  elif [ -f "$HOME/.local/bin/gum" ]; then
    GUM_PATH="$HOME/.local/bin/gum"
  elif [ -f "$(dirname "${BASH_SOURCE[0]}")/gum" ]; then
    GUM_PATH="$(dirname "${BASH_SOURCE[0]}")/gum"
  elif type brew &> /dev/null; then
    brew install gum
    GUM_PATH="$(which gum)"
  else
    installGum
  fi

  # If gum's path was set, then turn on enhanced logging
  if [ -n "$GUM_PATH" ]; then
    chmod +x "$GUM_PATH"
    ENHANCED_LOGGING=true
  fi
fi

format() {
  # shellcheck disable=SC2001,SC2016
  ANSI_STR="$(echo "$1" | sed 's/^\([^`]*\)`\([^`]*\)`/\1\\u001b[47;1;30m \2 \\e[0;39m/')"
  if [[ $ANSI_STR == *'`'*'`'* ]]; then
    ANSI_STR="$(format "$ANSI_STR")"
  fi
  echo -e "$ANSI_STR"
}

# @description Logs using Node.js
# @example logger info "An informative log"
logg() {
  if [ "$1" == 'error' ]; then
    "$GUM_PATH" style --border="thick" "$("$GUM_PATH" style --foreground="#ff0000" "✖") $("$GUM_PATH" style --bold --background="#ff0000" --foreground="#ffffff"  " ERROR ") $("$GUM_PATH" style --bold "$(format "$2")")"
  elif [ "$1" == 'info' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#00ffff" "○") $2"
  elif [ "$1" == 'md' ]; then
    # @description Ensure glow is installed
    if [ "${container:=}" != 'docker' ]; then
      if type glow &> /dev/null; then
        GLOW_PATH="$(which glow)"
      elif [ -f "$HOME/.local/bin/glow" ]; then
        GLOW_PATH="$HOME/.local/bin/glow"
      elif [ -f "$(dirname "${BASH_SOURCE[0]}")/glow" ]; then
        GLOW_PATH="$(dirname "${BASH_SOURCE[0]}")/glow"
      elif type brew &> /dev/null; then
        brew install glow
        GLOW_PATH="$(which glow)"
      else
        installGlow
      fi

      if [ -n "$GLOW_PATH" ]; then
        chmod +x "$GLOW_PATH"
        ENHANCED_LOGGING=true
      fi
    fi
    "$GLOW_PATH" "$2"
  elif [ "$1" == 'prompt' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#00008b" "▶") $("$GUM_PATH" style --bold "$(format "$2")")"
  elif [ "$1" == 'star' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#d1d100" "◆") $("$GUM_PATH" style --bold --underline "$(format "$2")")"
  elif [ "$1" == 'start' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#00ff00" "▶") $("$GUM_PATH" style --bold "$(format "$2")")"
  elif [ "$1" == 'success' ]; then
    "$GUM_PATH" style "$("$GUM_PATH" style --foreground="#00ff00" "✔")  $("$GUM_PATH" style --bold "$(format "$2")")"
  elif [ "$1" == 'warn' ]; then
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#d1d100" "◆") $("$GUM_PATH" style --bold --background="#ffff00" --foreground="#000000"  " WARNING ") $("$GUM_PATH" style --bold --italic "$(format "$2")")"
  else
    "$GUM_PATH" style " $("$GUM_PATH" style --foreground="#00ff00" "▶") $("$GUM_PATH" style --bold "$(format "$2")")"
  fi
}
