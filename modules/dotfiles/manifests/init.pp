# dotfiles/manifests/init.pp

$home = "Users/${::boxen_user}"
$neo_dotfiles_dir = "${::boxen::config::srcdir}/neo_dotfiles"
$gabe_dotfiles_dir = "${::boxen::config::srcdir}/gabe_dotfiles"

$omz_repo = "robbyrussell_oh-my-zsh"

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

  # file { "${home}/.tmux.conf":
  #   ensure => link,
  #   target => "${gabe_dotfiles_dir}/tmux.conf",
  #   require => Repository["${gabe_dotfiles_dir}"]
  # }

  notice (" OMZ PATH: ?>>>> ${dotfiles::omz_path}")
  file { ".zshrc":
    path => "${home}/.zshrc",
    ensure => file,
    require => Repository["robbyrussell_oh-my-zsh"],
    content => template("dotfiles/zshrc.erb")
  }
  # exec { "install oh-my-zsh":
  #   require => Repository["robbyrussell_oh-my-zsh"],
  #   cwd => $dotfiles::omz_path,
  #   provider => shell,
  #   creates => "${home}/.zshrc",
  #   command => "cp templates/zshrc.zsh-template ${home}/.zshrc && echo \"export LC_ALL=en_US.UTF-8\" >> ${home}/.zshrc && echo \"export LANG=en_US.UTF-8\" >> ${home}/.zshrc && echo \"if [ -f /opt/boxen/env.sh ]; then\n  source /opt/boxen/env.sh\nfi\" >> ${home}/.zshrc"
  # }

  # exec { "install vim config":
  #   cwd => $neo_dotfiles_dir,
  #   command => "rake",
  #   provider => shell,
  #   creates => [ "${home}/.vimrc", "${home}/.vim/" ],
  #   require => Repository[$neo_dotfiles_dir]
  # }
  #
  # repository { "${neo_dotfiles_dir}":
  #   source => "neo/vim-config"
  # }
  #
  # repository { "${gabe_dotfiles_dir}":
  #   source => "gabehollombe/config_files"
  # }
  #
}

