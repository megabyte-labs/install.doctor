#!/usr/bin/env bash

sudo find /etc/clamav -type f -exec chmod 600 {} \;
sudo find /etc/clamav -type f -exec chown clamav:wheel {} \;
sudo chmod u+x /etc/clamav/clamav-email
