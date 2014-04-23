# dotfiles/manifests/init.pp

$home = "Users/${::boxen_user}"
$neo_dotfiles_dir = ${::boxen::config::srcdir}/neo_dotfiles"
$gabe_dotfiles_dir = ${::boxen::config::srcdir}/gabe_dotfiles"

repository { $neo_dotfiles_dir:
  source => "neo/vim-config"
}

repository { $gabe_dotfiles_dir:
  source => "gabehollombe/config_files"
}

file { "${home}/.zshrc":
  ensure => link,
  target => "${gabe_dotfiles_dir}/zshrc"
  require => Repository[$gabe_dotfiles_dir]
}

file { "${home}/.tmux.conf":
  ensure => link,
  target => "${gabe_dotfiles_dir}/tmux.conf",
  require => Repository[$gabe_dotfiles_dir]
}

exec { "install vim config":
  cwd => $neo_dotfiles_dir,
  command => "rake",
  provider => shell,
  creates => [ "${home}/.vimrc", "${home}/.vim/" ],
  require => Repository[$neo_dotfiles_dir]
}
