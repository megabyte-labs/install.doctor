**DISCLAIMER:** _Currently this project has only been fully tested on macOS. Support for the other operating systems still requires a little bit of testing since we migrated architectures._

Hiawatha is a cross-platform development environment provisioning system. The project began as an ongoing Ansible project named [Gas Station](https://github.com/megabyte-labs/gas-station) but transitioned to a dotfile-ish approach for easier adoption and less overhead. It is intended for:

1. Power users that want to maximize their long-term efficiency by incorporating the [most-starred applications / projects / CLIs on GitHub]() into their stack.
2. Users that distro hop but want to retain their favorite tools regardless of whether they are using macOS, Windows, or Linux
3. People that want to reformat their computers on a, perhaps, daily basis while retaining stateful elements of their file system by leveraging S3 buckets
4. Enthusiasts that want to deploy as many cool, useful tools as possible without having to spend much time configuring their file system
5. Perfectionists that love software that behaives as it should, looks gorgeous (desktop preview screenshots below), and performs tasks quickly on any platform
6. CLI ninjas that want to bring their set of tools wherever they go

## Quick Start

To provision your workstation, you can run the following which will install some basic dependencies (e.g. Chezmoi) and provide interactive prompts where you can personalize your configuration:

```
bash <(curl -sSL https://install.doctor/start)
```

_Windows support is on its way._

## Chezmoi-Based

This project leverages [Chezmoi](https://github.com/twpayne/chezmoi) to provide:

1. File diffs that show how files are being changed
2. Easy-to-use encryption that lets you store private data publicly on GitHub
3. A basic set of prompts that accept and integrate API credentials for services like CloudFlare, GitHub, GitLab, and Slack so that your development environment is augmented by free cloud services

## Security Focused

This software was built in an adversarial environment. This led towards a focus on security which is why we employ technologies like [Firejail](https://github.com/netblue30/firejail), [Portmaster](https://safing.io/), [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html), and [Qubes](https://www.qubes-os.org/). This also led to an emphasis on performance. When your workstation is possibly compromised or you have a good habit of reformatting your workstation on regular basis then it makes sense to use a provisioning system that can restore the workstation to a similar state quicker.

## Cross-Platform

This project has been developed with support for Archlinux, CentOS, Fedora, macOS, Ubuntu, and Windows. Almost all the testing has been done on x86_64 systems but the system is flexible enough to be adapted for other systems such as ARM or FreeBSD. A lot of effort has also gone into supporting Qubes which, when fully provisioned, is basically a combination of all the operating systems we have developed this project for.

### Custom Software Provisioning System

The project also incorporates a custom [ZX](https://github.com/google/zx) script that allows you to choose which package managers you would like to manage your software. It attempts to be as asynchronous as possible without opening the door to errors. The script leverages the [software.yml](https://github.com/megabyte-labs/hiawatha-dotfiles/blob/master/software.yml) file in the root of this repository to figure out which package manager to use. By default, the installer will choose the most secure option (e.g. Flatpaks are preferred for Linux applications). The installer is more performant and less error-prone than our Ansible variant. It also makes it a lot easier to add software to your stack in such a way that you can keep the software regardless of what operating system you are using by storing everything in the aforementioned `software.yml` file.

### Beautiful Anywhere

Windows and macOS do a great job of making things look good from a UI perspective out of the box. Linux on the other hand requires some finessing especially when you follow our philosophy of taking many different operating systems and deploying similar software on them. A sizable amount of effort went into customizing the popular [Sweet](https://github.com/EliverLara/Sweet) theme and adapting it to our liking. Bells and whistles like a customized GRUB2 and Plymouth theme are included.

### Qubes Support

Qubes support is on its way.
