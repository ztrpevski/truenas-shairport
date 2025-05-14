#!/bin/bash
# Start avahi-daemon in the background
service dbus start
avahi-daemon --daemonize

# Start shairport-sync in foreground
exec shairport-sync -c /etc/shairport-sync.conf -vv
exec bash
