#!/usr/bin/env bash

sudo find /usr/local/etc/clamav -type f -exec chmod 600 {} \;
sudo find /usr/local/etc/clamav -type f -exec chown clamav:wheel {} \;
sudo chmod u+x /usr/local/etc/clamav/clamav-email
