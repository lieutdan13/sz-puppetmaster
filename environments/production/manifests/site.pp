class test_class {
	file { "/tmp/puppet-agent-successfull":
		ensure => present,
		mode   => 644,
		owner  => root,
		group  => root
	}
}

node default {
        include test_class
}

node big-bang inherits default {
	include puppetmaster
}

node raspberrypi inherits default {
	include sz-dns
}
