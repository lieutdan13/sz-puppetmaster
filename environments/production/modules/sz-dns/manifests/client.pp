class sz-dns::client {

	file { "/tmp/sz-dns-client-successful":
		ensure => absent,
	}

	package { "dnsutils": ensure  => latest }

	class { 'resolver':
		dns_servers => [ '192.168.10.10' ],
		dns_domain  => 'schaeferzone.net',
		search      => [ 'schaeferzone.net', 'marketmaps.co' ],
	}
}
