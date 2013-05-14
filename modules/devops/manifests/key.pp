class devops::key {
	sshauth::key {"devops_schaeferzone_net": ensure => 'absent' }
	sshauth::key { "devops@${ssh_domain_name}":
		user     => "devops",
		filename => "devops@${ssh_domain_name}",
	}
}
