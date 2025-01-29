* Write requirements for `software.yml`

https://github.com/harababurel/gcsf
https://nixos.wiki/wiki/Nix_Installation_Guide
https://github.com/seaweedfs/seaweedfs
[text](https://github.com/gitbito/CLI)
https://github.com/awslabs/mountpoint-s3
https://gist.github.com/chadmayfield/ada07e4e506d7acd577a665541a70c9b
* Move age decryption higher
* Add ~/.local/share/sounds was symlink to {{ .host.home }}/.local/share/betelgeuse/share/sounds
xattr -d com.apple.quarantine rclone
Create issue about setting up completions - https://github.com/rsteube/lazycomplete
pw="$(osascript -e 'Tell application "System Events" to display dialog "Password:" default answer "" with hidden answer' -e 'text returned of result' 2>/dev/null)" && echo "$pw"
https://github.com/Shougo/ddc.vim
[text](https://instill.tech/chill/models)
https://github.com/harababurel/gcsf
https://github.com/s3fs-fuse/s3fs-fuse
https://github.com/ossec/ossec-hids
[text](https://github.com/invoke-ai/InvokeAI)
https://github.com/search?q=system&type=repositories&s=stars&o=desc&p=59
- https://github.com/nats-io/nats-server
- [Title](https://github.com/albfan/miraclecast)
- [Title](https://gitlab.gnome.org/GNOME/gnome-network-displays)
Use minimum permissions / IAM for https://iosexample.com/a-command-line-tool-to-download-and-install-apples-xcode/
https://github.com/tiiiecherle/osx_install_config/blob/master/03_homebrew_casks_and_mas/3b_homebrew_casks_and_mas_install/6_mas_appstore.sh
virtualbox blocked by C
adobe-creative-cloud curl: (18) HTTP/2 stream 1 was reset
* Wazuh requires booting into recovery, running csrutil disable, installing agent normally, and then re-enabling it again in recovery mode
- https://app.warp.dev/referral/7PMXRV Warp referral
* NGINX /opt/homebrew/etc/nginx/nginx.conf, on port 8080 so no sudo required, nginx will load all files in /opt/homebrew/etc/nginx/servers/, brew services might require sudo if port 443 is used, Docroot /opt/homebrew/var/www
- https://github.com/linuxserver/docker-webtop
- https://nginxui.com/

- Barrier config
- Integrate Sheldon
- Look at Flipper Zero
- Come up with some sensible defaults for https://espanso.org/
- https://containertoolbx.org/install/
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

- Consider integrating [LocalAI](https://github.com/go-skynet/LocalAI) which can be used in combination with mods to generate ChatGPT responses locally
- Revisit Resilio - seems like they have tools useful for synchronizing VMs
- Consider switching license to [Polyform License Example](https://github.com/dosyago/DiskerNet/blob/fun/LICENSE.md)
- Determine whether or not https://webinstall.dev/vim-gui/ will add value to the VIM experience
- Find best Figma plugins here: https://www.figma.com/community/popular

## Docker

The following items are Docker containers that we may want to include as default containers deployed in our system.

- https://github.com/Infisical/infisical
- https://github.com/highlight/highlight
- https://github.com/jitsi/jitsi-videobridge
- https://github.com/gitlabhq/gitlabhq
- https://github.com/opf/openproject
- https://github.com/mastodon/mastodon
- https://github.com/formbricks/formbricks
- https://github.com/chatwoot/chatwoot- https://docs.rundeck.com/docs/administration/install/installing-rundeck.html - Rundeck (Self-Service Desk)
- https://github.com/activepieces/activepieces - SaaS Automations
- https://github.com/anse-app/anse - ChatGPT interface
- https://supabase.com/ - Firebase alternative
- https://github.com/pawelmalak/flame - Start page
- https://github.com/gristlabs/grist-core - Modern spreadsheet
- https://github.com/meienberger/runtipi - Home server
- https://github.com/directus/directus - SQL
- https://github.com/photoprism/photoprism - AI photo manager
- https://github.com/nocodb/nocodb - Airtable alternative
- https://github.com/lukevella/rallly - Schedule meetings
- https://github.com/pydio/cells - document sharing
- https://github.com/statping-ng/statping-ng
- https://github.com/AppFlowy-IO/AppFlowy - Notion alternative
- https://github.com/apitable/apitable

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

- https://fogproject.org/ (Backup solution)
- https://opennebula.io/ (Hybrid-cloud management)oud hypervisor)

## Revisit

The following items have been reviewed but need to be revisited due to complexity or other reasons.

- https://github.com/kubeflow/kubeflow
- https://github.com/appsmithorg/appsmith
- https://github.com/appwrite/appwrite
- builder.io
- https://github.com/yunionio/cloudpods
- https://github.com/tkestack/tke
- https://github.com/OpenNebula/one /. https://github.com/OpenNebula/minione

## Tiling Managers

- https://github.com/hyprwm/Hypr
- https://github.com/leftwm/leftwm

## Notes

* Configure firewall on macOS with `m firewall` on non-corp laptop
* Link to CUPS printers (http://localhost:631/printers)
* https://github.com/boochtek/mac_config/blob/master/os/quicklook.sh
* Sheldon completions
* Ensure freshclam and clamav send virus notifications to specified e-mail

## Definitely

* https://github.com/ConvoyPanel/panel
