
# Create /tmp/testfile if it doesn't exist
class test_class {
	file { "/tmp/testfile":
		ensure => present,
		mode   => 644,
		owner  => root,
		group  => root
	}
}

node big-bang {
        include test_class
	cron { pull_puppet:
		command => "cd /etc/puppet && /usr/bin/git pull",
		user    => root,
		hour    => '*',
		minute  => '*/15',
		ensure  => present
	}
}
