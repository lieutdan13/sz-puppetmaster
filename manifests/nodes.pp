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
	include raspberry-pi
	class { "weave::install":
		accept_tou => true
	}
	class { "weave::config":
		config => {
			"registered_worker_id" => "lieutdan13",
			"min_memory" => "256m",
			"max_memory" => "256m",
			"weave_log"  => "/tmp/weave.\${LOG_DATE}.log",
		}
	}
}
