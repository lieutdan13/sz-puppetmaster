class devops::client {
	sshauth::client { "devops_${ssh_domain_name}":
		ensure   => "present",
		filename => "devops_${ssh_domain_name}",
		user     => "devops",
	}
}
