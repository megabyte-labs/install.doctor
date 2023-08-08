---
title: LibreWolf Profile Import / Restore
description:        Restores the user's LibreWolf profile from the user's S3-backed Restic repository
sidebar_label: librewolf:profile:restore
slug: /cli/commands/librewolf-profile-restore
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/task/Taskfile.yml#L328
repoLocation: home/dot_config/task/Taskfile.yml
---
This command imports / restores the LibreWolf profile from the S3 Restic repository, if it exists. In order to use this
command for the first time, you should initialize LibreWolf by opening the application. You should also customize
the application by applying your preferred settings (i.e. customize it how you want it to open in the future). Then, after making
any changes you wish to be saved, you can backup the LibreWolf profile to the user's S3 bucket
by running the `librewolf:profile:backup` task. After this is done, you can restore the application
settings by running this command (i.e. `librewolf:profile:restore`).

The LibreWolf backup is encrypted with the same key that Chezmoi uses (stored in `~/.config/age/chezmoi.txt`, by default).
Since the backup leverages Restic, you can leverage all the functionality that Restic offers if something goes awry.

