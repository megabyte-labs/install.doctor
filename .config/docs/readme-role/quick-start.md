## Quick Start

Looking to install {{ name }} without having to deal with [Ansible](https://www.ansible.com/)? Simply run the following command that correlates to your operating system:

**Linux/macOS:**

```shell
curl -sS {{ link.installdoctor }}/{{ galaxy_info.role_name }} | bash
```

**Windows:**

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://install.doctor/{{ galaxy_info.role_name }}?os=win'))
```

**Important Note:** _Before running the commands above you should probably directly access the URL to make sure the code is legit. We already know it is safe but, before running any script on your computer, you should inspect it._

You can also check out **[Install Doctor]({{ link.installdoctor }})**. It is an app we created that can install any Ansible role with a one-liner. It has some other nifty features too like the ability to install binaries on-the-fly without requiring a password. However, if you would like to incorporate this role into an Ansible playbook (and customize settings) then please continue reading below.
