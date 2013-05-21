node default {
	include test_class
	include utility
	include puppetagent

	class { "ntp":
	        ensure     => running,
	        servers    => [ 'time1.google.com', 'time2.google.com', 'time3.google.com', 'time4.google.com' ],
		autoupdate => true,
	}
}

node puppetagent inherits default {
	host { "puppet":
		comment    => "Just in case DNS is down, we want to know how to get to the Master",
		ensure     => present,
		ip         => '192.168.10.5',
		name       => 'puppet',
	}
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
	include devops::server
	include sz-dns::server

	#Mounted drives	
	file { "/mnt/lexar-usb":
		ensure => "directory",
		owner  => "devops",
		group  => "devops",
		mode   => 755,
	}

	mount { "/mnt/lexar-usb":
		device  => "/dev/disk/by-uuid/9857-7817",
		fstype  => "vfat",
		ensure  => "mounted",
		options => "defaults,uid=$devops_uid,gid=$devops_uid",
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
	class { "weave::install":
		accept_tou => true,
		cron       => true,
	}
	class { "weave::config":
		config => {
			"registered_worker_id" => "lieutdan13",
			"min_memory" => "256m",
			"max_memory" => "256m",
			"weave_log"  => "/tmp/weave.log",
			"cron"       => "1",
		}
	}


	#Imapfilter
	class { 'sz-misc::imapfilter': }


	#Web/DB server
	class { 'apache': }
	class { 'apache::mod::php': }
	class { 'mysql': }
	class { 'mysql::server': }
	class { 'mysql::php': }


	#MarketMaps.co
	file { "/mnt/lexar-usb/puppet-www.marketmaps.co":
		ensure => 'directory',
		require => Mount["/mnt/lexar-usb"],
	}
	include www_marketmaps_co
}
