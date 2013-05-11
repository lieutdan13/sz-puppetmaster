class devops::key {
	sshauth::key { "devops_${ssh_domain_name}":
		user     => "devops",
		filename => "devops_${ssh_domain_name}",
	}
}
