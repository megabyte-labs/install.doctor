Integrate into PowerShell profile.ps1: https://github.com/dahlbyk/posh-git

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
https://github.com/kelleyma49/PSFzf
https://github.com/jdhitsolutions/PSScriptTools
https://github.com/devblackops/Terminal-Icons
https://github.com/dfinke/ImportExcel
https://github.com/Disassembler0/Win10-Initial-Setup-Script
https://github.com/mandiant/flare-vm

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

## Website

https://github.com/Mintplex-Labs/anything-llm
* https://webcontainers.io/
* https://github.com/zulip/zulip
* https://github.com/ConvoyPanel/panel


## Kubernetes

* https://github.com/kubevirt/kubevirt

## VM

* https://www.cloudhypervisor.org/
* https://github.com/boxcutter/macos
* https://github.com/canonical/ubuntu-desktop-installer

## CLI

* https://github.com/r-darwish/idnt
* https://github.com/charmbracelet/wish
* https://github.com/charmbracelet/skate
* https://github.com/console-rs/indicatif
* https://github.com/tauri-apps/tauri
* https://github.com/emilengler/sysget
* https://github.com/pocketbase/pocketbase
* sysget
* https://github.com/therootcompany/serviceman
* https://github.com/vadimdemedes/ink
* https://github.com/ajenti/ajenti
* https://github.com/linuxserver/docker-webtop
* https://github.com/chocolatey/boxstarter

## System

* Include [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) to register IP addresses to `/etc/hosts` files so that they have IP addresses of other machines in the same Vagrant network
* Possible security improvement https://github.com/containers/toolbox
* Possible security test - https://github.com/AlessandroZ/LaZagne Windows password system sniffer

## PHP

https://github.com/deployphp/deployer

## Alternative OSes

https://github.com/Andy-Python-Programmer/aero


## Go Libraries to Consider

* https://github.com/ivaaaan/smug
* https://github.com/arl/gitmux
* https://github.com/jessfraz/dockfmt
* https://github.com/lindell/multi-gitter
* https://github.com/DBCDK/morph
* https://github.com/buildkite/agent
* https://github.com/fiatjaf/jiq
* https://github.com/curusarn/resh
* https://github.com/git-town/git-town
* https://github.com/0xERR0R/blocky
* https://github.com/terraform-linters/tflint
* https://github.com/cube2222/octosql
* https://github.com/alda-lang/alda
* https://github.com/aquasecurity/tfsec
* https://github.com/filhodanuvem/gitql
* https://github.com/filebrowser/filebrowser
* https://github.com/errata-ai/vale
* https://github.com/turbot/steampipe
* https://github.com/moby/buildkit
* https://github.com/schachmat/wego
* https://github.com/johnkerl/miller
* https://github.com/xo/usql
* https://github.com/future-architect/vuls
* https://github.com/containers/podman
* https://github.com/derailed/k9s


https://www.activepieces.com/docs/install/docker
https://easypanel.io/
https://app.zipy.ai/organization
https://github.com/apple/turicreate/
https://obsidian-plugin-stats.vercel.app/most-downloaded
https://fig.io/
https://medusajs.com/?ref=producthunt
https://railway.app/?ref=producthunt

Figure out how to use CLI for https://github.com/docker/volumes-backup-extension
https://formulae.brew.sh/formula/docker-machine-driver-vmware#default
https://www.npmjs.com/package/windosu

Caddy
https://webinstall.dev/xz/
https://webinstall.dev/goreleaser/
https://webinstall.dev/dotenv/
https://webinstall.dev/bun/

https://webinstall.dev/vim-sensible/
https://webinstall.dev/vim-devicons/
https://webinstall.dev/vim-nerdtree/
https://webinstall.dev/vim-gui/

https://github.com/obsproject/obs-studio
https://espanso.org/
https://formulae.brew.sh/cask/blender#default
https://kdenlive.org/en/
https://www.bluestacks.com/
https://github.com/symless/synergy-core
https://symless.com/synergy/features
https://github.com/upscayl/upscayl
https://espanso.org/

## Premium

* https://alternativeto.net/software/daemon-tools/about/
https://github.com/BalliAsghar/Mailsy
https://api.slack.com/automation/cli/commands

Move Gas Station into this project

Fix how terminal output renders on Terminal.app on macOS


https://github.com/TypeScriptToLua/TypeScriptToLua
https://github.com/context-labs/autodoc
https://github.com/projen/projen
https://github.com/activepieces/activepieces#
https://github.com/jupyterlab/jupyterlab-desktop
https://github.com/alibaba/lightproxy
https://github.com/Kanaries/Rath
https://github.com/butlerx/wetty
https://github.com/Nutlope/aicommits
https://github.com/mixn/carbon-now-cli
https://github.com/graphql-editor/graphql-editor
https://github.com/graphql/graphql-playground
https://github.com/voidcosmos/npkill
https://github.com/Raathigesh/majestic
https://github.com/raineorshine/npm-check-updates
https://github.com/oclif/oclif
https://github.com/vercel/serve
https://github.com/ds300/patch-package
https://github.com/cs01/gdbgui
https://github.com/ionic-team/capacitor
https://github.com/opencv/cvat
https://github.com/amplication/amplication
https://github.com/quicktype/quicktype
https://github.com/ionic-team/stencil
https://github.com/openai-translator/openai-translator
https://github.com/wulkano/Kap
https://github.com/NativeScript/NativeScript
https://github.com/ionic-team/ionic-framework
https://github.com/hoppscotch/hoppscotch
https://github.com/nestjs/nest
https://github.com/storybookjs/storybook

https://github.com/praeclarum/Netjs
https://github.com/PowerShell/GraphicalTools
https://github.com/PowerShell/PSResourceGet
https://github.com/awaescher/RepoZ
https://github.com/PowerShell/PSScriptAnalyzer
https://github.com/sq/JSIL
https://github.com/dotnet/format
https://github.com/NuGetPackageExplorer/NuGetPackageExplorer
https://github.com/anypackage/anypackage
https://github.com/BornToBeRoot/NETworkManager
https://github.com/actions/runner
https://github.com/hbons/SparkleShare
https://github.com/gitextensions/gitextensions
https://github.com/mRemoteNG/mRemoteNG
https://github.com/MathewSachin/Captura
https://github.com/felixse/FluentTerminal
https://github.com/carlospolop/PEASS-ng


https://github.com/utmapp/UTM

https://github.com/ianyh/Amethyst
https://github.com/pock/pock
https://github.com/lwouis/alt-tab-macos
https://github.com/ObuchiYuki/DevToysMac
https://github.com/Mortennn/Dozer
https://github.com/Clipy/Clipy
https://github.com/Toxblh/MTMR
https://github.com/Dimillian/RedditOS
https://github.com/alin23/Lunar
https://github.com/sindresorhus/Plash
https://github.com/swiftbar/SwiftBar
https://github.com/sindresorhus/Actions
https://github.com/superhighfives/pika
https://github.com/halo/LinkLiar
https://github.com/producthunt/producthunt-osx
https://github.com/Mortennn/FiScript

https://github.com/soduto/Soduto
https://github.com/wulkano/Plug

https://github.com/humblepenguinn/envio

Add to KDE plugins:
https://github.com/Bismuth-Forge/bismuth

## Docker
https://github.com/erxes/erxes - CRM
https://github.com/pawelmalak/flame - Homepage
https://github.com/thelounge/thelounge - IRC
https://github.com/vector-im/element-web - Matrix
https://github.com/outline/outline - Collaborative MD
https://github.com/nocodb/nocodb - MySQL Spreadsheet
https://github.com/excalidraw/excalidraw - Hand-drawn Diagrams
https://github.com/ansible/awx - AWX Ansible Management

## NoCode Docker Maybe
https://github.com/illacloud/illa-builder

## Revisit
https://github.com/microsoft/azuredatastudio
https://github.com/Nutlope/roomGPT
https://github.com/Zettlr/Zettlr
https://github.com/AmruthPillai/Reactive-Resume
https://github.com/kubeflow/kubeflow
https://github.com/leon-ai/leon
https://github.com/teambit/bit
https://github.com/Budibase/budibase
https://github.com/appsmithorg/appsmith
https://github.com/refined-github/refined-github
https://github.com/reworkd/AgentGPT
https://github.com/appwrite/appwrite
https://github.com/hoppscotch/hoppscotch
builder.io
https://github.com/hocus-dev/hocus
https://github.com/reworkd/AgentGPT

Finish TS from 1400 stars
Python
Swift
C#