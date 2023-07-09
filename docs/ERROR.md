```
🍺  /usr/local/Cellar/sftpgo/2.5.3: 174 files, 50.3MB
==> Running `brew cleanup sftpgo`...
Removing: /usr/local/Cellar/sftpgo/2.5.2... (174 files, 50.2MB)
==> Upgrading angular-cli
  16.1.1 -> 16.1.4

==> Pouring angular-cli--16.1.4.ventura.bottle.tar.gz
🍺  /usr/local/Cellar/angular-cli/16.1.4: 6,965 files, 31.2MB
==> Running `brew cleanup angular-cli`...
Removing: /usr/local/Cellar/angular-cli/16.1.1... (6,970 files, 31.2MB)
==> Upgrading docker-compose
  2.19.0 -> 2.19.1

==> Pouring docker-compose--2.19.1.ventura.bottle.tar.gz
Error: The `brew link` step did not complete successfully
The formula built, but is not symlinked into /usr/local
Could not symlink bin/docker-compose
Target /usr/local/bin/docker-compose
already exists. You may want to remove it:
  rm '/usr/local/bin/docker-compose'

To force the link and overwrite all conflicting files:
  brew link --overwrite docker-compose

To list all files that would be deleted:
  brew link --overwrite --dry-run docker-compose

Possible conflicting files are:
/usr/local/bin/docker-compose -> /Applications/Docker.app/Contents/Resources/bin/docker-compose
==> Caveats
Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
  mkdir -p ~/.docker/cli-plugins
  ln -sfn /usr/local/opt/docker-compose/bin/docker-compose ~/.docker/cli-plugins/docker-compose
```