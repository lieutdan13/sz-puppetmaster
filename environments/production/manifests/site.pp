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

node big-bang extends default {
	include puppetmaster
}
