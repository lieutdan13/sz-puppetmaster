class puppetagent {
	cron { 'run_agent':
		command => "puppet agent --onetime",
		user    => root,
		hour    => '*',
		minute  => '1-59/2',
		ensure  => present
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
