class devops {
	group { 'devops':
		gid    => $devops_uid
	}

	sshuser { "devops": # Generate the key
		uid    => $devops_uid,
		gid    => $devops_uid,
		groups => ['adm','cdrom','sudo'], #dip, plugdev, lpadmin, sambashare
	}
	sshclientuser { "devops": } # Install the key on the node
	sshserveruser { "devops": } # Authorize the key to access the node
}
