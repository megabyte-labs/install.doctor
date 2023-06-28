#!/bin/bash

/usr/libexec/ApplicationFirewall/socketfilterfw --add --service "Plex" --getglobalstate
/usr/libexec/ApplicationFirewall/socketfilterfw --service "Plex" --setglobaldescription "."
/usr/libexec/ApplicationFirewall/socketfilterfw --service "Plex" --add --port 32400 --protocol tcp
/usr/libexec/ApplicationFirewall/socketfilterfw --service "Plex" --add --port 1900 --protocol udp
/usr/libexec/ApplicationFirewall/socketfilterfw --service "Plex" --add --port 32469 --protocol tcp
/usr/libexec/ApplicationFirewall/socketfilterfw --service "Plex" --add --port 32410 --protocol udp
/usr/libexec/ApplicationFirewall/socketfilterfw --service "Plex" --add --port 32412 --protocol udp
/usr/libexec/ApplicationFirewall/socketfilterfw --service "Plex" --add --port 32413 --protocol udp
/usr/libexec/ApplicationFirewall/socketfilterfw --service "Plex" --add --port 32414 --protocol udp
