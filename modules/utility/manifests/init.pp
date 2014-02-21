#import classes/*.pp

class utility {
	include lieutdan13::essentials
	file { "/usr/local/bin/randomSleep":
		ensure  => present,
		mode    => 755,
		owner   => root,
		group   => root,
		source  => "puppet:///modules/utility/usr_local_bin_randomSleep"
	}

	$latest_pkgs = [
		"apt",
		"apt-show-versions",
		"apt-utils",
		"sudo",
		"tree",
		"vim",
		"vim-tiny",
	]
	package { $latest_pkgs: ensure => 'latest' }

	class { "git":
		svn     => "latest",
		gui     => false,
		ensure  => "latest",
	}

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
