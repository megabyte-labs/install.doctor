#  Easy file sharing from the command line, using transfer.sh
transfer() {
  if [ $# -eq 0 ]; then
    echo -e "No arguments specified.\nUsage:\n  transfer <file|directory>\n  ... | transfer <file_name>">&2;
    return 1;
  fi;
  if tty -s;then
    file="$1";
    file_name=$(basename "$file");
    if [ ! -e "$file" ];then
      echo "$file: No such file or directory">&2;
      return 1;
    fi;
    if [ -d "$file" ];then
      file_name="$file_name.zip" ,;
      (cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;
    else
      cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;
    fi;
  else
    file_name=$1;
    curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;
  fi;
}

# Install WebDriverAgent on iOS device
appiumwebdriver() {
    read -p "Enter the UDID of the device you wish to install WebDriverAgent on: " UDID_INPUT
    mkdir -p Resources/WebDriverAgent.bundle
    bash ./Scripts/bootstrap.sh -d
    cd /Applications/Appium.app/Contents/Resources/app/node_modules/appium/node_modules/appium-webdriveragent
    xcodebuild -project WebDriverAgent.xcodeproj -scheme WebDriverAgentRunner -destination 'id=${UDID_INPUT}' test
}

# Change directories and view contents at the same time
cl() {
    DIR="$*";
        # if no DIR given, go home
        if [ $# -lt 1 ]; then
                DIR=$HOME;
    fi;
    builtin cd "${DIR}" && \
    # use your preferred ls command
        ls -F --color=auto
}

# Open bash with local Docker file
dockerssh() {
    if [ -z "$1" ]; then
        echo "Supply a Docker container name in order for this command to work."
        echo "Usage: dockerssh <container_name>"
    else
        docker exec -it $1 /bin/bash
    fi
}

# Checks status of a website on downforeveryoneorjustme.com
down4me() {
  curl -s "http://www.downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g';
}

# GAM - a command-line tool for Google Workspace. This alias will run gam or install gam if it is not already installed.
gam() {
  if type gam &> /dev/null; then
    gam "$@"
  else
    bash <(curl -s -S -L https://git.io/install-gam)
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

# Used to provision machines using Ansible
provision () {
    if [ -z "$1" ]; then
        # Display usage if no parameters are given
        echo "Usage: provision <ansible_inventory_name>"
        echo "If an inventory name of 'test' is provided then the inventory should exist in inventories/test.yml"
        return 1
    else
        cd ~/Playbooks
        ansible-galaxy install -r requirements.yml
        if [ -z "$2" ]; then
            ansible-playbook --ask-vault-pass -i inventories/"$1".yml main.yml
        else
            ansible-playbook --ask-vault-pass -i inventories/"$1".yml "$2".yml
        fi
    fi
}

# Generate a random string of X length
randomstring() {
    if [ -z "$1" ]; then
        head /dev/urandom | tr -dc A-Za-z0-9 | head -c $1 ; echo ''
    else
        echo "Pass the number of characters you would like the string to be. Example: randomstring 14"
    fi
}

# Launch rclone admin GUI
rclone-gui() {
  rclone rcd --rc-web-gui --rc-user=admin --rc-pass=pass --rc-serve
}

# Reset Docker to factory settings
resetdocker() {
    set +e
    CONTAINER_COUNT=$(docker ps -a -q | wc -l)
    if [ "$CONTAINER_COUNT" -gt 0 ]; then
        docker stop $(docker ps -a -q)
        docker rm $(docker ps -a -q)
    fi
    VOLUME_COUNT=$(docker volume ls -q | wc -l)
    if [ "$VOLUME_COUNT" -gt 0 ]; then
        docker volume rm $(docker volume ls -q)
    fi
    NETWORK_COUNT=$(docker network ls -q | wc -l)
    if [ "$NETWORK_COUNT" -gt 0 ]; then
        docker network rm $(docker network ls -q)
    fi
    docker system prune -a --force
}

# Source: https://itnext.io/bash-aliases-are-awesome-8a76aecc96ab
# Type ".. 5" to cd .. 5 times
..() {
    N=$(($1))
    if [ $N -lt 1 ]; then
        N=1
    fi
    while ((N)); do
        cd ..
        let N-=1
        done;
}

### Aliases

# Create an Authelia password hash
alias autheliapassword='docker run authelia/authelia:latest authelia hash-password'

# Shows IP addresses that are currently banned by fail2ban
alias banned='sudo zgrep "Ban" /var/log/fail2ban.log*'

# Removes all Ansible roles saved in ~/.ansible
alias clearroles='rm -rf ~/.ansible/roles/*'

alias connections='nm-connection-editor'

# Make copy command verbose
alias cp='cp -v'

# Copies with a progress bar
alias cpv='rsync -ah --info=progress2'

# Reload docker-compose.yml
alias docker-reboot='docker-compose stop && docker-compose up -d'

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
alias rclonegui='rclone rcd --rc-web-gui'

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

# Alias for sudo vim
alias svim='sudo vim'

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

### .local/bin
export PATH="$PATH:$HOME/.local/bin"

### Cargo
. "$HOME/.cargo/env"

if type brew &> /dev/null; then
    ### Go
    export GOPATH="${HOME}/.local/go"
    export GOROOT="$(brew --prefix golang)/libexec"
    export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

    ### ASDF
    . $(brew --prefix asdf)/libexec/asdf.sh
fi

### Android Studio
export PATH="$PATH:~/Library/Android/sdk/cmdline-tools/latest/bin"
export PATH="$PATH:~/Library/Android/sdk/platform-tools"
export PATH="$PATH:~/Library/Android/sdk/tools/bin"
export PATH="$PATH:~/Library/Android/sdk/tools"

### gitfuzzy
export PATH="/usr/local/src/gitfuzzy/bin:$PATH"

### Poetry
export PATH="$HOME/.poetry/bin:$PATH"

### Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

### SDKMan
export SDKMAN_DIR="$HOME/.local/sdkman"
[[ -s "$HOME/.local/sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.local/sdkman/bin/sdkman-init.sh"

# Running this will update GPG to point to the current YubiKey
alias yubikey-gpg-stub='gpg-connect-agent "scd serialno" "learn --force" /bye'

### Vagrant
export VAGRANT_HOME="$HOME/.local/vagrant.d"
