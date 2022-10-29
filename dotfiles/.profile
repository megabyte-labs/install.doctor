# shellcheck disable=SC1090,SC1091

#  Easy file sharing from the command line, using transfer.sh
transfer() {
  if [ $# -eq 0 ]; then
    echo -e "No arguments specified.\nUsage:\n  transfer <file|directory>\n  ... | transfer <file_name>" >&2
    return 1
  fi
  if tty -s; then
    file="$1"
    file_name=$(basename "$file")
    if [ ! -e "$file" ]; then
      echo "$file: No such file or directory" >&2
      return 1
    fi
    if [ -d "$file" ]; then
      file_name="$file_name.zip"
      (cd "$file" && zip -r -q - .) | curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" | tee /dev/null,
    else
      curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" <"$file" | tee /dev/null
    fi
  else
    file_name=$1
    curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name" | tee /dev/null
  fi
}

# Install WebDriverAgent on iOS device
appiumwebdriver() {
  # read -r "Enter the UDID of the device you wish to install WebDriverAgent on: " UDID_INPUT
  mkdir -p Resources/WebDriverAgent.bundle
  bash ./Scripts/bootstrap.sh -d
  cd /Applications/Appium.app/Contents/Resources/app/node_modules/appium/node_modules/appium-webdriveragent || return
  xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination "id=${UDID_INPUT}" test
}

# Change directories and view contents at the same time
cl() {
  DIR="$*"
  # if no DIR given, go home
  if [ $# -lt 1 ]; then
    DIR=$HOME
  fi
  builtin cd "${DIR}" &&
    # use your preferred ls command
    ls -F --color=auto
}

# Checks status of a website on downforeveryoneorjustme.com
down4me() {
  curl -s "http://www.downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g'
}

find() {
  if [ $# = 1 ]; then
    # shellcheck disable=SC2145
    command find . -iname "*$@*"
  else
    command find "$@"
  fi
}

# Opens current repository in browser
gitopen() {
  git remote -v | head -n 1 | awk -F "@" '{print $2}' | awk -F " " '{print $1}' | sed 's/:/\//g' | sed 's/.git//g' | awk '{print "http://"$1}' | xargs open
}

# Open Mac OS X desktop on a Linux machine
macosx() {
  docker run -it --device /dev/kvm -p 50922:10022 -v /tmp/.X11-unix:/tmp/.X11-unix -e "DISPLAY=${DISPLAY:-:0.0}" sickcodes/docker-osx:big-sur
}

# Run the quickstart script
quickstart() {
  if command -v qvm-run >/dev/null; then
    qvm-run --pass-io personal "curl -sSL https://install.doctor/qubes" >"$HOME/setup.sh" && bash "$HOME/setup.sh"
  elif [ -d '/Applications' ] && [ -d '/Users' ] && [ -d '/Library' ]; then
    curl -sSL https://install.doctor/quickstart >"$HOME/setup.sh" && bash "$HOME/setup.sh"
  elif [ -f '/etc/os-release' ]; then
    curl -sSL https://install.doctor/quickstart >"$HOME/setup.sh" && bash "$HOME/setup.sh"
  fi
  rm -f "$HOME/setup.sh"
}

# Generate a random string of X length
randomstring() {
  if [ -z "$1" ]; then
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c "$1"
  else
    echo "Pass the number of characters you would like the string to be. Example: randomstring 14"
  fi
}

# Reset Docker to factory settings
resetdocker() {
  set +e
  CONTAINER_COUNT="$(docker ps -a -q | wc -l)"
  if [ "$CONTAINER_COUNT" -gt 0 ]; then
    docker stop "$(docker ps -a -q)"
    docker rm "$(docker ps -a -q)"
  fi
  VOLUME_COUNT="$(docker volume ls -q | wc -l)"
  if [ "$VOLUME_COUNT" -gt 0 ]; then
    docker volume rm "$(docker volume ls -q)"
  fi
  NETWORK_COUNT="$(docker network ls -q | wc -l)"
  if [ "$NETWORK_COUNT" -gt 0 ]; then
    docker network rm "$(docker network ls -q)"
  fi
  docker system prune -a --force
}

### Aliases

# Create an Authelia password hash
alias autheliapassword='docker run authelia/authelia:latest authelia hash-password'

# Shows IP addresses that are currently banned by fail2ban
alias banned='sudo zgrep "Ban" /var/log/fail2ban.log*'

alias connections='nm-connection-editor'

# Make copy command verbose
alias cp='cp -v'

# Copies with a progress bar
alias cpv='rsync -ah --info=progress2'

# Download a file
alias download='curl --continue-at - --location --progress-bar --remote-name --remote-time'

# Download a website
alias downloadsite='wget --mirror -p --convert-links -P'

# Flush DNS
alias flushdns='sudo systemd-resolve --flush-caches && sudo systemd-resolve --statistics'

# Get the possible GRUB resolutions
alias grubresolutions='sudo hwinfo --framebuffer'

# Execute git command with sudo priviledges while retaining .gitconfig
alias gsudo='sudo git -c "include.path="${XDG_CONFIG_DIR:-$HOME/.config}/git/config\" -c \"include.path=$HOME/.gitconfig\"'

# Create hashed password for Ansible user creation
alias hashpassword='mkpasswd --method=sha-512'

# Show full output when using ls
alias ls='ls -AlhF --color=auto'

# Create parent directories automatically
alias mkdir='mkdir -pv'

# Make mount command output readable
alias mount='mount | column -t'

# Make mv command verbose
alias mv='mv -v'

# Show IP address
alias myip='curl http://ipecho.net/plain; echo'

# Shows local IP addresses
alias mylocalip="ifconfig | grep -Eo 'inet (addr:|adr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Show open ports
alias ports='sudo netstat -tulanp'

# Shuts down the computer, skipping the shutdown scripts
alias poweroff='sudo /sbin/poweroff'

# Open the Rclone web GUI
alias rclonegui='rclone rcd --rc-web-gui --rc-user=admin --rc-pass=pass --rc-serve'

# Reboot the computer
alias reboot='sudo /sbin/reboot'

# Make rm command verbose
alias rm='rm -vi'

# Launch the Python Simple HTTP Server
alias serve='python -m SimpleHTTPServer'

# Generate a SHA1 digest
alias sha1='openssl sha1'

# Shutdown the computer
alias shutdown='sudo /sbin/shutdown'

# Speed test
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'

# Shortcut for config file
alias sshconfig='${EDITOR:code} ~/.ssh/config'

# Pastebin
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'

# Disable Tor for current shell
alias toroff='source torsocks off'

# Enable Tor for current shell
alias toron='source torsocks on'

# Test Tor connection
alias tortest='curl --socks5-hostname 127.0.0.1:9050 --silent https://check.torproject.org/  | head -25'

# Unban IP address (e.g. unban 10.14.24.14)
alias unban='sudo fail2ban-client set sshd unbanip'

# Recursively encrypts files using Ansible Vault
alias unvaultdir='find . -type f -printf "%h/\"%f\" " | xargs ansible-vault decrypt'

# Alias for updating software
alias update='sudo apt-get update && sudo apt-get upgrade'

# Sets v as an alias for vim
alias v='vim'

# Recursively encrypts files using Ansible Vault
alias vaultdir='find . -type f -printf "%h/\"%f\" " | xargs ansible-vault encrypt'

# Shows nice looking report of weather
alias weather='curl -A curl wttr.in'

# Change .wget-hsts file location
alias wget="wget --hsts-file ~/.config/.wget-hsts"

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
