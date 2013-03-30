import classes/*.pp

class utility {
	file { "/tmp/utility":
                ensure  => present,
                mode    => 644,
                owner   => root,
                group   => root,
                content => $operatingsystem ? {
                        "Ubuntu" => "I'm an Ubuntu Machine",
                        "Debian" => "I'm a Debian Machine",
                        default  => "I don't know who I am"
                },
        }
}
