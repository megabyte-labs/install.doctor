<!-- ⚠️ This README has been generated from the file(s) ".config/docs/blueprint-readme-misc.md" ⚠️--><div align="center">
  <center>
    <a href="https://github.com/megabyte-labs/hiawatha-dotfiles">
      <img width="148" height="148" alt="Hiawatha Dotfiles logo" src="https://gitlab.com/megabyte-labs/hiawatha-dotfiles/-/raw/master/logo.png" />
    </a>
  </center>
</div>
<div align="center">
  <center><h1 align="center"><i></i>Hiawatha Dotfiles - The Spirit of GitHub<i></i></h1></center>
  <center><h4 style="color: #18c3d1;">Maintained by <a href="https://megabyte.space" target="_blank">Megabyte Labs</a></h4><i></i></center>
</div>

<div align="center">
  <a href="https://megabyte.space" title="Megabyte Labs homepage" target="_blank">
    <img alt="Homepage" src="https://img.shields.io/website?down_color=%23FF4136&down_message=Down&label=Homepage&logo=home-assistant&logoColor=white&up_color=%232ECC40&up_message=Up&url=https%3A%2F%2Fmegabyte.space&style=for-the-badge" />
  </a>
  <a href="https://github.com/megabyte-labs/hiawatha-dotfiles/blob/master/docs/CONTRIBUTING.md" title="Learn about contributing" target="_blank">
    <img alt="Contributing" src="https://img.shields.io/badge/Contributing-Guide-0074D9?logo=github-sponsors&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/" title="Chat with us on Slack" target="_blank">
    <img alt="Slack" src="https://img.shields.io/badge/Slack-Chat-e01e5a?logo=slack&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://gitter.im/megabyte-labs/community" title="Chat with the community on Gitter" target="_blank">
    <img alt="Gitter" src="https://img.shields.io/gitter/room/megabyte-labs/community?logo=gitter&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://github.com/megabyte-labs/hiawatha-dotfiles" title="GitHub mirror" target="_blank">
    <img alt="GitHub" src="https://img.shields.io/badge/Mirror-GitHub-333333?logo=github&style=for-the-badge" />
  </a>
  <a href="https://gitlab.com/megabyte-labs/hiawatha-dotfiles" title="GitLab repository" target="_blank">
    <img alt="GitLab" src="https://img.shields.io/badge/Repo-GitLab-fc6d26?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHJJREFUCNdNxKENwzAQQNEfWU1ZPUF1cxR5lYxQqQMkLEsUdIxCM7PMkMgLGB6wopxkYvAeI0xdHkqXgCLL0Beiqy2CmUIdeYs+WioqVF9C6/RlZvblRNZD8etRuKe843KKkBPw2azX13r+rdvPctEaFi4NVzAN2FhJMQAAAABJRU5ErkJggg==&style=for-the-badge" />
  </a>
</div>

> </br><h4 align="center">**A glorious combination of application settings, theme files, and a performant cross-platform, desktop-oriented software installer.**</h4></br>

<a href="#table-of-contents" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Table of Contents

    * [Overview](#overview)

- [}Hiawatha](#hiawatha)
  - [Contributing](#contributing)
    - [Affiliates](#affiliates)
  - [License](#license)

<a href="#overview" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Overview

Hiawatha Dotfiles is a glorious combination of application settings, theme files, and a performant yet flexible software installer written with [ZX](https://github.com/google/zx). The installer supports almost any operating system, just checkout the [software.yml file](https://gitlab.com/megabyte-labs/hiawatha-dotfiles/-/blob/master/software.yml). It uses [Chezmoi](https://github.com/twpayne/chezmoi) to apply file changes in an interactive way. It is not your typical Chezmoi project - it is built around the philosophy that you should be able to bash all your computers to bits with a hammer and then resurrect them the next day ✝️️ by storing stateful data to an S3 bucket and automating desktop configuration as much as possible.

<a href="#hiawatha" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

# }Hiawatha

This is a decked out dotfiles repository that leverages a handful of technologies including Chezmoi, Ansible, and ZX to provision computers. It is built to support Archlinux, Fedora, CentOS, Debian, Ubuntu, macOS, and Windows but you may see code that suggests other OSes will be supported as well. It includes themeing (most of the credit going to [Sweet](https://github.com/EliverLara/Sweet)) for KDE / GNOME / apps.

To use these dotfiles and provision your computer with prompts (which can be made headless with environment variables):

```
bash <(curl -sSL https://install.doctor/start)
```

All the source files are located in ~/.local/share/chezmoi/home for the dotfiles and ~/.local/share/chezmoi/system for the system files. The roles / playbooks from [Gas Station](https://gitlab.com/megabyte-labs/gas-station) are occasionally used to fill in gaps. The software installation (which happens when you run Chezmoi or the link above) determines which package manager to use to install the software using [this software map](https://gitlab.com/megabyte-labs/misc/dotfiles/-/blob/master/.local/share/chezmoi/software.yml).

Many of the dotfiles (and system files) are templated. Those ones you will have to look at ~/.local/share/chezmoi to take a peek at. The static files are at the root of this repository for easy viewing.

<a href="#contributing" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/megabyte-labs/hiawatha-dotfiles/issues). If you would like to contribute, please take a look at the [contributing guide](https://github.com/megabyte-labs/hiawatha-dotfiles/blob/master/docs/CONTRIBUTING.md).

<details>
<summary><b>Sponsorship</b></summary>
<br/>
<blockquote>
<br/>
Dear Awesome Person,<br/><br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

**_Brian Zalewski_**<br/><br/>

</blockquote>

<a title="Support us on Open Collective" href="https://opencollective.com/megabytelabs" target="_blank">
  <img alt="Open Collective sponsors" src="https://img.shields.io/opencollective/sponsors/megabytelabs?logo=opencollective&label=OpenCollective&logoColor=white&style=for-the-badge" />
</a>
<a title="Support us on GitHub" href="https://github.com/ProfessorManhattan" target="_blank">
  <img alt="GitHub sponsors" src="https://img.shields.io/github/sponsors/ProfessorManhattan?label=GitHub%20sponsors&logo=github&style=for-the-badge" />
</a>
<a href="https://www.patreon.com/ProfessorManhattan" title="Support us on Patreon" target="_blank">
  <img alt="Patreon" src="https://img.shields.io/badge/Patreon-Support-052d49?logo=patreon&logoColor=white&style=for-the-badge" />
</a>

### Affiliates

Below you will find a list of services we leverage that offer special incentives for signing up for their services through our special links:

<a href="http://eepurl.com/h3aEdX" title="Sign up for $30 in MailChimp credits" target="_blank">
  <img alt="MailChimp" src="https://cdn-images.mailchimp.com/monkey_rewards/grow-business-banner-2.png" />
</a>
<a href="https://www.digitalocean.com/?refcode=751743d45e36&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge">
  <img src="https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg" alt="DigitalOcean Referral Badge" />
</a>

</details>

<a href="#license" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## License

Copyright © 2020-2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](https://gitlab.com/megabyte-labs/hiawatha-dotfiles/-/blob/master/LICENSE) licensed.
