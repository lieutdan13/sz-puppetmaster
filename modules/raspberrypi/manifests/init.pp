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

	define purge_package {
		package { $name: ensure => 'purged' }
	}
	$remove_packages = [
                'xserver-common',
                'xserver-xorg',
                'x11-xfs-utils',
                'x11-xserver-utils',
                'xinit'
		]
	purge_package { $remove_packages:; }

	exec { "remove-xserver-dependencies":
		command => "apt-get -y autoremove",
		subscribe => Package["xserver-xorg"],
		refreshonly => true,
	}

	file { "/tmp/raspberrypi":
		ensure => present,
	}
}
