$local_dns_ip = "192.168.10.10"
$devops_uid=10001

class test_class {
	file { "/tmp/puppet-agent-successfull":
		ensure => absent,
		mode   => 644,
		owner  => root,
		group  => root
	}
	file { "/tmp/my_os_type":
		ensure  => absent,
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

import "nodes"
