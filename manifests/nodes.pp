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
	include sz-dns::server

	#Mounted drives	
	file { "/mnt/lexar-usb":
		ensure => "directory",
		owner  => "root",
		group  => "root",
		mode   => 755,
	}

	mount { "/mnt/lexar-usb":
		device  => "/dev/disk/by-uuid/9857-7817",
		fstype  => "vfat",
		ensure  => "mounted",
		options => "defaults",
		atboot  => "true",
	}
	
	file { "/mnt/WD2500YS":
		ensure => "directory",
		owner  => "root",
		group  => "root",
		mode   => 755,
	}

	mount { "/mnt/WD2500YS":
		device  => "/dev/disk/by-id/ata-WDC_WD2500YS-01SHB1_WD-WCANY4335837-part1",
		fstype  => "vfat",
		ensure  => "mounted",
		options => "defaults",
		atboot  => "true",
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

	package { "imapfilter": ensure => present }

	cron { imapfilter:
		command => "/usr/bin/imapfilter -c /mnt/lexar-usb/imapfilter.lua -l /tmp/imapfilter.log",
		user    => root,
		hour	=> "*",
		minute  => "*/10"
	}


	#Web/DB server
	class { 'apache': }
	class { 'apache::mod::php': }
	class { 'mysql': }
	class { 'mysql::server': }
	class { 'mysql::php': }

	#MarketMaps.co
	file { [ "/var/www/www.marketmaps.co",
		 "/var/www/www.marketmaps.co/htdocs",]:
		ensure => 'directory',
		owner  => 'www-data',
		group  => 'www-data',
		mode   => 750,
	}

	file { "/mnt/lexar-usb/www.marketmaps.co": ensure => 'directory' }

	apache::vhost { 'www.marketmaps.co':
		priority        => '10',
		vhost_name      => '192.168.10.10',
		port            => '80',
		docroot         => '/var/www/www.marketmaps.co/htdocs',
		logroot         => '/var/log/apache2/www.marketmaps.co/',
		serveradmin     => 'dan@schaeferzone.net',
		serveraliases   => ['marketmaps.co'],
	}

	git::repo{ "www.marketmaps.co":
		path    => "/var/www/www.marketmaps.co/htdocs/",
		source  => "git://github.com/lieutdan13/MarketMaps.git",
		update  => true,
	}
}
