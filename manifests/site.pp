$local_dns_ip = "192.168.10.10"
$devops_uid=10001
$domain_name="schaeferzone.net"

include sshauth
define sshuser {
	@user { $title: }
	@file { "/home/${title}/.ssh":
		ensure => "directory",
		mode   => 600,
		owner  => $title,
		group  => $title,
	}
	sshauth::key { "${title}@${domain_name}":
		managed  => true,
		user     => $title,
		group    => $title,
		filename => "${title}@${domain_name}",
	}
}

define sshclientuser {
	realize User[$title]
	realize File["/home/${title}/.ssh"]
	sshauth::client { "${title}@${domain_name}":
		filename => "${title}@${domain_name}",
		user     => $title,
		group    => $title,
	}
}

define sshserveruser ($ensure = "present") {
	realize File["/home/${title}/.ssh"]
	User <| title == $title |> { ensure => $ensure }
	sshauth::server { "${title}@${domain_name}":
		ensure   => $ensure,
		user     => $title,
		group    => $title,
	}
}

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
