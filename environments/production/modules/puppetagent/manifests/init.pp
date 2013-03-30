class puppetagent {
	cron { 'run_agent':
		command => "/usr/local/bin/randomSleep 30; puppet agent --onetime",
		user    => root,
		hour    => '*',
		minute  => '1-59/2',
		ensure  => present,
		require => File["/usr/local/bin/randomSleep"]
	}

	package { 'puppet': ensure => installed }

	service { 'puppet':
		ensure  => "running",
		enable  => "true",
		require => Package["puppet"],
	}

#	file { '/etc/default/puppet':
#		notify  => Service["puppet"],
#		mode    => 644,
#		owner   => "root",
#		group   => "root",
#		require => Package["puppet"],
#		source => "puppet:///modules/puppetmaster/etc_default_puppet",
#	}
}
