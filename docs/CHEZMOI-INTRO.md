## User / Environment Variable Configuration

This script will automatically set up a handful of different configurations / integrations
if you decide to add your information. The script will first check for environment variables
and then show prompts to fill in the gaps if the system is not headless. Below you can find
a description of what each piece of information is used for as well as the name of the
environment variable you can specify to bypass the prompt.

If a description starts off with **Environment Variable Only** then the prompt system will not ask you for the default value. Instead, you should run `export VARIABLE_NAME="VALUE_HERE"` for each value you want to utilize before you proceed with the provisioning.

### Fork / Source Repository

To use a fork (if you made modifications to the original project), set this equal to one of the following:

1. Your GitHub username if you forked this project and the project slug is Sexy-Start
2. Your GitHub username / slug if you changed it from Sexy-Start (e.g. `ProfessorManhattan/Sexy-Start`)
3. A git remote URL (e.g. `git@gitlab.com:megabyte-labs/sexy-start`)

* Environment variable: `START_REPO`

Note, this variable is used by the `bash <(curl -sSL https://install.doctor/start)` command and is not used anywhere in the project itself.

### Work Environment

Set to true if you are setting up a work environment where things like Tor should
not be installed.

* Environment variable: `WORK_ENVIRONMENT`

### Restricted Environment

Set to true if you are setting up an environment that should not use sudo / administrator
privileges. This is a WIP.

* Environment variable: `RESTRICTED_ENVIRONMENT`

### Software Group

The category you select for software group will determine which list of software should be
installed. The lists are configurable by modifying `~/.local/share/chezmoi/software.yml`.

* Environment variable: `SOFTWARE_GROUP`

### Name

Enter your full name as you would like it to appear in configuration files such as the Git
configuration.

* Environment variable: `FULL_NAME`

### E-mail

Enter your primary e-mail address.

* Environment variable: `PRIMARY_EMAIL`

### Public GPG Key ID

**Environment Variable Only** If you have a public GPG key available on the Ubuntu or MIT keyservers, then you can enter it
so that it is automatically imported.

* Environment variable: `KEYID`

### Timezone

Enter your timezone in the format of `America/New_York`. It should be available in the TZ database.

* Environment variable: `TIMEZONE`

### Domain

The domain address you would like to use for any part of the deployment that involves launching
a publicly web service.

* Environment variable: `PUBLIC_SERVICES_DOMAIN`

### CloudFlare API Token

The API token is used to automatically configure various web services that rely on public DNS
records.

* Environment variable: `CLOUDFLARE_API_TOKEN`

### GitHub Gist Token

**Environment Variable Only** Pass in a GitHub token with the `gist` scope to be able to use the `gist` CLI tool without having to authenticate.

* Environment variable: `GITHUB_GIST_TOKEN`

### GitHub Read-Only Token

**Environment Variable Only** Pass in a GitHub read-only token linked to your account to automatically save a backup of your
GitHub repositories. For more information, see [this link](https://github.com/gabrie30/ghorg#scm-provider-setup).

* Environment variable: `GITHUB_READ_TOKEN`

### GitLab Read-Only Token

**Environment Variable Only** Pass in a GitLab read-only token linked to your account to automatically save a backup of your
GitLab repositories. For more information, see [this link](https://github.com/gabrie30/ghorg#scm-provider-setup).

* Environment variable: `GITLAB_READ_TOKEN`

### G-mail Address

**Environment Variable Only** Add a G-mail address which you would like to use as the handler for outgoing SMTP mail.

* Environment variable: `GMAIL_ADDRESS`

### G-mail App Password

**Environment Variable Only** Add the app password to your G-mail address so that outgoing mail can be handled by G-mail.

* Environment variable: `GMAIL_APP_PASSWORD`

### Ngrok Authentication Token

**Environment Variable Only** Add your Ngrok authentication token so that the configuration file can be automatically
generated.

* Environment Variable: `NGROK_AUTH_TOKEN`

### Slack API Token

**Environment Variable Only** Add your Slack API token so that `slackterm` can be automatically set up.

* Environment Variable: `SLACK_API_TOKEN`

### Tailscale Auth Key

**Environment Variable Only** Add a Tailscale authentication key so that Tailscale can be automatically connected to your Tailscale network.

* Environment Variable: `TAILSCALE_AUTH_KEY`
