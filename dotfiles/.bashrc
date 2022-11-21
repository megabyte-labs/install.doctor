# shellcheck disable=SC1090,SC1091

# Prefer US English
export LANG="en_US"

### Fig / LC_ALL
if [ "$0" = 'bash' ] || [ "$0" = '/bin/bash' ]; then
  if [[ "$(hostname)" != *'-minimal' ]]; then
    export LC_ALL="en_US.UTF-8"
  fi
  if [ -f "$HOME/.fig/shell/bashrc.pre.bash" ]; then
    . "$HOME/.fig/shell/bashrc.pre.bash"
  fi
fi

### ~/.profile
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

### Settings
if command -v shopt >/dev/null; then
  shopt -s globstar
  shopt -s histappend
  shopt -s checkwinsize
fi

### History
HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=5000
HISTFILE=~/.local/bash_history

# Prompt (on bash only)
if [ "$0" = 'bash' ] || [ "$0" = '/bin/bash' ]; then
  if [[ "$(hostname)" != *'-minimal' ]]; then
    ### Styled Terminal
    case "$TERM" in
    xterm* | rxvt* | Eterm | aterm | kterm | gnome* | alacritty)
      PS1="\n \[\033[0;34m\]╭─\[\033[0;31m\]\[\033[0;37m\]\[\033[41m\] $OS_ICON \u \[\033[0m\]\[\033[0;31m\]\[\033[44m\]\[\033[0;34m\]\[\033[44m\]\[\033[0;30m\]\[\033[44m\] \w \[\033[0m\]\[\033[0;34m\] \n \[\033[0;34m\]╰ \[\033[1;36m\]\$ \[\033[0m\]"
      ;;
    esac

    ### Directory Colors (https://github.com/trapd00r/LS_COLORS)
    # command -v gdircolors > /dev/null 2>&1 || gdircolors() { dircolors "$@"; }
    # if command -v gdircolors > /dev/null && [ -f "$HOME/.config/dircolors" ]; then
    #   eval "$(gdircolors -b "$HOME/.config/dircolors")"
    # fi
  fi
fi

### Bash Completions
if [ "$0" = 'bash' ] || [ "$0" = '/bin/bash' ]; then
  ### direnv
  if command -v direnv > /dev/null; then
    eval "$(direnv hook bash)"
  fi

  ### Java (asdf)
  if [ -f "$HOME/.local/asdf/plugins/java/set-java-home.bash" ]; then
    . "$HOME/.local/asdf/plugins/java/set-java-home.bash"
  fi

  ### zoxide
  if command -v zoxide > /dev/null; then
    eval "$(zoxide init --cmd cd bash)"
  fi

  ### Fig
  if [ -f "$HOME/.fig/shell/bashrc.post.bash" ]; then
    . "$HOME/.fig/shell/bashrc.post.bash"
  fi

  ### Vault
  if command -v vault > /dev/null; then
    complete -C vault vault
  fi
fi
