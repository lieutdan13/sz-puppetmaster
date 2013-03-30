class puppetmaster {
	cron { 'pull_puppet':
		command => "cd /etc/puppet && /usr/bin/git pull > /dev/null && /usr/bin/git submodule foreach git pull",
		user    => root,
		hour    => '*',
		minute  => '2,32',
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
		source => "puppet:///modules/puppetmaster/etc_default_puppetmaster",
	}

	file { '/etc/hosts':
		mode    => 644,
		owner   => "root",
		group   => "root",
		source => "puppet:///modules/puppetmaster/etc_hosts",
	}

#	package { 'piuppet': ensure => installed }

#	service { 'puppet':
#		ensure  => "running",
#		enable  => "true",
#		require => Package["puppet"],
#	}

	file { '/etc/default/puppet':
		notify  => Service["puppet"],
		mode    => 644,
		owner   => "root",
		group   => "root",
		require => Package["puppet"],
		source => "puppet:///modules/puppetmaster/etc_default_puppet",
	}
}
