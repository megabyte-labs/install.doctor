## Philosophy

When you are working with one of our Ansible projects, try asking yourself, "**How can this be improved?**" For example, in the case of the [Android Studio role](https://github.com/ProfessorManhattan/ansible-androidstudio), the role installs Android Studio but there may be additional tasks that should be automated. Consider the following examples:

- _The software is installed but is asking for a license key._ - In this case, we should provide an option for automatically installing the license key using a CLI command.
- _The software supports plugins_ - We should provide an option for specifying the plugins that are automatically installed.
- _In the case of Android Studio, many users have to install SDKs before using the software._ - We should offer the capability to automatically install user-specified SDKs.
- _The software has configuration files with commonly tweaked settings._ - We should provide the ability to change these settings via variables stored in `defaults/main.yml`.
- _The software has the capability to integrate with another piece of software in the [main playbook]({{ repository.playbooks }})_. - This integration should be automated.

Ideally, you should use the software installed by the [main playbook]({{ repository.playbooks }}). This is really the only way of testing whether or not the software was installed properly and has all the common settings automated. The software installed by the main playbook is all widely-acclaimed, cross-platform software that many people find useful.
