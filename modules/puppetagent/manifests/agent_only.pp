#puppetagent::agent_only
class puppetagent::agent_only {
	host { "puppet":
		comment    => "Just in case DNS is down, we want to know how to get to the Master",
		ensure     => present,
		ip         => '192.168.10.5',
		name       => 'puppet',
	}
	file { '/etc/puppet/puppet.conf':
		ensure     => present,
		content    => template("puppetagent/puppet.conf"),
	}
}
