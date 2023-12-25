xattr -d com.apple.quarantine rclone
Create issue about setting up completions - https://github.com/rsteube/lazycomplete
pw="$(osascript -e 'Tell application "System Events" to display dialog "Password:" default answer "" with hidden answer' -e 'text returned of result' 2>/dev/null)" && echo "$pw"

Use minimum permissions / IAM for https://iosexample.com/a-command-line-tool-to-download-and-install-apples-xcode/
https://github.com/tiiiecherle/osx_install_config/blob/master/03_homebrew_casks_and_mas/3b_homebrew_casks_and_mas_install/6_mas_appstore.sh
virtualbox blocked by C
adobe-creative-cloud curl: (18) HTTP/2 stream 1 was reset
* Wazuh requires booting into recovery, running csrutil disable, installing agent normally, and then re-enabling it again in recovery mode
- https://app.warp.dev/referral/7PMXRV Warp referral
* NGINX /opt/homebrew/etc/nginx/nginx.conf, on port 8080 so no sudo required, nginx will load all files in /opt/homebrew/etc/nginx/servers/, brew services might require sudo if port 443 is used, Docroot /opt/homebrew/var/www
* export PATH="$HOME/.jenv/bin:$PATH"
* eval "$(jenv init -)"
- https://github.com/linuxserver/docker-webtop
- https://app.warp.dev/referral/7PMXRV
- https://github.com/chocolatey/boxstarter
- https://nginxui.com/
# Create the $HOME/opt destination folder
mkdir -p ~/opt
# Download the AppImage inside it
wget -O ~/opt/Espanso.AppImage 'https://github.com/federico-terzi/espanso/releases/download/v2.1.8/Espanso-X11.AppImage'
# Make it executable
chmod u+x ~/opt/Espanso.AppImage
# Create the "espanso" command alias
sudo ~/opt/Espanso.AppImage env-path register
- Deprecate asdf in favor of rtx
# TODOs
Application settings for Android Studio
- https://github.com/patrikx3/ramdisk
- Barrier config
This page outlines various projects and tasks that we are currently working on. Creating a GitHub issue for each of these items would be overkill.
- [Push Notification Server](https://github.com/gotify/server)
- https://community.cloudflare.com/t/allowing-either-cloudflare-ca-pem-or-regular-for-npm/578284
- Integrate Sheldon
- Look at Flipper Zero
- Consider https://formulae.brew.sh/cask/parallels-client#default
- https://github.com/tadamcz/updates.sh/blob/main/updates.sh (Homebrew download parallelism)
- Add Mamba
- Come up with some sensible defaults for https://espanso.org/
- https://docs.pkgx.sh/using-pkgx/shell-integration
- https://containertoolbx.org/install/
- https://github.com/todotxt/todo.txt-cli
- https://github.com/PromtEngineer/localGPT
- https://github.com/StanGirard/quivr
- https://github.com/containers/toolbox
- [IP Fire](https://www.ipfire.org/) - Consider as alternative to pfSense on Qubes.
- `git-credential-manager configure`
- [`git-credential-manager` for WSL](https://github.com/git-ecosystem/git-credential-manager/blob/release/docs/wsl.md)
- Configure Navi to automatically download and use the best cheat repositories
- Google Drive index on Cloudflare https://github.com/menukaonline/goindex-extended
- Go through https://github.com/jaywcjlove/awesome-mac
- https://codesandbox.io/ https://github.com/firecracker-microvm/firecracker
- (https://www.kolide.com/features/checks/mac-firewall)
- Create IP set for CloudFlare [Title](https://firewalld.org/documentation/man-pages/firewalld.ipset.html)
- https://chainner.app/
- https://github.com/kyrolabs/awesome-langchain
- Create seed for Lulu
- https://github.com/essandess/macOS-Fortress
- https://wakatime.com/plugins
- https://github.com/containers/toolbox consider for p10k.zsh file
- Figure out where Vector service fits in
- Figure out if Squid can be used to improve web surfing speed
- Consider leveraging a CLI builder powered by structured data like [https://github.com/mumoshu/variant](Variant) and / or [https://github.com/mumoshu/variant2](Variant2)
- Consider implementing a tool like [https://github.com/marshyski/quick-secure](QuickSecure) that will ensure proper permissions on boot
- https://www.haskell.org/ghcup/install/#how-to-install
- https://github.com/psychic-api/psychic

## Upstream

The following items are things we would like to include into the Install Doctor system but are waiting on upstream changes.

- [Actions](https://github.com/sindresorhus/Actions) adds a wide-variety of actions that you can utilize with the macOS Shortcuts app. It is currently only available via the macOS app store. Requested a Homebrew Cask [here](https://github.com/sindresorhus/Actions/issues/127).
- [Color Picker](https://github.com/sindresorhus/System-Color-Picker) is an improved color picker app available on macOS. It is currently only available via the macOS app store. Requested Homebrew Cask [here](https://github.com/sindresorhus/System-Color-Picker/issues/32).
- Consider integrating [LocalAI](https://github.com/go-skynet/LocalAI) which can be used in combination with mods to generate ChatGPT responses locally
- Wait for Homebrew install option for [Warpgate](https://github.com/warp-tech/warpgate)
- Wait for https://github.com/hocus-dev/hocus to get out of alpha for VM management
- Revisit https://github.com/rome/tools when project matures
- Revisit https://github.com/Disassembler0/Win10-Initial-Setup-Script for initial setup of Windows
- Revisit Resilio - seems like they have tools useful for synchronizing VMs
- Consider switching license to [Polyform License Example](https://github.com/dosyago/DiskerNet/blob/fun/LICENSE.md)
- Look into tile managers
- https://github.com/joelbarmettlerUZH/auto-tinder
- https://github.com/hfreire/get-me-a-date
- Keep eye on fig.io for release to Linux and new AI features
- Monitor https://moonrepo.dev/moon as possible mono-repo manager
- Determine whether or not https://webinstall.dev/vim-gui/ will add value to the VIM experience
- Wait for packages to be available for GitHub Actions https://github.com/actions/runner
- Find best Figma plugins here: https://www.figma.com/community/popular

## Docker

The following items are Docker containers that we may want to include as default containers deployed in our system.

- https://github.com/Infisical/infisical
- https://github.com/highlight/highlight
- https://github.com/jitsi/jitsi-videobridge
- https://github.com/gitlabhq/gitlabhq
- https://github.com/opf/openproject
- https://github.com/mastodon/mastodon
- https://github.com/huginn/huginn
- https://github.com/formbricks/formbricks
- https://github.com/chatwoot/chatwoot
- https://github.com/discourse/discourse
- https://github.com/erxes/erxes - CRM
- https://github.com/pawelmalak/flame - Homepage
- https://github.com/thelounge/thelounge - IRC
- https://github.com/vector-im/element-web - Matrix
- https://github.com/outline/outline - Collaborative MD
- https://github.com/nocodb/nocodb - MySQL Spreadsheet
- https://github.com/excalidraw/excalidraw - Hand-drawn Diagrams
- https://github.com/ansible/awx - AWX Ansible Management
- https://github.com/mergestat/mergestat - Git SQL Queries
- https://docs.rundeck.com/docs/administration/install/installing-rundeck.html - Rundeck (Self-Service Desk)
- https://easypanel.io/ - App deployments
- https://www.activepieces.com/docs/install/docker
- https://github.com/activepieces/activepieces - SaaS Automations
- https://github.com/diced/zipline - ShareX / File uploads
- https://github.com/anse-app/anse - ChatGPT interface
- https://github.com/wireapp/wire-webapp - Internal Slack
- https://github.com/jhaals/yopass - OTS web app https://github.com/algolia/sup3rS3cretMes5age
- https://github.com/aschzero/hera - CloudFlare tunnel proxy
- https://supabase.com/ - Firebase alternative
- https://github.com/tiredofit/docker-traefik-cloudflare-companion - Traefik CloudFlare integration
- https://github.com/erxes/erxes - HubSpot alternative
- https://github.com/pawelmalak/flame - Start page
- https://github.com/m1k1o/neko - Docker browser instance
- https://github.com/gristlabs/grist-core - Modern spreadsheet
- https://maddy.email/ / https://github.com/haraka/Haraka
- https://github.com/umputun/remark42 - Comments
- https://github.com/meienberger/runtipi - Home server
- https://github.com/bytebase/bytebase
- https://github.com/IceWhaleTech/CasaOS - Home page https://github.com/ajnart/homarr https://github.com/phntxx/dashboard
- https://github.com/usememos/memos - Memo page
- https://github.com/outline/outline - Team notes
- https://github.com/directus/directus - SQL
- https://github.com/photoprism/photoprism - AI photo manager
- https://github.com/louislam/uptime-kuma - Uptime monitor
- https://github.com/nocodb/nocodb - Airtable alternative
- https://github.com/timvisee/send
- https://github.com/TechnitiumSoftware/DnsServer - DNS proxy server
- https://github.com/lukevella/rallly - Schedule meetings
- https://github.com/chiefonboarding/ChiefOnboarding - Onboarding
- Microserver status page - https://github.com/valeriansaliou/vigil
- https://github.com/pydio/cells - document sharing
- ticket management - https://github.com/Peppermint-Lab/peppermint
- https://github.com/statping-ng/statping-ng
- https://github.com/cortezaproject/corteza - Low-code block workflows
- https://github.com/mirego/accent#-getting-started - Translation tool
- https://github.com/muety/wakapi - Coding time tracking
- https://github.com/subnub/myDrive - Google Drive interface
- https://github.com/Forceu/Gokapi - share files
- https://github.com/gerbera/gerbera - UPnP
- Forward server SSH - https://github.com/warp-tech/warpgate
- https://github.com/hadmean/hadmean - Revisit
- https://spaceb.in/ - Pastebin https://github.com/WantGuns/bin
- https://github.com/AlexSciFier/neonlink - bookmarks
- https://github.com/josdejong/jsoneditor - JSON editor
- https://github.com/AppFlowy-IO/AppFlowy - Notion alternative
- https://github.com/apitable/apitable
- https://github.com/mattermost/mattermost
- https://github.com/duolingo/metasearch
- https://github.com/withspectrum/spectrum
- https://github.com/NginxProxyManager/nginx-proxy-manager
- https://github.com/node-red/node-red
- https://www.overleaf.com/
- https://github.com/caprover/caprover
- [Title](https://github.com/xemle/home-gallery)
- [Title](https://github.com/chartbrew/chartbrew)
- [Title](https://github.com/AlexSciFier/neonlink)
- [Title](https://github.com/ForestAdmin/lumber)
- [Title](https://github.com/GladysAssistant/Gladys)

## AI

- https://github.com/hwchase17/langchain
- https://github.com/facebookresearch/ImageBind
- https://github.com/nomic-ai/gpt4all

### Kubernetes

The following items may be incorporated into our Kubernetes stack:

- https://github.com/kubevirt/kubevirt
- https://atuin.sh/docs/self-hosting/k8s
- https://github.com/gimlet-io/gimlet
- https://github.com/porter-dev/porter
- https://github.com/spacecloud-io/space-cloud
- https://github.com/meilisearch/meilisearch

## Bare Metal

The projects below are software systems that might be incorporated to handle bare-metal operations or virtual machine management.

- https://theforeman.org/ (VM management)
- https://fogproject.org/ (Backup solution)
- https://github.com/apache/cloudstack (VM management)
- https://www.ovirt.org/ (VM management)
- https://opennebula.io/ (Hybrid-cloud management)
- https://github.com/cloud-hypervisor/cloud-hypervisor (Cloud hypervisor)

## Revisit

The following items have been reviewed but need to be revisited due to complexity or other reasons.

- https://github.com/AmruthPillai/Reactive-Resume
- https://github.com/kubeflow/kubeflow
- https://github.com/leon-ai/leon
- https://github.com/teambit/bit
- https://github.com/Budibase/budibase
- https://github.com/appsmithorg/appsmith
- https://github.com/reworkd/AgentGPT
- https://github.com/appwrite/appwrite
- https://github.com/hoppscotch/hoppscotch
- builder.io
- https://github.com/hocus-dev/hocus
- cvat.io
- https://github.com/illacloud/illa-builder
- https://github.com/siyuan-note/siyuan
- https://github.com/open-hand/choerodon
- https://github.com/1backend/1backend
- https://github.com/redkubes/otomi-core
- https://github.com/yunionio/cloudpods
- https://github.com/tkestack/tke
- https://www.rancher.com/
- https://github.com/OpenNebula/one /. https://github.com/OpenNebula/minione
- https://github.com/hashicorp/nomad
- [Title](https://github.com/Sygil-Dev/sygil-webui)
- [Title](https://github.com/psychic-api/psychic)
- [Title](https://github.com/telekom-security/tpotce)
- [Title](https://flathub.org/apps/com.airtame.Client)
- [Title](https://frappeframework.com/docs/v14/user/en/installation)
- https://github.com/stringer-rss/stringer

## Tiling Managers

- https://github.com/hyprwm/Hypr
- https://github.com/leftwm/leftwm

## Bookmarks

- https://cheatsheets.zip/

## Windows

- https://github.com/DDoSolitary/LxRunOffline

## Notes

* This might not be easily achievable since macOS encourages user input during setup but it would be nice to come up with a script that updates macOS from version 13 to 14 if an update is available (or 14 to 15 etc.). Normally, `softwareupdate` CLI command can handle 13.5 to 13.7 etc. but not major versions.
* Configure firewall on macOS with `m firewall` on non-corp laptop
* Link to CUPS printers (http://localhost:631/printers)
* https://github.com/boochtek/mac_config/blob/master/os/quicklook.sh
* open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles" --- opens to grant full disk access
* "Terminal.app" would like to administer your computer. Administration can include modifying passwords, networking, and system settings.
* Press ENTER vim +PlugInstall
* Sheldon completions



## Definitely

* https://github.com/ConvoyPanel/panel