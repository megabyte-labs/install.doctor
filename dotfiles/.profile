# shellcheck disable=SC1090,SC1091

### Miscellaneous
export VISUAL=vim
export EDITOR=$VISUAL

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

  ### ASDF
  if [ -f "$HOME/.local/asdf/asdf.sh" ]; then
    export ASDF_CONFIG_FILE="$HOME/.config/asdf/asdfrc"
    export ASDF_DIR="$HOME/.local/asdf"
    export ASDF_DATA_DIR="$HOME/.local/asdf-data"
    export ASDF_CRATE_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/default-cargo-pkgs
    export ASDF_GEM_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/default-ruby-pkgs
    export ASDF_GOLANG_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/default-golang-pkgs
    export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/default-python-pkgs
    . "$HOME/.local/asdf/asdf.sh"
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
          bash_motd --banner --processor --memory --diskspace --docker --updates --letsencrypt --login
        elif command -v qubes-vmexec > /dev/null; then
          # Qubes AppVM
          bash_motd --banner --memory --diskspace --docker --updates
        elif command -v qubes-dom0-update > /dev/null; then
          # Qubes dom0
          bash_motd --banner --updates
        elif [ -d /Applications ] && [ -d /System ]; then
          # macOS
          bash_motd --banner
        else
          bash_motd --banner --processor --memory --diskspace --docker --updates --letsencrypt --login
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

### TOP - order based on preference of "top" application (last item will always be chosen if installed, e.g. glances)
command -v htop > /dev/null && alias top='htop'
command -v gotop > /dev/null && alias top='gotop -p $([ "$COLOR_SCHEME" = "light" ] && echo "-c default-dark")'
command -v ytop > /dev/null && alias top='ytop -p $([ "$COLOR_SCHEME" = "light" ] && echo "-c default-dark")'
command -v btm > /dev/null && alias top='btm $([ "$COLOR_SCHEME" = "light" ] && echo "--color default-light")'
# themes for light/dark color-schemes inside ~/.config/bashtop; Press ESC to open the menu and change the theme
command -v bashtop > /dev/null && alias top='bashtop'
command -v bpytop > /dev/null && alias top='bpytop'
command -v glances > /dev/null && alias top='glances'

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
if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
  export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
  export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}"
  export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}"
  export WHALEBREW_INSTALL_PATH="/home/linuxbrew/.linuxbrew/whalebrew"
fi

### Whalebrew
export WHALEBREW_CONFIG_DIR="$HOME/.config/whalebrew"

### Go
export GOPATH="${HOME}/.local/go"
export GO111MODULE=on
export PATH="$PATH:${GOPATH}/bin"
if command -v go > /dev/null && which go | grep -q 'asdf' > /dev/null && command -v asdf > /dev/null; then
  GOROOT="$(asdf where golang)/go"
  export GOROOT
  export PATH="$PATH:${GOROOT}/bin"
elif command -v go > /dev/null && command -v brew > /dev/null; then
  GOROOT="$(brew --prefix go)/libexec"
  export GOROOT
  export PATH="$PATH:${GOROOT}/bin"
fi

### Android Studio
if [ -d ~/Library/Android ]; then
  export PATH="$PATH:~/Library/Android/sdk/cmdline-tools/latest/bin"
  export PATH="$PATH:~/Library/Android/sdk/platform-tools"
  export PATH="$PATH:~/Library/Android/sdk/tools/bin"
  export PATH="$PATH:~/Library/Android/sdk/tools"
fi
export ANDROID_SDK_HOME="$HOME/.local/android-sdk"

### Azure CLI
export AZURE_CONFIG_DIR="$HOME/.config/azure"

### bat
export BAT_CONFIG_PATH="$HOME/.config/batrc"
if command -v bat > /dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  alias bathelp='bat --plain --language=help'
  alias cat='bat -pp'
  alias less='bat --paging=always'
  help() {
    "$@" --help 2>&1 | bathelp
  }
fi

### BitWarden
# https://bitwarden.com/help/cli/#using-an-api-key
# BW_CLIENTID	client_id
# BW_CLIENTSECRET

### curlie
if command -v curlie > /dev/null; then
  alias curl='curlie'
fi

### Elastic Agent
# https://www.elastic.co/guide/en/fleet/current/agent-environment-variables.html#env-common-vars

### exa
if command -v exa > /dev/null; then
  alias ls='exa --long --all --color auto --icons --sort=type'
  alias tree='exa --tree'
  alias la='ls -la'
  alias lt='ls --tree --level=2'
fi

### fzf
if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

### Git
export GIT_MERGE_AUTOEDIT=no

### gitfuzzy
export GF_BAT_STYLE=changes
export GF_BAT_THEME=zenbur
export GF_SNAPSHOT_DIRECTORY="$HOME/.local/git-fuzzy-snapshots"
if command -v delta > /dev/null; then
  export GF_PREFERRED_PAGER="delta --theme=gruvbox --highlight-removed -w __WIDTH__"
fi

### gping
# Replacement for ping that includes graph
if command -v gping > /dev/null; then
  alias ping='gping'
fi

### McFly
export MCFLY_FUZZY=2
export MCFLY_RESULTS=14
export MCFLY_KEY_SCHEME=vim

### nnn
if command -v nnn > /dev/null; then
  alias n='nnn -de'
  alias N='sudo -E nnn -dH'
  alias nnn-install-plugins='curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh'
  export NNN_RCLONE='rclone mount --read-only --no-checksum'
  export NNN_SSHFS='sshfs -o reconnect,idmap=user,cache_timeout=3600'
fi

### Poetry
export POETRY_HOME="$HOME/.local/poetry"
export PATH="$POETRY_HOME/bin:$PATH"

### Rear
# https://github.com/rear/rear/blob/master/doc/user-guide/03-configuration.adoc

### ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgreprc"
if command -v rg &> /dev/null; then
  alias grep='rg'
fi

### Ruby
export GEM_HOME="$HOME/.local/gems"
export PATH="$PATH:$GEM_HOME/bin"

### Volta
export VOLTA_HOME="$HOME/.local/volta"
export PATH="$VOLTA_HOME/bin:$PATH"

### SDKMan
if command -v brew > /dev/null && command -v sdkman-cli > /dev/null; then
  export SDKMAN_DIR="$(brew --prefix sdkman-cli)/libexec"
  . "$SDKMAN_DIR/bin/sdkman-init.sh"
elif [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
  export SDKMAN_DIR="$HOME/.local/sdkman"
  . "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

### Vagrant
export VAGRANT_DEFAULT_PROVIDER=virtualbox
export VAGRANT_HOME="$HOME/.local/vagrant.d"

### wget
export WGETRC="$HOME/.config/wgetrc"
