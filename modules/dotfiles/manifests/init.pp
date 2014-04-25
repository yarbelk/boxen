# dotfiles/manifests/init.pp

class ohmyzsh {
  $omz_path = "/Users/${::luser}/.oh-my-zsh"
  repository { "robbyrussell_oh-my-zsh":
    source => 'robbyrussell/oh-my-zsh',
    path => "${ohmyzsh::omz_path}",
  }
}


class dotfiles {
  include "ohmyzsh"

  $home = "/Users/${::luser}"
  $omz_path = "${home}/.oh-my-zsh"
  $gabe_dotfiles_dir = "${home}/gabe_dotfiles"
  $neo_dotfiles_dir = "${home}/neo_dotfiles"

  repository { "neo_dotfiles_repo":
    source => "neo/vim-config",
    path => "${neo_dotfiles_dir}"
  }

  repository { "gabe_dotfiles_repo":
    source => "gabehollombe/config_files",
    path => "${gabe_dotfiles_dir}"
  }


  file { "${home}/.tmux.conf":
    ensure => link,
    target => "${gabe_dotfiles_dir}/tmux.conf",
    require => Repository["gabe_dotfiles_repo"]
  }

  file { "${home}/.zshrc":
    ensure => file,
    require => Repository["robbyrussell_oh-my-zsh"],
    content => template("dotfiles/zshrc.erb")
  }

  exec { "install vim config":
    cwd => $neo_dotfiles_dir,
    command => "/usr/bin/rake",
    creates => [ "${home}/.vimrc", "${home}/.vim/" ],
    require => Repository["neo_dotfiles_repo"]
  }

}

