class devops::server {
	sshauth::server { "devops@${ssh_domain_name}":
		ensure   => "present",
		user     => "devops",
	}
}
