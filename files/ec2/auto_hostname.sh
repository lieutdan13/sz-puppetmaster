#!/bin/bash

THIS_SCRIPT=$0

USER_DATA=`/usr/bin/curl -s http://169.254.169.254/latest/user-data`
EC2_PUBLIC=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-hostname`
HOSTNAME=`echo "$USER_DATA" | grep -e '^hostname=' | cut -d = -f 2`
DOMAIN=`echo "$USER_DATA" | grep -e '^domain=' | cut -d = -f 2`

#set also the hostname to the running instance
FQDN=$HOSTNAME.$DOMAIN
hostname $FQDN

MESSAGE="The hostname has been set to $FQDN"

logger $MESSAGE

cat<<EOF > /etc/update-motd.d/40-autohostname
#!/bin/bash
# auto generated on boot by ${THIS_SCRIPT} via rc.local
echo "$MESSAGE"

EOF

chmod +x /etc/update-motd.d/40-autohostname

exit 0
