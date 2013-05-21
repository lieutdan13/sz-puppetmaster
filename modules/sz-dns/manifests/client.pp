class sz-dns::client {
	package { "dnsutils": ensure  => latest }
	package { "resolvconf": ensure  => latest }
}
