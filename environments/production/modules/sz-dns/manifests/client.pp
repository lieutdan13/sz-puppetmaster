class sz-dns::client {

	file { "/tmp/sz-dns-client-successful":
		ensure => present,
	}

	package { "dnsutils": ensure  => latest }
	package { "resolvconf": ensure  => absent }

	class { 'resolver':
		dns_servers => [ '192.168.10.10', '8.8.8.8', '8.8.4.4' ],
		dns_domain  => 'schaeferzone.net',
		search      => [ 'schaeferzone.net', 'marketmaps.co' ],
	}
}
