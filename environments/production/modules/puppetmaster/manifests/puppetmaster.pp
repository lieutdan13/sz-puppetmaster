node puppetmaster {
	cron { 'pull_puppet':
		command => "cd /etc/puppet && /usr/bin/git pull > /dev/null",
		user    => root,
		hour    => '*',
		minute  => '*/2',
		ensure  => present
	}

	package { 'puppetmaster': ensure => installed }

	service { 'puppetmaster':
		ensure  => "running",
		enable  => "true",
		require => Package["puppetmaster"],
	}

	file { '/etc/default/puppetmaster':
		notify  => Service["puppetmaster"],
		mode    => 644,
		owner   => "root",
		group   => "root",
		require => Package["puppetmaster"],
		content => "/etc/puppet/files/big-bang/etc_default_puppetmaster",
	}

	package { 'puppet': ensure => installed }

	service { 'puppet':
		ensure  => "running",
		enable  => "true",
		require => Package["puppet"],
	}

	file { '/etc/default/puppet':
		notify  => Service["puppet"],
		mode    => 644,
		owner   => "root",
		group   => "root",
		require => Package["puppet"],
		content => "/etc/puppet/files/big-bang/etc_default_puppet",
	}
}