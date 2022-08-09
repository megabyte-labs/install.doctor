# Add items to PATH
export PATH="$PATH:$HOME/.local/bin"

# Running this will update GPG to point to the current YubiKey
alias yubikey-gpg-stub='gpg-connect-agent "scd serialno" "learn --force" /bye'

export VAGRANT_HOME="$HOME/.local/vagrant.d"
