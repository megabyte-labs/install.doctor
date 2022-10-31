# shellcheck disable=SC1090,SC1091

### Miscellaneous
export VISUAL=vim
export EDITOR=$VISUAL

### Clean Up
# May cause issues but too many dotfiles are stressful :|
if [ -d /usr/local/src/professor-dotfiles ]; then
  if [ -f ~/.gtkrc-2.0-kde4 ]; then
    rm -f ~/.gtkrc-2.0-kde4
  fi
fi

### Theme
COLOR_SCHEME=dark

### Colorize man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export LESSHISTFILE=-

### Line Wrap
setterm -linewrap on 2>/dev/null

# Aliases / Functions
if [ -f "$HOME/.local/aliases" ]; then
  . "$HOME/.local/aliases"
fi
if [ -f "$HOME/.local/functions" ]; then
  . "$HOME/.local/functions"
fi

### Bash / ZSH
if [ "$0" = 'bash' ] || [ "$0" = '/bin/bash' ] || [ "$0" = 'zsh' ] || [ "$0" = '/bin/zsh' ]; then
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

  ### MOTD
  # Add file named .hushlogin in the user's home directory to disable the MOTD
  if [ ! -f ~/.hushlogin ] && [ "$SHLVL" -eq 1 ]; then
    if [ -f "$HOME/.local/motd.sh" ] && { [ -n "$SSH_CONNECTION" ] && [[ $- == *i* ]]; } || command -v qubes-vmexec > /dev/null || command -v qubes-dom0-update > /dev/null || { [ -d /Applications ] && [ -d /System ]; }; then
      if { [ -z "$MOTD" ] || [ "$MOTD" -ne 0 ]; } && [[ "$(hostname)" != *'-minimal' ]]; then
        . "$HOME/.local/motd.sh"
        # TODO - -- services
        if [ -n "$SSH_CONNECTION" ]; then
          # SSH
          bash_motd --banner --processor --memory --diskspace --services --docker --updates --letsencrypt --login
        elif command -v qubes-vmexec > /dev/null; then
          # Qubes AppVM
          bash_motd --banner --memory --diskspace --docker
        elif command -v qubes-dom0-update > /dev/null; then
          # Qubes dom0
          bash_motd --banner --updates
        elif [ -d /Applications ] && [ -d /System ]; then
          # macOS
          bash_motd --banner
        else
          bash_motd --banner --processor --memory --diskspace --services --docker --updates --letsencrypt --login
        fi
      fi
    fi
  fi
fi

### Colorize
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias pacman='pacman --color=auto'

### Aliases (better defaults for simple commands)
alias cp='cp -v'
alias rm='rm -I'
alias mv='mv -iv'
alias ln='ln -sriv'
alias xclip='xclip -selection c'
command -v vim > /dev/null && alias vi='vim'

### LS & TREE
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -F'
command -v lsd > /dev/null && alias ls='lsd --group-dirs first' && \
	alias tree='lsd --tree'
command -v colorls > /dev/null && alias ls='colorls --sd --gs' && \
	alias tree='colorls --tree'

### CAT & LESS
command -v bat > /dev/null && \
	alias bat='bat --theme=ansi' && \
	alias cat='bat --pager=never' && \
	alias less='bat'
# In Debian the command is batcat
command -v batcat > /dev/null && \
	alias batcat='batcat --theme=ansi' && \
	alias cat='batcat --pager=never' && \
	alias less='batcat'

### TOP
command -v htop > /dev/null && alias top='htop'
command -v gotop > /dev/null && alias top='gotop -p $([ "$COLOR_SCHEME" = "light" ] && echo "-c default-dark")'
command -v ytop > /dev/null && alias top='ytop -p $([ "$COLOR_SCHEME" = "light" ] && echo "-c default-dark")'
command -v btm > /dev/null && alias top='btm $([ "$COLOR_SCHEME" = "light" ] && echo "--color default-light")'
# themes for light/dark color-schemes inside ~/.config/bashtop; Press ESC to open the menu and change the theme
command -v bashtop > /dev/null && alias top='bashtop'
command -v bpytop > /dev/null && alias top='bpytop'

# vim as default
export EDITOR="vim"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

### .local/bin
export PATH="$PATH:$HOME/.local/bin"

### Cargo
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

### GTK
export XDG_CONFIG_HOME="$HOME/.config"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

### Homebrew
if [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
  export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
  export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}"
  export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}"
fi

### Go
export GOPATH="${HOME}/.local/go"
export GO111MODULE=on
export PATH="$PATH:${GOPATH}/bin"

if command -v brew >/dev/null; then
  ### Go
  GOROOT="$(brew --prefix golang)/libexec"
  export GOROOT
  export PATH="$PATH:${GOROOT}/bin"

  ### ASDF
  export ASDF_CONFIG_FILE="$HOME/.config/asdf/asdfrc"
  export ASDF_DIR="$HOME/.local/asdf"
  export ASDF_DATA_DIR="$HOME/.local/asdf"
  export ASDF_CRATE_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/default-cargo-pkgs
  export ASDF_GEM_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/default-ruby-pkgs
  export ASDF_GOLANG_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/default-golang-pkgs
  export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/default-python-pkgs
  if [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
    . "$(brew --prefix asdf)/libexec/asdf.sh"
  fi
fi

### Android Studio
export PATH="$PATH:~/Library/Android/sdk/cmdline-tools/latest/bin"
export PATH="$PATH:~/Library/Android/sdk/platform-tools"
export PATH="$PATH:~/Library/Android/sdk/tools/bin"
export PATH="$PATH:~/Library/Android/sdk/tools"

### fzf
if [ -d /usr/local/opt/fzf/bin ]; then
  PATH="$PATH:/usr/local/opt/fzf/bin"
fi

### Git
export GIT_MERGE_AUTOEDIT=no

### gitfuzzy
export PATH="/usr/local/src/gitfuzzy/bin:$PATH"

### Poetry
export POETRY_HOME="$HOME/.local/poetry"
if [ ! -d "$POETRY_HOME" ]; then
  mkdir -p "$POETRY_HOME"
fi
export PATH="$POETRY_HOME/bin:$PATH"

### Ruby
export GEM_HOME="$HOME/.local/gems"
if [ ! -d "$GEM_HOME" ]; then
  mkdir -p "$GEM_HOME"
fi

### Volta
export VOLTA_HOME="$HOME/.local/volta"
if [ ! -d "$HOME/.local/volta" ]; then
  mkdir -p "$HOME/.local/volta"
fi
export PATH="$VOLTA_HOME/bin:$PATH"

### SDKMan
export SDKMAN_DIR="$HOME/.local/sdkman"
if [ -s "$HOME/.local/sdkman/bin/sdkman-init.sh" ]; then
  . "$HOME/.local/sdkman/bin/sdkman-init.sh"
fi

# Running this will update GPG to point to the current YubiKey
alias yubikey-gpg-stub='gpg-connect-agent "scd serialno" "learn --force" /bye'

### Vagrant
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export VAGRANT_HOME="$HOME/.local/vagrant.d"

### wget
export WGETRC="$HOME/.config/wgetrc"
