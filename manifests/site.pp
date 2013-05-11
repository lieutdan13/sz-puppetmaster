$local_dns_ip = "192.168.10.10"
$devops_uid=10001
$domain_name="schaeferzone.net"
$ssh_domain_name="schaeferzone_net"

include sshauth
define sshuser (
	$ensure = "present",
	$home   = "/home/${title}",
	$uid    = undef,
	$gid    = undef,
	$shell  = '/bin/bash',
	$groups = undef,
) {
	@user { $title:
		ensure => $ensure,
		home   => $home,
		uid    => $uid,
		gid    => $gid,
		shell  => $shell,
		groups => $groups,
	}
	@file { $home:
		ensure  => directory,
		recurse => true,
		owner   => $title,
		group   => $title,
	}
	@file { "${home}/.ssh":
		ensure => "directory",
		mode   => 600,
		owner  => $title,
		group  => $title,
	}
	sshauth::key { "${title}_${ssh_domain_name}":
		user     => $title,
		filename => "${title}_${ssh_domain_name}",
	}
}

define sshclientuser (
	$ensure = "present",
	$home   = "/home/${title}",
) {
	realize User[$title]
	realize File["${home}/.ssh"]
	sshauth::client { "${title}_${ssh_domain_name}":
		ensure   => $ensure,
		filename => "${title}_${ssh_domain_name}",
		user     => $title,
	}
}

define sshserveruser (
	$ensure = "present",
	$home   = "/home/${title}",
) {
	realize File["${home}/.ssh"]
	User <| title == $title |> { ensure => $ensure }
	sshauth::server { "${title}_${ssh_domain_name}":
		ensure   => $ensure,
		user     => $title,
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
