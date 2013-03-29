class sz-dns inherits dns::server {
	file { "/tmp/sz-dns-successful":
		ensure => absent,
	}

	file { "/etc/bind/named.conf.options":
		notify  => Service["dns"],
		mode    => 644,
		owner   => "root",
		group   => "bind",
		require => [File['/etc/bind'], Class['dns::server::install']],
		notify  => Class['dns::server::service'],
        }

	dns::zone { 'marketmaps.co':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1.schaeferzone.net'],
		serial      => 2013032800
	}

	dns::zone { 'schaeferzone.net':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1'],
		serial      => 2013032801
	}

	dns::zone { '10.168.192.IN-ADDR.ARPA':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1'],
		serial      => 2013032801
	}

	# A Records
	dns::record::a {
		'big-bang':
			zone => 'schaeferzone.net',
			data => ['192.168.10.5'],
			ptr  => true;
		'raspberrypi':
			zone => 'schaeferzone.net',
			data => ['192.168.10.10'],
			ptr  => true;
		'nebula':
			zone => 'schaeferzone.net',
			data => ['192.168.10.15'],
			ptr  => true;
		'eclipse':
			zone => 'schaeferzone.net',
			data => ['192.168.10.25'],
			ptr  => true;
	}
}
