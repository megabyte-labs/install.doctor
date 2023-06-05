# TODOs

https://github.com/search?q=vscode&type=repositories&s=stars&o=desc&p=2
* Revisit https://github.com/rome/tools when project matures
https://github.com/rigoneri/syte/graphs/code-frequency
https://www.automated-bots.com/
https://github.com/NathanDuma/LinkedIn-Easy-Apply-Bot
https://github.com/hfreire/get-me-a-date
https://github.com/joelbarmettlerUZH/auto-tinder
https://github.com/coder/coder
zsh completions have been installed to:
  /usr/local/share/zsh/site-functions
  ==> Linking Binary 'completion.bash.inc' to '/usr/local/etc/bash_completion.d/google-cloud-sdk'
==> Linking Binary 'completion.zsh.inc' to '/usr/local/share/zsh/site-functions/_google_cloud_sdk'
Ansible roles
https://github.com/altermo/vim-plugin-list
Play with Navi and configure cheat repos

## Pending

* [Actions](https://github.com/sindresorhus/Actions) adds a wide-variety of actions that you can utilize with the macOS Shortcuts app. It is currently only available via the macOS app store. Requested a Homebrew Cask [here](https://github.com/sindresorhus/Actions/issues/127).
* [Color Picker](https://github.com/sindresorhus/System-Color-Picker) is an improved color picker app available on macOS. It is currently only available via the macOS app store. Requested Homebrew Cask [here](https://github.com/sindresorhus/System-Color-Picker/issues/32).
* Consider integrating [LocalAI](https://github.com/go-skynet/LocalAI) which can be used in combination with mods to generate ChatGPT responses locally
* Wait for Homebrew install option for [Warpgate](https://github.com/warp-tech/warpgate)

## Premium Software Recommendations

### macOS

* [Dato](https://apps.apple.com/app/id1470584107) - World clocks and calendar menu bar application available for macOS. It is a better, paid alternative to the free version of Clockr which is currently installed using the default configuration of Install Doctor.
* [Parallels](https://www.parallels.com/) is the best virtualization manager / platform available on macOS




# https://github.com/mergestat/mergestat
# Tiltfile
# Skate!
# RUNDECK
# Foreman?
# FOG
# AMANDA
# CloudStack
# AppScale
# resilio connect
# oVirt
# opennebula
# emailengine.app
# Consider:
- https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim
CLOUDFLARE_API_TOKEN
GMAIL_APP_PASSWORD
### Ensure these PATHs are added on Windows

add to PATH:
'%ProgramFiles(x86)%\mitmproxy\bin'
'%ProgramFiles(x86)%\juju'

# https://github.com/graysky2/profile-cleaner

### POSSIBLY USEFUL SOFTWARE

- Incorporate /home/linuxbrew/.linuxbrew/etc/bash_completion.d
- https://docs.brew.sh/Shell-Completion

## Figure out where these go

### Restic

RESTIC_REPOSITORY_FILE Name of file containing the repository location (replaces --repository-file)
RESTIC_REPOSITORY Location of repository (replaces -r)
RESTIC_PASSWORD_FILE Location of password file (replaces --password-file)
RESTIC_PASSWORD The actual password for the repository
RESTIC_PASSWORD_COMMAND Command printing the password for the repository to stdout
RESTIC_KEY_HINT ID of key to try decrypting first, before other keys
RESTIC_CACHE_DIR Location of the cache directory
RESTIC_COMPRESSION Compression mode (only available for repository format version 2)
RESTIC_PROGRESS_FPS Frames per second by which the progress bar is updated
RESTIC_PACK_SIZE Target size for pack files

TMPDIR Location for temporary files

AWS_ACCESS_KEY_ID Amazon S3 access key ID
AWS_SECRET_ACCESS_KEY Amazon S3 secret access key
AWS_SESSION_TOKEN Amazon S3 temporary session token
AWS_DEFAULT_REGION Amazon S3 default region
AWS_PROFILE Amazon credentials profile (alternative to specifying key and region)
AWS_SHARED_CREDENTIALS_FILE Location of the AWS CLI shared credentials file (default: ~/.aws/credentials)

ST_AUTH Auth URL for keystone v1 authentication
ST_USER Username for keystone v1 authentication
ST_KEY Password for keystone v1 authentication

OS_AUTH_URL Auth URL for keystone authentication
OS_REGION_NAME Region name for keystone authentication
OS_USERNAME Username for keystone authentication
OS_USER_ID User ID for keystone v3 authentication
OS_PASSWORD Password for keystone authentication
OS_TENANT_ID Tenant ID for keystone v2 authentication
OS_TENANT_NAME Tenant name for keystone v2 authentication

OS_USER_DOMAIN_NAME User domain name for keystone authentication
OS_USER_DOMAIN_ID User domain ID for keystone v3 authentication
OS_PROJECT_NAME Project name for keystone authentication
OS_PROJECT_DOMAIN_NAME Project domain name for keystone authentication
OS_PROJECT_DOMAIN_ID Project domain ID for keystone v3 authentication
OS_TRUST_ID Trust ID for keystone v3 authentication

OS_APPLICATION_CREDENTIAL_ID Application Credential ID (keystone v3)
OS_APPLICATION_CREDENTIAL_NAME Application Credential Name (keystone v3)
OS_APPLICATION_CREDENTIAL_SECRET Application Credential Secret (keystone v3)

OS_STORAGE_URL Storage URL for token authentication
OS_AUTH_TOKEN Auth token for token authentication

B2_ACCOUNT_ID Account ID or applicationKeyId for Backblaze B2
B2_ACCOUNT_KEY Account Key or applicationKey for Backblaze B2

AZURE_ACCOUNT_NAME Account name for Azure
AZURE_ACCOUNT_KEY Account key for Azure
AZURE_ACCOUNT_SAS Shared access signatures (SAS) for Azure

GOOGLE_PROJECT_ID Project ID for Google Cloud Storage
GOOGLE_APPLICATION_CREDENTIALS Application Credentials for Google Cloud Storage (e.g. $HOME/.config/gs-secret-restic-key.json)

RCLONE_BWLIMIT rclone bandwidth limit

### Wazuh

WAZUH_MANAGER
Specifies the manager IP address or hostname. If you want to specify multiple managers, you can add them separated by commas. See address.
WAZUH_MANAGER_PORT
Specifies the manager connection port. See port.
WAZUH_PROTOCOL
Sets the communication protocol between the manager and the agent. Accepts UDP and TCP. The default is TCP. See protocol.
WAZUH_REGISTRATION_SERVER
Specifies the Wazuh registration server, used for the agent registration. See manager_address. If empty, the value set in WAZUH_MANAGER will be used.
WAZUH_REGISTRATION_PORT
Specifies the port used by the Wazuh registration server. See port.
WAZUH_REGISTRATION_PASSWORD
Sets password used to authenticate during register, stored in etc/authd.pass. See authorization_pass_path
WAZUH_KEEP_ALIVE_INTERVAL
Sets the time between agent checks for manager connection. See notify_time.
WAZUH_TIME_RECONNECT
Sets the time interval for the agent to reconnect with the Wazuh manager when connectivity is lost. See time-reconnect.
WAZUH_REGISTRATION_CA
Host SSL validation need of Certificate of Authority. This option specifies the CA path. See server_ca_path.
WAZUH_REGISTRATION_CERTIFICATE
The SSL agent verification needs a CA signed certificate and the respective key. This option specifies the certificate path. See agent_certificate_path.
WAZUH_REGISTRATION_KEY
Specifies the key path completing the required variables with WAZUH_REGISTRATION_CERTIFICATE for the SSL agent verification process. See agent_key_path.
WAZUH_AGENT_NAME
Designates the agent's name. By default, it will be the computer name. See agent_name.
WAZUH_AGENT_GROUP
Assigns the agent to one or more existing groups (separated by commas). See agent_groups.
ENROLLMENT_DELAY
Assigns the time that agentd should wait after a successful registration. See delay_after_enrollment.

### Docker

https://github.com/filebrowser/filebrowser
https://github.com/coder/code-server

[Polyform License Example](https://github.com/dosyago/DiskerNet/blob/fun/LICENSE.md)

### Robocorp.com

https://github.com/rigoneri/Syte3

* Look into tile managers


## CLI

* https://github.com/r-darwish/idnt
* https://github.com/charmbracelet/wish
* https://github.com/charmbracelet/skate
* https://github.com/console-rs/indicatif

## PHP

https://github.com/deployphp/deployer

## Alternative OSes

https://github.com/Andy-Python-Programmer/aero