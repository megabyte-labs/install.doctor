## Philosophy

The philosophy of this project basically boils down to "**_automate everything_**" and include the best development tools that might be useful without over-bloating the machine with services. Automating everything should include tasks like automatically accepting software terms in advance or pre-populating Portainer with certificates of all the Docker hosts you would like to control. One problem we face is that there are so many great tools offered on GitHub. A lot of research has to go into what to include and what to pass on. The decision of whether or not to include a piece of software in the default playbook basically boils down to:

- **Project popularity** - If one project has 10k stars and a similar alternative has 500 stars then 9 times of out 10 the more popular project is selected.
- **Last commit date** - We prefer software that is being actively maintained, for obvious reasons.
- **Cross platform** - Our playbook supports the majority of popular operating systems so we opt for cross-platform software. However, in some cases, we will include software that has limited cross-platform support like Xcode (which is only available on Mac OS X). If a piece of software is too good to pass up, it is added and only installed on the system(s) that support it.
- **Usefulness** - If a tool could potentially improve developer effectiveness then we are more likely to include it.
- **System Impact** - Software that can be run with a small RAM footprint and software that does not need a service to load on boot is much more likely to be included.

One of the goals of this project is to be able to re-provision a network with the click of a button. This might not be feasible since consumer-grade hardware usually does not include features like IPMI (which is a feature included in high-end motherboards that lets you control the power state remotely). However, we aim to reduce the amount of interaction required when re-provisioning an entire network down to the bare minimum. In the worst case scenario, you will have to reformat, reinstall the operating system, and ensure that OpenSSH is running (or WinRM in the case of Windows) on each of the computers in your network. However, the long term goal is to allow the user to reformat and reinstall the operating system used as your Ansible host using an automated USB installer and then automatically re-provision everything else on the network by utilizing IPMI.

You might ask, "But how can I retain application-level configurations?" We currently handle this by:

- Pre-defining dotfiles in a customizable Git repository
- Backing up to encrypted S3 buckets
- Syncing files to private git repositories
- Utilizing tools that synchronize settings like [mackup](https://github.com/lra/mackup) or [macprefs](https://github.com/clintmod/macprefs) in the case of macOS

However, we intentionally keep this synchronization to a minimum (i.e. only back up what is necessary). After all, one of the goals of this project is to be able to regularly flush the bad stuff off a system. By keeping what we back up to a minimum, we reduce the attack surface.
