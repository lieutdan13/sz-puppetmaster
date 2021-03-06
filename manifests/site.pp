$domain_name      = 'schaeferzone.net'
$local_dns_ip     = '192.168.10.10'
$ssh_domain_name  = 'schaeferzone.net'
$webmaster_email  = 'dan@schaeferzone.net'

$devops_uid = $hostname ? {
	'raspberrypi' => 10001,
	default       => 10001,
}
$backup_dest_dir = '/mnt/WD2500YS/backup'
$is_puppet_master = $::hostname ? {
	'big-bang' => true,
	default    => false,
}

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
	@file { "${title}_home":
		ensure  => directory,
		path    => $home,
		recurse => true,
		owner   => $title,
		group   => $title,
	}
}

define sshclientuser (
	$ensure = "present",
) {
	realize User[$title]
	realize File["${title}_home"]
	sshauth::client { "${title}@${ssh_domain_name}":
		ensure   => "$ensure",
		filename => "${title}@${ssh_domain_name}",
		user     => "$title",
	}
}

define sshserveruser (
	$ensure = "present",
	$home   = "/home/${title}",
) {
	realize File["${home}/.ssh"]
	User <| title == $title |> { ensure => $ensure }
	sshauth::server { "${title}_${ssh_domain_name}":
		ensure   => "$ensure",
		user     => "$title",
	}
}

class test_class {
}
import '../modules/sz-misc/manifests/secret_vars.pp'
import "nodes"
