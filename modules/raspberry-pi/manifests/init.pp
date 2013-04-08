# == Class: raspberry-pi
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
class raspberry-pi {

	define purge_package {
		package { $name: ensure => 'purged' }
	}
	$remove_packages = [
		'alsa-utils',
		'console-setup',
		'lightdm',
		'obconf',
		'openbox',
		'python-pygame',
		'python-tk',
		'python3-tk',
		'xarchiver',
		'xauth',
		'xinit',
		'xserver-common',
		'xserver-xorg',
		'x11-xfs-utils',
		'x11-xserver-utils',
		]
	purge_package { $remove_packages:; }

	exec { "remove-xserver-dependencies":
		command => "/usr/bin/apt-get -y autoremove",
		subscribe => Package["xserver-xorg"],
		refreshonly => true,
	}

	file { "/tmp/raspberryipi":
		ensure => present,
	}
}
