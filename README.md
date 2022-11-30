# Hiawatha

This is a decked out dotfiles repository that leverages a handful of technologies including Chezmoi and Ansible.

To use these dotfiles and provision your computer with prompts (which can be made headless with environment variables):

```
bash <(curl -sSL https://install.doctor/start)
```

All the source files are located in ~/.local/share/chezmoi/home for the dotfiles and ~/.local/share/chezmoi/system for the system files. The roles / playbooks from [Gas Station](https://gitlab.com/megabyte-labs/gas-station) are occasionally used to fill in gaps. The software installation (which happens when you run Chezmoi or the link above) determines which package manager to use to install the software using [this software map](https://gitlab.com/megabyte-labs/misc/dotfiles/-/blob/master/.local/share/chezmoi/software.yml).

Many of the dotfiles (and system files) are templated. Those ones you will have to look at ~/.local/share/chezmoi to take a peek at. The static files are at the root of this repository for easy viewing.
