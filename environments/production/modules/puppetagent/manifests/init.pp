class puppetagent {
	cron { 'run_agent':
		ensure  => present,
		command => "/usr/local/bin/randomSleep 30; puppet agent --onetime --no-daemonize --logdest syslog > /dev/null 2>&1",
		user    => root,
		hour    => '*',
		minute  => '1-59/2',
		require => File["/usr/local/bin/randomSleep"]
	}

	package { 'puppet': ensure => installed }

	service { 'puppet':
		ensure  => "stopped",
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
