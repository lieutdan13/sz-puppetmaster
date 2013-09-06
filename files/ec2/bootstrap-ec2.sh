#!/bin/bash

if [ "`whoami`" != "root" ]; then
	echo "You must be root"
	exit 1
fi

AUTO_HOSTNAME=/usr/sbin/auto_hostname.sh
wget -O $AUTO_HOSTNAME https://raw.github.com/lieutdan13/sz-puppetmaster/master/files/ec2/auto_hostname.sh
chmod u+x $AUTO_HOSTNAME

sed -i 's@^exit 0@'${AUTO_HOSTNAME}'\nexit 0@' /etc/rc.local

$AUTO_HOSTNAME

sed -i 's/^\[main\]/[main]\nserver=puppet.schaeferzone.net\npluginsync=true/' /etc/puppet/puppet.conf
puppet agent -t
echo "Run the following command on the puppet master"; echo
echo "sudo puppet cert sign $HOSTNAME"; echo
echo "Press [ENTER] to continue"
read
puppet agent -t

echo "The bootstrap has been configured. Now reboot and test the hostname when the machine comes back up"
