class devops::client (
	$ensure = "present",
	$home   = "/home/devops",
	$uid    = undef,
	$gid    = undef,
	$shell  = '/bin/bash',
	$groups = undef,
) {
	sshuser { 'devops': }
	sshclientuser { 'devops': }
}
