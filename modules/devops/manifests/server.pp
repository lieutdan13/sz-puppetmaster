class devops::server {
	sshauth::server { "devops_${ssh_domain_name}":
		ensure   => "present",
		user     => "devops",
	}
}
