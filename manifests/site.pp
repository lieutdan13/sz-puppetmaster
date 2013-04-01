class test_class {
	file { "/tmp/puppet-agent-successfull":
		ensure => present,
		mode   => 644,
		owner  => root,
		group  => root
	}
	file { "/tmp/my_os_type":
		ensure  => present,
		mode    => 644,
		owner   => root,
		group   => root,
		content => $operatingsystem ? {
			"Ubuntu" => "I'm an Ubuntu Machine",
			"Debian" => "I'm a Debian Machine",
			default  => "I don't know who I am"
		},
	}
}

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

node big-bang inherits default {
	include puppetmaster
	include sz-dns::client
}

node raspberrypi inherits default {
	include sz-dns::server
}