class sz-dns::client {

	file { "/tmp/sz-dns-client-successful":
		ensure => present,
	}

	package { "dnsutils": ensure  => latest }
	package { "resolvconf": ensure  => absent }
}
