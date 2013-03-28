class sz-dns {
	file { "/tmp/sz-dns-successful":
		ensure => present,
		mode   => 644,
		owner  => root,
		group  => root
	}
	include dns::server
}
