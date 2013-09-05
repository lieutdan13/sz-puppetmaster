#!/bin/bash

if [ -f /root/.initialised ]; then
    exit 0
fi

THIS_SCRIPT=$0

USER_DATA=`/usr/bin/curl -s http://169.254.169.254/latest/user-data`
EC2_PUBLIC=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-hostname`
HOSTNAME=`echo "$USER_DATA" | grep -e '^hostname=' | cut -d = -f 2`
DOMAIN=`echo "$USER_DATA" | grep -e '^domain=' | cut -d = -f 2`

FQDN=$HOSTNAME.$DOMAIN

if [ "$FQDN" == "" ]; then
    echo "No hostname found in user metadata"
    exit 0
fi

#set also the hostname to the running instance
echo $FQDN > /etc/hostname
hostname $FQDN

#Add a static entry in the hosts file
echo "127.0.0.1 localhost $HOSTNAME $FQDN" > /etc/hosts

MESSAGE="The hostname has been set to $FQDN"
logger $MESSAGE

#Configure and install puppet
echo "server=puppet.schaeferzone.net" >> /etc/puppet/puppet.conf
apt-get -y install puppet

MESSAGE1="The machine is now ready for its first puppet run"
logger $MESSAGE1


cat<<EOF > /etc/update-motd.d/40-autohostname
#!/bin/bash
# auto generated on boot by ${THIS_SCRIPT} via rc.local
echo "$MESSAGE"
echo "$MESSAGE1"

EOF

chmod +x /etc/update-motd.d/40-autohostname

#Add the file that is checked above, so that this script doesn't run again
touch /root/.initialised

exit 0
