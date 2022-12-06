#!/usr/bin/env sh

# shellcheck disable=SC1090,SC1091

# Aliases / Functions / Exports
export XDG_CONFIG_HOME="$HOME/.config"
if [ -f "$XDG_CONFIG_HOME/shell/exports.sh" ]; then
  . "$XDG_CONFIG_HOME/shell/exports.sh"
fi
if [ -f "$XDG_CONFIG_HOME/shell/aliases.sh" ]; then
  . "$XDG_CONFIG_HOME/shell/aliases.sh"
fi
if [ -f "$XDG_CONFIG_HOME/shell/functions.sh" ]; then
  . "$XDG_CONFIG_HOME/shell/functions.sh"
fi

### Bash / ZSH
if [ "$BASH_SUPPORT" = 'true' ]; then
  ### OS Detection
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = 'alpine' ]; then
      OS_ICON=""
    elif [ "$ID" = 'arch' ]; then
      OS_ICON=""
    elif [ "$ID" = 'centos' ]; then
      OS_ICON=""
    elif [ "$ID" = 'coreos' ]; then
      OS_ICON=""
    elif [ "$ID" = 'debian' ]; then
      OS_ICON=""
    elif [ "$ID" = 'deepin' ]; then
      OS_ICON=""
    elif [ "$ID" = 'elementary' ]; then
      OS_ICON=""
    elif [ "$ID" = 'endeavour' ]; then
      OS_ICON=""
    elif [ "$ID" = 'freebsd' ]; then
      OS_ICON=""
    elif [ "$ID" = 'gentoo' ]; then
      OS_ICON=""
    elif [ "$ID" = 'kali' ]; then
      OS_ICON=""
    elif [ "$ID" = 'linuxmint' ]; then
      OS_ICON=""
    elif [ "$ID" = 'manjaro' ]; then
      OS_ICON=""
    elif [ "$ID" = 'nixos' ]; then
      OS_ICON=""
    elif [ "$ID" = 'openbsd' ]; then
      OS_ICON=""
    elif [ "$ID" = 'opensuse' ]; then
      OS_ICON=""
    elif [ "$ID" = 'parrot' ]; then
      OS_ICON=""
    elif [ "$ID" = 'pop_os' ]; then
      OS_ICON=""
    elif [ "$ID" = 'raspberry_pi' ]; then
      OS_ICON=""
    elif [ "$ID" = 'redhat' ]; then
      OS_ICON=""
    elif [ "$ID" = 'fedora' ]; then
      OS_ICON=""
    elif [ "$ID" = 'ubuntu' ]; then
      OS_ICON=""
    else
      OS_ICON=""
    fi
  else
    if [ -d /Applications ] && [ -d /Library ] && [ -d /System ]; then
      # macOS
      OS_ICON=""
    else
      OS_ICON=""
    fi
  fi

  ### ASDF
  if [ -f "$ASDF_DIR/asdf.sh" ]; then
    . "$ASDF_DIR/asdf.sh"
  fi

  ### Directory Colors
  if [ -f "$XDG_CONFIG_HOME/shell/lscolors.sh" ]; then
    . "$XDG_CONFIG_HOME/shell/lscolors.sh"
  fi

  ### fzf-git
  #if [ -f "$HOME/.local/scripts/fzf-git.bash" ]; then
  #  . "$HOME/.local/scripts/fzf-git.bash"
  #fi

  ### MOTD
  if [ -f "$XDG_CONFIG_HOME/shell/motd.sh" ]; then
    . "$XDG_CONFIG_HOME/shell/motd.sh"
  fi
fi

### Cargo
if [ -f "$CARGO_HOME/env" ]; then
  . "$CARGO_HOME/env"
fi

### Docker Functions / Aliases
if [ -f "$HOME/.local/scripts/docker-functions.bash" ]; then
  . "$HOME/.local/scripts/docker-functions.bash"
fi

### fzf-tmux
#if [ -f "$HOME/.local/scripts/fzf-tmux.bash" ]; then
#  . "$HOME/.local/scripts/fzf-tmux.bash"
#fi

### SDKMan
if command -v brew > /dev/null && command -v sdkman-cli > /dev/null; then
  export SDKMAN_DIR="$(brew --prefix sdkman-cli)/libexec"
  . "$SDKMAN_DIR/bin/sdkman-init.sh"
elif [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
  export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
  . "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

### VIM
export GVIMINIT='let $MYGVIMRC="$XDG_CONFIG_HOME/vim/gvimrc" | source $MYGVIMRC'
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
