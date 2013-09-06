#!/bin/bash

AUTO_HOSTNAME=/usr/sbin/auto_hostname.sh
wget -O $AUTO_HOSTNAME https://raw.github.com/lieutdan13/sz-puppetmaster/master/files/ec2/auto_hostname.sh
chmod u+x $AUTO_HOSTNAME

sed -i 's@^exit 0@'${AUTO_HOSTNAME}'\nexit 0@' /etc/rc.local

$AUTO_HOSTNAME

echo "The bootstrap has been configured. Now reboot and test the hostname when the machine comes back up"
