
# Create /tmp/testfile if it doesn't exist
class test_class {
	file { "/tmp/testfile":
		ensure => present,
		mode   => 644,
		owner  => root,
		group  => root
	}
}

node big-bang {
        include test_class
	cron { pull_puppet:
		command => "cd /etc/puppet && /usr/bin/git pull -q",
		user    => root,
		hour    => '*',
		minute  => '*/2',
		ensure  => present
	}

	service { "puppetmaster":
		ensure  => "running",
		enable  => "true",
		require => Package["puppetmaster"],
	}

	file { "/etc/default/puppetmaster":
		notify  => Service["puppetmaster"],
		mode    => 644,
		owner   => "root",
		group   => "root",
		require => Package["puppetmaster"],
		content => "/etc/puppet/files/big-bang/etc_default_puppetmaster",
	}

	service { "puppet":
		ensure  => "running",
		enable  => "true",
		require => Package["puppet"],
	}

	file { "/etc/default/puppet":
		notify  => Service["puppet"],
		mode    => 644,
		owner   => "root",
		group   => "root",
		require => Package["puppet"],
		content => "/etc/puppet/files/big-bang/etc_default_puppet",
	}
}
