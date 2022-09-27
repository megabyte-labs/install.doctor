### Fig
[[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && . "$HOME/.fig/shell/bashrc.pre.bash"

### ~/.profile
[[ -f "$HOME/.profile" ]] && . "$HOME/.profile"

COLOR_SCHEME=dark # dark/light

alias ..='cd ..'
alias cp='cp -v'
alias rm='rm -I'
alias mv='mv -iv'
alias ln='ln -sriv'
alias xclip='xclip -selection c'
command -v vim > /dev/null && alias vi='vim'

### Colorize commands
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias pacman='pacman --color=auto'

### LS & TREE
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
# in debian the command is batcat
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

### Settings
shopt -s globstar
shopt -s histappend
shopt -s checkwinsize

HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=5000
HISTFILE=~/.bash_history

# Bash Completion
if [ -f /usr/share/bash-completion/bash_completion ]
then
	source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]
then
	source /etc/bash_completion
fi

# Add new line before prompt
PROMPT_COMMAND="PROMPT_COMMAND=echo"

# Prompt
if [ -f /etc/os-release ]; then
  source /etc/os-release
  if [ -d /Applications ] && [ -d /Library ] && [ -d /System ]; then
	# macOS
	OS_ICON=
  elif [[ "$ID" == 'alpine' ]]; then
    OS_ICON=
  elif [[ "$ID" == 'archlinux' ]]; then
  	OS_ICON=
  elif [[ "$ID" == 'centos' ]]; then
    OS_ICON=
  elif [[ "$ID" == 'coreos' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'debian' ]]; then
    OS_ICON=
  elif [[ "$ID" == 'deepin' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'elementary' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'endeavour' ]]; then
    OS_ICON=
  elif [[ "$ID" == 'freebsd' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'gentoo' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'kali' ]]; then
    OS_ICON=
  elif [[ "$ID" == 'linuxmint' ]]; then
    OS_ICON=
  elif [[ "$ID" == 'manjaro' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'nixos' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'openbsd' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'opensuse' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'parrot' ]]; then
    OS_ICON=
  elif [[ "$ID" == 'pop_os' ]]; then
  	OS_ICON=
  elif [[ "$ID" == 'raspberry_pi' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'redhat' ]]; then
	OS_ICON=
  elif [[ "$ID" == 'fedora' ]]; then
    OS_ICON=
  elif [[ "$ID" == 'ubuntu' ]]; then
    OS_ICON=
  else
    OS_ICON=
  fi
else
  OS_ICON=
fi
PS1="\n \[\033[0;34m\]╭─\[\033[0;31m\]\[\033[0;37m\]\[\033[41m\] $OS_ICON \u \[\033[0m\]\[\033[0;31m\]\[\033[44m\]\[\033[0;34m\]\[\033[44m\]\[\033[0;30m\]\[\033[44m\] \w \[\033[0m\]\[\033[0;34m\] \n \[\033[0;34m\]╰ \[\033[1;36m\]\$ \[\033[0m\]"

### Miscellaneous
export VISUAL=vim
export EDITOR=$VISUAL

# enable terminal linewrap
setterm -linewrap on 2> /dev/null

# colorize man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export LESSHISTFILE=-

# colorize ls
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
	PS1="\[\e]0;\u@\h: \w\a\]$PS1"
	;;
esac

### Functions
glog() {
	setterm -linewrap off 2> /dev/null

	git --no-pager log --all --color=always --graph --abbrev-commit --decorate --date-order \
		--format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' "$@" \
		| sed -E \
			-e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+ /├\1─╮\2/' \
			-e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m /\1├─╯\x1b\[m/' \
			-e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+/├\1╮\2/' \
			-e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m/\1├╯\x1b\[m/' \
			-e 's/╮(\x1b\[[0-9;]*m)+\\/╮\1╰╮/' \
			-e 's/╯(\x1b\[[0-9;]*m)+\//╯\1╭╯/' \
			-e 's/(\||\\)\x1b\[m   (\x1b\[[0-9;]*m)/╰╮\2/' \
			-e 's/(\x1b\[[0-9;]*m)\\/\1╮/g' \
			-e 's/(\x1b\[[0-9;]*m)\//\1╯/g' \
			-e 's/^\*|(\x1b\[m )\*/\1⎬/g' \
			-e 's/(\x1b\[[0-9;]*m)\|/\1│/g' \
		| command less -r $([ $# -eq 0 ] && echo "+/[^/]HEAD")

	setterm -linewrap on 2> /dev/null
}

find() {
	if [ $# = 1 ]
	then
		command find . -iname "*$@*"
	else
		command find "$@"
	fi
}

rga-fzf() {
  RG_PREFIX="rga --files-with-matches"
  local file
  file="$(
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
      fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
        --phony -q "$1" \
        --bind "change:reload:$RG_PREFIX {q}" \
        --preview-window="70%:wrap"
  )" &&
  echo "opening $file" &&
  xdg-open "$file"
}

### fd
[ -e /usr/local/src/fd/fd ] && source /usr/local/src/fd/autocomplete/fd.bash-completion

### Hyperfine
[ -e /usr/local/src/hyperfine/hyperfine ] && source /usr/local/src/hyperfine/autocomplete/hyperfine.bash-completion

### mcfly
export MCFLY_KEY_SCHEME=vim
[ -e /usr/local/src/mcfly/mcfly ] && eval "$(mcfly init bash)"

### wp-cli
[ -e /usr/local/bin/wp ] && source /usr/local/src/wp-cli/wp-completion.bash

### direnv
[ -e /usr/local/bin/direnv ] && eval "$(direnv hook bash)"

### Googler
[ -e /usr/local/bin/googler ] && source /usr/local/src/googler/googler-completion.bash
[ -e /usr/local/bin/googler ] && source /usr/local/src/googler/googler_at

### FZF
[ -f ~/.local/fzf.bash ] && source ~/.local/fzf.bash

### Google Cloud SDK
if type brew &> /dev/null; then
    [[ ! -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc" ]] || source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
    [[ ! -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ]] || source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi

### zoxide
type zoxide &> /dev/null && eval "$(zoxide init bash)"

### Fig
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && . "$HOME/.fig/shell/bashrc.post.bash"
