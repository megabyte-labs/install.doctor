#!/usr/bin/env bash

sudo find /var/log/clamav -type f -exec chmod 600 {} \;
sudo find /var/log/clamav -type f -exec chown clamav:wheel {} \;