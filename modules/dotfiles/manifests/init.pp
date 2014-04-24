# dotfiles/manifests/init.pp

$home = "Users/${::boxen_user}"
$neo_dotfiles_dir = ${::boxen::config::srcdir}/neo_dotfiles"
$gabe_dotfiles_dir = ${::boxen::config::srcdir}/gabe_dotfiles"

$omz_repo = "robbyrussell_oh-my-zsh"
$omz_path = "/Users/${::luser}/.oh-my-zsh"

class ohmyzsh {
  repository { $omz_repo,
    source => 'robbyrussel/oh-my-zsh',
    path => $omz_path
  }
}


class dotfiles {
  include "ohmyzsh"

  file { "${home}/.tmux.conf":
    ensure => link,
    target => "${gabe_dotfiles_dir}/tmux.conf",
    require => Repository[$gabe_dotfiles_dir]
  }

  exec { "install oh-my-zsh":
    require => Repository["robbyrussell_oh-my-zsh"],
    cwd => $omz_path,
    provider => shell,
    creates => "${home}/.zshrc",
    command => "oh-my-zsh.sh && echo \"export LC_ALL=en_US.UTF-8\" >> ${home}/.zshrc && echo \"export LANG=en_US.UTF-8\" >> ${home}/.zshrc"

  exec { "install vim config":
    cwd => $neo_dotfiles_dir,
    command => "rake",
    provider => shell,
    creates => [ "${home}/.vimrc", "${home}/.vim/" ],
    require => Repository[$neo_dotfiles_dir]
  }

  repository { $neo_dotfiles_dir:
    source => "neo/vim-config"
  }

  repository { $gabe_dotfiles_dir:
    source => "gabehollombe/config_files"
  }

}

