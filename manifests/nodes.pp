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
	host { "big-bang.schaeferzone.net":
		comment    => "Just in case DNS is down, we want to know how to get to the Master",
		ensure     => present,
		host_aliases => [ 'big-bang' ],
		ip         => '192.168.10.5',
		name       => 'big-bang.schaeferzone.net',
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
				"dns-search" => [ "schaeferzone.net", "marketmaps.co" ],
				"dns-nameservers" => [ $local_dns_ip, "8.8.8.8", "8.8.4.4" ],
			}
		},
		auto => ["eth0"]
	}

	include puppetmaster
	include sz-dns::client
}

node raspberrypi inherits puppetagent {
	include sz-dns::server
}
