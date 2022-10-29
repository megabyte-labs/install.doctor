#!/usr/bin/env zsh
# shellcheck disable=SC1090,SC1091,SC2034,SC2154,SC2296

### Language / Fonts
export LANG="en_US"
export LC_ALL="en_US.UTF-8"

### Misc.
HISTFILE=~/.local/zsh_history
HIST_STAMPS=mm/dd/yyyy
HISTSIZE=5000
SAVEHIST=5000
ZLE_RPROMPT_INDENT=0
WORDCHARS=${WORDCHARS//\/}
PROMPT_EOL_MARK=
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

### Antigen
export ADOTDIR="$HOME/.local/antigen"

### Powerline
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Fig
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"

### ~/.profile
[[ -f "$HOME/.profile" ]] && . "$HOME/.profile"

# --------------------------------- SETTINGS ----------------------------------
setopt AUTO_CD
setopt BEEP
#setopt CORRECT
setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt MAGIC_EQUAL_SUBST
setopt NO_NO_MATCH
setopt NOTIFY
setopt NUMERIC_GLOB_SORT
setopt PROMPT_SUBST
setopt SHARE_HISTORY

# ZSH completion system
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
# shellcheck disable=SC2016
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Key bindings
bindkey -e
bindkey '^U' backward-kill-line
bindkey '^[[2~' overwrite-mode
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3;5~' kill-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[Z' undo
bindkey ' ' magic-space

# ----------------------------------- MISC -----------------------------------
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
	precmd() {
    	print -Pnr -- $'\e]0;%n@%m: %~\a'
  	}
	;;
esac

# https://github.com/trapd00r/LS_COLORS
command -v gdircolors >/dev/null 2>&1 || alias gdircolors="dircolors"
if type gdircolors &> /dev/null && [ -f "$HOME/.config/dircolors" ]; then
	eval "$(gdircolors -b "$HOME/.config/dircolors")"
fi

### Antigen
if [ -f "$HOME/.local/antigen.zsh" ]; then
  source "$HOME/.local/antigen.zsh"
fi
if command -v antigen > /dev/null; then
  antigen use oh-my-zsh
  antigen theme romkatv/powerlevel10k
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle adb
  antigen bundle ansible
  antigen bundle asdf
  antigen bundle aws
  antigen bundle bundler
  antigen bundle colored-man-pages
  antigen bundle codeclimate
  antigen bundle colorize
  antigen bundle command-not-found
  antigen bundle copyfile
  antigen bundle copybuffer
  antigen bundle deno
  antigen bundle docker
  antigen bundle docker-compose
  antigen bundle dotenv
  antigen bundle encode64
  antigen bundle fd
  antigen bundle fig
  antigen bundle fzf
  antigen bundle gcloud
  antigen bundle gh
  antigen bundle git
  antigen bundle git-auto-fetch
  antigen bundle gnu-utils
  antigen bundle golang
  antigen bundle gpg-agent
  antigen bundle gradle
  antigen bundle helm
  antigen bundle heroku
  antigen bundle httpie
  antigen bundle ionic
  antigen bundle keychain
  antigen bundle kubectl
  antigen bundle macos
  antigen bundle macports
  antigen bundle magic-enter
  antigen bundle microk8s
  antigen bundle minikube
  antigen bundle multipass
  antigen bundle npm
  antigen bundle pass
  antigen bundle pip
  antigen bundle pm2
  antigen bundle poetry
  antigen bundle rake
  antigen bundle rbenv
  antigen bundle repo
  antigen bundle ripgrep
  antigen bundle ruby
  antigen bundle salt
  antigen bundle safe-paste
  antigen bundle shell-proxy
  antigen bundle ssh-agent
  antigen bundle sudo
  antigen bundle terraform
  antigen bundle tmux
  antigen bundle transfer
  antigen bundle ubuntu
  antigen bundle ufw
  antigen bundle vagrant
  antigen bundle volta
  antigen bundle wp-cli
  antigen bundle yarn
  antigen bundle zoxide
  antigen bundle k
  antigen apply
fi

### Deno
if command -v deno > /dev/null; then
  eval "$(deno completions zsh)"
fi

### Helm
if command -v helm > /dev/null; then
  eval "$(helm completion zsh)"
fi

### Hyperfine
if command -v hyperfine > /dev/null && [ -f /usr/local/src/hyperfine/autocomplete/hyperfine.zsh-completion ]; then
  source /usr/local/src/hyperfine/autocomplete/hyperfine.zsh-completion
fi

### Java (asdf)
if [ -f "$HOME/.local/asdf/plugins/java/set-java-home.zsh" ]; then
  . "$HOME/.local/asdf/plugins/java/set-java-home.zsh"
fi

### mcfly
export MCFLY_KEY_SCHEME=vim
if command -v mcfly > /dev/null; then
  eval "$(mcfly init zsh)"
fi

### Poetry
if command -v poetry > /dev/null; then
  eval "$(poetry completions zsh)"
fi

### Volta
if command -v volta > /dev/null; then
  eval "$(volta completions zsh)"
fi

### Fig
if [ -f "$HOME/.fig/shell/zshrc.post.zsh" ]; then
	source "$HOME/.fig/shell/zshrc.post.zsh"
fi

### Powerline
if [ -f ~/.local/p10k.zsh ]; then
	source ~/.local/p10k.zsh
fi
