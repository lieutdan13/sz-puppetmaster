class devops {
	group { 'devops':
		gid    => $devops_uid
	}

	user { 'devops':
		ensure => 'present',
		home   => '/home/devops',
		uid    => $devops_uid,
		gid    => $devops_uid,
		shell  => '/bin/bash',
		groups => ['adm','cdrom','sudo'], #dip, plugdev, lpadmin, sambashare
	}

	file { '/home/devops':
		ensure  => directory,
		recurse => true,
		owner   => 'devops',
		group   => 'devops',
	}
}
