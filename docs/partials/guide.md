Sexy Start is a cross-platform development environment provisioning system. The project began as an ongoing Ansible project named [Gas Station](https://github.com/megabyte-labs/gas-station) but transitioned to a dotfile-ish approach for easier adoption and less overhead. It is intended for:

1. Power users that want to maximize their long-term efficiency by incorporating the [most-starred applications / projects / CLIs on GitHub](https://stars.megabyte.space) into their stack.
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

If you fork this repository and would like to use your fork as the source, you can still use the command shown above by setting the `START_REPO` environment variable. If it is located on GitHub, you can do this by running:

```
START_REPO=my-gh-user/my-fork-name bash <(curl -sSL https://install.doctor/start)
```

Alternatively, if you want to host your project on GitLab or another git provider, then just specify the git remote's URL:

```
START_REPO=git@gitlab.com:megabyte-labs/sexy-start.git bash <(curl -sSL https://install.doctor/start)
```

### Quick Start Notes

* The quick start script is tested on the latest versions of Archlinux, CentOS, Debian, Fedora, macOS, and Ubuntu
* The quick start script is the preferred method of using this project to provision your system
* The script can be configured to be completely headless by specifying environment variables which are detailed below
* _Windows support is on the roadmap._

## Chezmoi-Based

This project leverages [Chezmoi](https://github.com/twpayne/chezmoi) to provide:

1. File diffs that show how files are being changed
2. Easy-to-use encryption that lets you store private data publicly on GitHub
3. A basic set of prompts that accept and integrate API credentials for services like CloudFlare, GitHub, GitLab, and Slack so that your development environment is augmented by free cloud services

## Security Focused

This software was built in an adversarial environment. This led towards a focus on security which is why we employ technologies like [Firejail](https://github.com/netblue30/firejail), [Portmaster](https://safing.io/), [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html), and [Qubes](https://www.qubes-os.org/). Whenever possible, Flatpaks are used as the preferred application type. This also led to an emphasis on performance. When your workstation is possibly compromised or you have a good habit of reformatting your workstation on regular basis then it makes sense to use a provisioning system that can restore the workstation to a similar state quicker.

## Cross-Platform

This project has been developed with support for Archlinux, CentOS, Fedora, macOS, Ubuntu, and Windows. Almost all the testing has been done on x86_64 systems but the system is flexible enough to be adapted for other systems such as ARM or FreeBSD. A lot of effort has also gone into supporting Qubes which, when fully provisioned, is basically a combination of all the operating systems we have developed this project for.

### Custom Software Provisioning System

The project also incorporates a custom [ZX](https://github.com/google/zx) script that allows you to choose which package managers you would like to manage your software. It attempts to be as asynchronous as possible without opening the door to errors. The script leverages the [software.yml](/software.yml) file in the root of this repository to figure out which package manager to use. By default, the installer will choose the most secure option (e.g. Flatpaks are preferred for Linux applications). The installer is more performant and less error-prone than our Ansible variant. It also makes it a lot easier to add software to your stack in such a way that you can keep the software regardless of what operating system you are using by storing everything in the aforementioned `software.yml` file.

### Beautiful Anywhere

Windows and macOS do a great job of making things look good from a UI perspective out of the box. Linux on the other hand requires some finessing especially when you follow our philosophy of taking many different operating systems and deploying similar software on them. A sizable amount of effort went into customizing the popular [Sweet](https://github.com/EliverLara/Sweet) theme and adapting it to our liking. Bells and whistles like a customized GRUB2 and Plymouth theme are included.

### Qubes Support

Qubes support is on its way.

## Gas Station

This project began as something to supplement our provisioning system that uses Ansible. The system is called [Gas Station](https://gitlab.com/megabyte-labs/gas-station). It includes hundreds of Ansible roles. If you look at the [`software.yml`](/sexy-start) file, you will notice that some of the Ansible roles that Gas Station provides are inside of it. By default, this project will try to install software / dependencies using other, lighter methods before resorting to using Ansible. This is because of the software installer order that is defined at the top of the software.yml file. Gas Station is also still used to house some of the variables / data that this project uses.

## Chezmoi

This project uses Chezmoi to orchestrate the provisioning. After calling the quick start script shown above, the quick start script will ensure some dependencies are installed (including Chezmoi) and then initiate Chezmoi. In order to customize this project, you should head over to the Chezmoi documentation to get a better understanding of why some of the files in this repository start with `dot_`, `run_`, etc.

### Resetting Chezmoi

This script is designed to run only the code that is necessary to improve performance. This is accomplished by using [`.chezmoiscripts`](home/.chezmoiscripts), Chezmoi's `onchange_` identifier, and a custom installer written in ZX that is powered by the software definitions in [`software.yml`](software.yml).

If there is an error during the provision process or you make changes that are not being run during the provision process then you might want to clear Chezmoi's cache and configuration. This can be done on macOS/Linux by running:

```
rm -rf ~/.config/chezmoi && rm -rf ~/.cache/chezmoi
```
