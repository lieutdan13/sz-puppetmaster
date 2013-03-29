class sz-dns inherits dns::server {
	file { "/tmp/sz-dns-successful":
		ensure => present,
		mode   => 644,
		owner  => root,
		group  => root
	}

	dns::zone { 'schaeferzone.net':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1']
	}

	dns::zone { '10.168.192.IN-ADDR.ARPA':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1']
	}
}
