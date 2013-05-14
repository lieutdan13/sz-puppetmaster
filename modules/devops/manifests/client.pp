class devops::client {
	sshauth::client { "devops@${ssh_domain_name}":
		ensure   => "present",
		filename => "devops@${ssh_domain_name}",
		user     => "devops",
	}
}
