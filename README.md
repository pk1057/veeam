# veeam
This is a docker container to allow installation of veeam linux backup client.

For me, the special purpose was to get my unraid server backed up.

You need at least two mount points, one for the directory/s to backup and one for the key and veeam installation /opt/veeam.

A reachable ip/address or dns name is important.

The docker container needs to be running in provileged mode because we need a working systemd


