# Create /tmp/testfile if it doesn't exist
class test_class {
	file { "/tmp/testfile":
		ensure => present,
		mode   => 644,
		owner  => root,
		group  => root
	}
}

include nodes
