#node.pp
node default {
	include utility
	include puppetagent

	class { "ntp":
	        ensure     => running,
	        servers    => [ 'time1.google.com', 'time2.google.com', 'time3.google.com', 'time4.google.com' ],
		autoupdate => true,
	}
}

#This only applies to non-masters
node puppetagent inherits default {
	class { 'puppetagent::agent_only': }
}

node big-bang inherits default {
	class { "network::interfaces":
		interfaces => {
			"eth0" => {
				"method"     => "static",
				"address"    => "192.168.10.5",
				"netmask"    => "255.255.255.0",
				"gateway"    => "192.168.10.1",
				"dns-domain" => "schaeferzone.net",
				"dns-search" => "schaeferzone.net marketmaps.co",
				"dns-nameservers" => "$local_dns_ip 8.8.8.8 8.8.4.4",
			}
		},
		auto => ["eth0"]
	}

	include puppetmaster
	include sshauth::keymaster
	include devops::key
	include devops::client

	sshauth::user::config { "devops":
		user        => "devops",
		ssh_aliases => {
			"github.com" => {
				"hostname" => "github.com",
				"user"     => "git",
				"file"     => "~/.ssh/devops@big-bang"
			},
			"raspberrypi.schaeferzone.net raspberrypi" => {
				"hostname" => "raspberrypi.schaeferzone.net",
				"user"     => "devops",
				"file"     => "~/.ssh/devops@schaeferzone.net"
			},
		},
	}

	sshauth::user::config { "root":
		user        => "root",
		ssh_aliases => {
			"github.com" => {
				"hostname" => "github.com",
				"user"     => "git",
				"file"     => "~devops/.ssh/devops@big-bang"
			},
			"raspberrypi.schaeferzone.net raspberrypi" => {
				"hostname" => "raspberrypi.schaeferzone.net",
				"user"     => "devops",
				"file"     => "~devops/.ssh/devops@schaeferzone.net"
			},
		},
	}
	include sz-dns::client

	class { 'virtualbox::guest_additions':
		ensure  => present,
		version => '4.2.12',
	}
}

node nebula inherits puppetagent {
	include devops::client
	include sz-dns::client

	#Web/DB server
	class { 'php': }
	php::module { 'gd': }
	class { 'apache': }
	apache::module { 'rewrite': }
	apache::module { 'php5': }
	class { 'mysql': }

	file { '/home/dschaefer/public_html':
		ensure => directory,
		group  => dschaefer,
		owner  => dschaefer,
	}
	class { 'schaeferzone_net::site::dev_cars':
		group => 'dschaefer',
		owner => 'dschaefer',
		path  => '/home/dschaefer/public_html/dev.cars.schaeferzone.net',
	}
}

node 'puppet-dev' inherits puppetagent {
	class { "network::interfaces":
		interfaces => {
			"eth0" => {
				"method"     => "static",
				"address"    => "192.168.10.35",
				"netmask"    => "255.255.255.0",
				"gateway"    => "192.168.10.1",
				"dns-domain" => "schaeferzone.net",
				"dns-search" => "schaeferzone.net marketmaps.co",
				"dns-nameservers" => "192.168.10.10",
			}
		},
		auto => ["eth0"]
	}
	include devops::client
	include sz-dns::client

	#Imapfilter
	class { 'sz-misc::imapfilter': }

	#Web/DB server
	class { 'php': }
	php::module { 'gd': }
	php::module { 'mysql': }
	class { 'apache': }
	apache::module { 'rewrite': }
	apache::module { 'php5': }
	class { 'mysql': }

	include worryfreeincome::www
}

node raspberrypi inherits puppetagent {
	class { "network::interfaces":
		interfaces => {
			"eth0" => {
				"method"     => "static",
				"address"    => "192.168.10.10",
				"netmask"    => "255.255.255.0",
				"gateway"    => "192.168.10.1",
				"dns-domain" => "schaeferzone.net",
				"dns-search" => "schaeferzone.net marketmaps.co",
				"dns-nameservers" => "127.0.0.1 8.8.8.8 8.8.4.4",
			}
		},
		auto => ["eth0"]
	}
	include devops::client
	include devops::server
	include sz-dns::server

	#Mounted drives	
	file { "/mnt/lexar-usb":
		ensure  => "directory",
		owner   => "devops",
		group   => "devops",
		mode    => 755,
		require => Sshclientuser['devops'],
	}

	mount { "/mnt/lexar-usb":
		device  => "/dev/disk/by-uuid/9857-7817",
		fstype  => "vfat",
		ensure  => "mounted",
		options => "defaults,uid=$devops_uid,gid=$devops_uid,fmask=0133,dmask=0022",
		atboot  => "true",
		require => File["/mnt/lexar-usb"],
	}
	
	file { "/mnt/WD2500YS":
		ensure => "directory",
		owner  => "root",
		group  => "root",
		mode   => 755,
	}

	mount { "/mnt/WD2500YS":
		device  => "/dev/disk/by-id/ata-WDC_WD2500YS-01SHB1_WD-WCANY4335837-part1",
		fstype  => "ext4",
		ensure  => "mounted",
		options => "defaults",
		atboot  => "true",
		require => File["/mnt/WD2500YS"],
	}

	include raspberry-pi


	#Weave
#	class { "weave::install":
#		accept_tou => true,
#		cron       => false,
#	}
#	class { "weave::config":
#		config => {
#			"registered_worker_id" => "lieutdan13",
#			"min_memory" => "256m",
#			"max_memory" => "256m",
#			"weave_log"  => "/tmp/weave.log",
#			"cron"       => "1",
#		}
#	}


	#Imapfilter
#	class { 'sz-misc::imapfilter':
#		require => Mount["/mnt/lexar-usb"],
#	}


	#Web/DB server
	class { 'php': }
	php::module { 'gd': }
	php::module { 'mysql': }
	class { 'apache': }
	apache::module { 'rewrite': }
	apache::module { 'php5': }
	class { 'mysql': }

	#MarketMaps.co
	include www_marketmaps_co

	#SchaeferZone.net Sites
	include schaeferzone_net::site::cars
	include schaeferzone_net::site::eternallands
	include schaeferzone_net::site::favorites
	include schaeferzone_net::site::portfolio
	include schaeferzone_net::site::sandbox

	#WorryfreeIncome
#	include worryfreeincome::www

	#MySQL Backups
	file { [
		'/mnt/lexar-usb/Backups',
		'/mnt/lexar-usb/Backups/MySQL',
		]:
		ensure  => directory,
		recurse => true,
		require => Mount["/mnt/lexar-usb"],
	}
}
