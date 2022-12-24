## Requirements

- **[Python >=3.7](https://www.python.org/)**
- **[Ansible >=2.9](https://www.ansible.com/)**
- Ansible controller should be a macOS/Linux environment (WSL/Docker can be used on Windows)

### Host Requirements

There are Python and Ansible package requirements need to be installed by running the following command (or equivalent) in the root of this repository:

```
pip3 install -r .config/requirements.txt
ansible-galaxy install requirements.yml
```

#### Easier Method of Installing the Host Requirements

You can also run `bash start.sh` if you do not mind development dependencies being installed as well. This method will even handle installing Python 3 and Ansible.

### Operating System

**This playbook is built and tested to run on fresh installs of Windows, Mac OS X, Ubuntu, Fedora, Debian, CentOS, Archlinux, and Qubes**. It may still be possible to run the playbook on your current machine. However, installing the playbook on a fresh install is the only thing we actively support. That said, if you come across an issue with an environment that already has configurations and software present, please do not hesitate to [open an issue]({{ repository.gitlab }}{{ repository.location.issue.gitlab }}).

### Connection

SSH (or WinRM in the case of Windows) and Python should be available on the target systems you would like to provision. If you are attempting to provision a Windows machine, you can ensure that WinRM is enabled and configured so that you can remotely provision the Windows target by running the following command with PowerShell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://install.doctor/windows-client'))
```

### MAS on Mac OS X

We use [mas](https://github.com/mas-cli/mas) to install apps from the App Store in some of our roles. Sadly, automatically signing into the App Store is not possible on OS X 10.13+ via mas. This is because [mas no longer supports login functionality on OS X 10.13+](https://github.com/mas-cli/mas/issues/164).

There is another caveat with mas. In order to install an application using mas, the application has to have already been added via the App Store GUI. This means that the first time around you will have to install the apps via the App Store GUI so they are associated with your App Store account.
