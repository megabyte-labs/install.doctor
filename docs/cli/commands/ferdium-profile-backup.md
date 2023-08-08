---
title: Ferdium Profile Backup
description:           Backs up the user's Ferdium profile to the user's S3-backed Restic repository
sidebar_label: ferdium:profile:backup
slug: /cli/commands/ferdium-profile-backup
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/task/Taskfile.yml#L193
repoLocation: home/dot_config/task/Taskfile.yml
---
This command backups the Ferdium user data profile to an S3-backed Restic repository if the profile exists. If the repository
has not been initialized then it will initialize it. After you backup the profile, you can restore it with the
`ferdium:profile:restore` command like so:

```
run ferdium:profile:restore
```

The Ferdium backup is encrypted with the same key that Chezmoi uses (stored in `~/.config/age/chezmoi.txt`, by default).
The backup uses Restic so all the functionality that Restic offers is available with backups made by this command.

