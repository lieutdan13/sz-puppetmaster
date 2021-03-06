class sz-dns::server inherits dns::server {

	$sz_zone = "schaeferzone.net"
	$mm_zone = "marketmaps.co"

	package { "dnsutils": ensure  => latest }
	package { "resolvconf": ensure  => latest }

	file { "/etc/bind/named.conf.options":
		mode    => 644,
		owner   => "root",
		group   => "bind",
		require => [File['/etc/bind'], Class['dns::server::install']],
		notify  => Class['dns::server::service'],
		source => "puppet:///modules/sz-dns/named.conf.options",
        }

	dns::zone { '10.168.192.IN-ADDR.ARPA':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1'],
		serial      => 2013032801
	}

	# MarketMaps - Zone
	dns::zone { 'marketmaps.co':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1.schaeferzone.net'],
		serial      => 2013041600
	}

	# MarketMaps - A Records
	dns::record::a {
		'@.marketmaps.co':
			host => '@',
			zone => $mm_zone,
			data => ['192.168.10.10'];
	}

	# MarketMaps - CNAME Records
	dns::record::cname {
		'dev':
			zone => $mm_zone,
			data => 'nebula.schaeferzone.net';
		'www.marketmaps.co':
			host => 'www',
			zone => $mm_zone,
			data => 'raspberrypi.schaeferzone.net';
	}

	# SchaeferZone - Zone
	dns::zone { 'schaeferzone.net':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1'],
		serial      => 2014030300
	}

	# SchaeferZone - A Records
	dns::record::a {
		'@.schaeferzone.net':
			host => '@',
			zone => $sz_zone,
			data => ['192.168.10.25'];
		'a-web-1':
			zone => $sz_zone,
			data => ['54.226.251.64'],
			ptr  => false;
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
		'puppet-dev':
			zone => $sz_zone,
			data => ['192.168.10.35'],
			ptr  => true;

	}

	# SchaeferZone - CNAME Records
	dns::record::cname {
		# Everything else not defined
		"*.${sz_zone}.":
			zone => $sz_zone,
			data => 'eclipse.schaeferzone.net';
		'a-rds-1':
			zone => $sz_zone,
			data => 'a-rds-1.c6n1vta92qqg.us-east-1.rds.amazonaws.com';
		'blogs':
			zone => $sz_zone,
			data => 'a-web-1.schaeferzone.net';
		'blogs-dev':
			zone => $sz_zone,
			data => 'puppet-dev.schaeferzone.net';
		'cars':
			zone => $sz_zone,
			data => 'raspberrypi.schaeferzone.net';
		'dev.cars':
			zone => $sz_zone,
			data => 'nebula.schaeferzone.net';
		'eternallands':
			zone => $sz_zone,
			data => 'raspberrypi.schaeferzone.net';
		'favorites':
			zone => $sz_zone,
			data => 'raspberrypi.schaeferzone.net';
		'imap':
			zone => $sz_zone,
			data => 'mail02.logicpartners.com';
		'mail':
			zone => $sz_zone,
			data => 'mail02.logicpartners.com';
		'portfolio':
			zone => $sz_zone,
			data => 'raspberrypi.schaeferzone.net';
		'sandbox':
			zone => $sz_zone,
			data => 'raspberrypi.schaeferzone.net';
		'puppet':
			zone => $sz_zone,
			data => 'big-bang.schaeferzone.net';
		'smtp':
			zone => $sz_zone,
			data => 'mail02.logicpartners.com';
		'www.schaeferzone.net':
			host => 'www',
			zone => $sz_zone,
			data => 'a-web-1.schaeferzone.net';
	}

	# SchaeferZone - MX Records
	dns::record::mx {
		"mx,0,${sz_zone}":
			zone => $sz_zone,
			host => '@',
			preference => 0,
			data => 'mail02.logicpartners.com';
	}

	# WorryFreeIncome - Zone
	dns::zone { 'worryfreeincome.info':
		soa         => 'ns1.schaeferzone.net',
		soa_email   => 'dan.schaeferzone.net',
		nameservers => ['ns1.schaeferzone.net'],
		serial      => 2013091300
	}

	# WorryFreeIncome - A Records
	dns::record::a {
		'@.worryfreeincome.info':
			host => '@',
			zone => 'worryfreeincome.info',
			data => ['50.63.202.24'];
	}

	# WorryFreeIncome - CNAME Records
	dns::record::cname {
		# Everything else not defined
		"*.worryfreeincome.info.":
			zone => 'worryfreeincome.info',
			data => 'a-web-1.schaeferzone.net';
	}
}
