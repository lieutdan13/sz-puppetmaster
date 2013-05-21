#import classes/*.pp

class utility {
	file { "/usr/local/bin/randomSleep":
		ensure  => present,
		mode    => 755,
		owner   => root,
		group   => root,
		source  => "puppet:///modules/utility/usr_local_bin_randomSleep"
	}

	package { "tree": ensure => 'latest' }
	package { "vim": ensure => 'latest' }
	package { "vim-tiny": ensure => 'latest' }

	file { "/etc/vim/vimrc.local":
		ensure  => present,
		mode    => 644,
		owner   => root,
		group   => root,
		source  => "puppet:///modules/utility/etc_vim_vimrc.local"
	}

	file { "/etc/profile.d/aliases.sh":
		ensure  => present,
		mode    => 755,
		owner   => root,
		group   => root,
		source  => "puppet:///modules/utility/etc_profile.d_aliases.sh"
	}
}
