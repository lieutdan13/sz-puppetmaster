class sz-dns::server inherits dns::server {

	$sz_zone = "schaeferzone.net"
	$mm_zone = "marketmaps.co"

	file { "/tmp/sz-dns-successful":
		ensure => absent,
	}

	package { "dnsutils": ensure  => latest }

	class { 'resolver':
		dns_servers => [ '127.0.0.1' ],
		dns_domain  => 'schaeferzone.net',
		search      => [ 'schaeferzone.net', 'marketmaps.co' ],
	}

	file { "/etc/bind/named.conf.options":
		mode    => 644,
		owner   => "root",
		group   => "bind",
		require => [File['/etc/bind'], Class['dns::server::install']],
		notify  => Class['dns::server::service'],
		source => "puppet:///modules/sz-dns/named.conf.options",
        }

	dns::zone { 'marketmaps.co':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1.schaeferzone.net'],
		serial      => 2013033100
	}

	dns::zone { 'schaeferzone.net':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1'],
		serial      => 2013033005
	}

	dns::zone { '10.168.192.IN-ADDR.ARPA':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1'],
		serial      => 2013032801
	}

	# A Records
	dns::record::a {
		'@':
			zone => $sz_zone,
			data => ['192.168.10.25'];
		'big-bang':
			zone => $sz_zone,
			data => ['192.168.10.5'],
			ptr  => true;
		'raspberrypi':
			zone => $sz_zone,
			data => ['192.168.10.10'],
			ptr  => true;
		'nebula':
			zone => $sz_zone,
			data => ['192.168.10.15'],
			ptr  => true;
		'eclipse':
			zone => $sz_zone,
			data => ['192.168.10.25'],
			ptr  => true;
	}

	# CNAME Records
	dns::record::cname {
		# Everything else not defined
		"*.${sz_zone}.":
			zone => $sz_zone,
			data => 'eclipse.schaeferzone.net';
		'imap':
			zone => $sz_zone,
			data => 'mail02.logicpartners.com';
		'mail':
			zone => $sz_zone,
			data => 'mail02.logicpartners.com';
		'smtp':
			zone => $sz_zone,
			data => 'mail02.logicpartners.com';
		'www':
			zone => $sz_zone,
			data => 'eclipse.schaeferzone.net';

		# MarketMaps
		'dev':
			zone => $mm_zone,
			data => 'nebula.schaeferzone.net';
	}

	# MX Record
	dns::record::mx {
		"mx,0,${sz_zone}":
			zone => $sz_zone,
			host => '@',
			preference => 0,
			data => 'mail02.logicpartners.com';
	}
}