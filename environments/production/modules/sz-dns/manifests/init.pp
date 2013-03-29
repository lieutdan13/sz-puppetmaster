class sz-dns inherits dns::server {
	file { "/tmp/sz-dns-successful":
		ensure => present,
		mode   => 644,
		owner  => root,
		group  => root
	}
}
