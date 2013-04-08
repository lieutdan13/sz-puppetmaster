# == Class: raspberrypi
#
# Configuration specifically for the Raspberry Pi.
# Removes unnecessary packages not required for a
# headless server.
#
# === Authors
#
# Dan Schaefer <dan_at_schaeferzone.net>
#
# === Copyright
#
# Copyright 2013 Dan Schaefer, unless otherwise noted.
#
class raspberrypi {

	package { [
                'xserver-common',
                'x11-xfs-utils',
                'x11-xserver-utils',
                'xinit''
		]:
		ensure => 'purged'
	}

	exec { "remove-xserver-dependencies"
		command => "apt-get -y autoremove",
		subscribe => Package["xserver-common"],
		refreshonly => true,
	}
}
