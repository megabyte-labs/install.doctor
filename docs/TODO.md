https://nixos.wiki/wiki/Nix_Installation_Guide
* Wazuh requires booting into recovery, running csrutil disable, installing agent normally, and then re-enabling it again in recovery mode
* NGINX /opt/homebrew/etc/nginx/nginx.conf, on port 8080 so no sudo required, nginx will load all files in /opt/homebrew/etc/nginx/servers/, brew services might require sudo if port 443 is used, Docroot /opt/homebrew/var/www
- https://github.com/linuxserver/docker-webtop
- https://nginxui.com/
- Barrier config
- https://github.com/qltysh/qlty
- https://github.com/BuilderIO/figma-html
- Goose CLI
- Integrate Sheldon
- https://github.com/kanidm/kanidm
https://github.com/presslabs/gitfs?tab=readme-ov-file
- https://github.com/koekeishiya/yabai
- Add and test import of nmcli for wireguard profiles
- Come up with some sensible defaults for https://espanso.org/
- `git-credential-manager configure`
- [`git-credential-manager` for WSL](https://github.com/git-ecosystem/git-credential-manager/blob/release/docs/wsl.md)
- Configure Navi to automatically download and use the best cheat repositories
- Google Drive index on Cloudflare https://github.com/menukaonline/goindex-extended
- https://codesandbox.io/
- (https://www.kolide.com/features/checks/mac-firewall)
- Create IP set for CloudFlare [Title](https://firewalld.org/documentation/man-pages/firewalld.ipset.html)
- https://github.com/kyrolabs/awesome-langchain
- https://wakatime.com/plugins
- Figure out where Vector service fits in
- Consider leveraging a CLI builder powered by structured data like [https://github.com/mumoshu/variant](Variant) and / or [https://github.com/mumoshu/variant2](Variant2)
- Consider implementing a tool like [https://github.com/marshyski/quick-secure](QuickSecure) that will ensure proper permissions on boot
- https://github.com/browserless/browserless
- Consider integrating [LocalAI](https://github.com/go-skynet/LocalAI) which can be used in combination with mods to generate ChatGPT responses locally
- Revisit Resilio - seems like they have tools useful for synchronizing VMs
- Consider switching license to [Polyform License Example](https://github.com/dosyago/DiskerNet/blob/fun/LICENSE.md)
- Determine whether or not https://webinstall.dev/vim-gui/ will add value to the VIM experience
- Find best Figma plugins here: https://www.figma.com/community/popular
## Docker
The following items are Docker containers that we may want to include as default containers deployed in our system.
- https://github.com/Infisical/infisical
- https://github.com/formbricks/formbricks
- https://github.com/chatwoot/chatwoot- https://docs.rundeck.com/docs/administration/install/installing-rundeck.html - Rundeck (Self-Service Desk)
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

https://github.com/Pythagora-io/gpt-pilot
    https://github.com/Aider-AI/aider
    https://follow.is/
    https://github.com/gitroomhq/postiz-app
    https://github.com/activepieces/activepieces
https://github.com/n8n-io/n8n
https://github.com/AppFlowy-IO/AppFlowy
dagger.io