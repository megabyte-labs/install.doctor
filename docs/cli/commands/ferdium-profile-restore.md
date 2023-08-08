---
title: Ferdium Profile Import / Restore
description:          Restores the user's Ferdium profile from the user's S3-backed Restic repository
sidebar_label: ferdium:profile:restore
slug: /cli/commands/ferdium-profile-restore
githubLocation: https://github.com/megabyte-labs/install.doctor/blob/master/home/dot_config/task/Taskfile.yml#L218
repoLocation: home/dot_config/task/Taskfile.yml
---
This command imports / restores the Ferdium profile from the S3 Restic repository, if it exists. In order to use this
command for the first time, you should initialize Ferdium by opening the application. You should also customize
the application by applying your preferred settings (i.e. customize it how you want it to open in the future). Then, after making
any changes you wish to be saved, you can backup the Ferdium profile to the user's S3 bucket
by running the `ferdium:profile:backup` task. After this is done, you can restore the application
settings by running this command (i.e. `ferdium:profile:restore`).

The Ferdium backup is encrypted with the same key that Chezmoi uses (stored in `~/.config/age/chezmoi.txt`, by default).
Since the backup leverages Restic, you can leverage all the functionality that Restic offers if something goes awry.
