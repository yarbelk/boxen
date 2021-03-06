require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_BUILD_FROM_SOURCE=true",
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub

  # OS X stuff
  include osx::dock::autohide
  include osx::dock::clear_dock
  include osx::finder::show_all_on_desktop
  include osx::universal_access::ctrl_mod_zoom
  include osx::software_update
  include osx::keyboard::capslock_to_control

  # node versions
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  class { 'ruby::global':
    version => '2.1.1'
  }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }

  # default ruby gems
  ruby::gem { "git pairs gem":
    gem => 'pivotal_git_scripts',
    ruby => "*",
    version => "1.2.0"
  }

  ruby::gem { "rake for all":
    gem => "rake",
    version => "~> 10.1.1",
    ruby => "*"
  }

  ruby::gem { "bundle for all":
    gem => "bundler",
    version => "1.5.3",
    ruby => "*"
  }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'heroku',
      'readline',
      'postgresql',
      'imagemagick',
      'qt'
    ]:
  }

  file { "${boxen::config::srcdir}/boxen":
    ensure => link,
    target => $boxen::config::repodir
  }

  # Other things
  include "wget"
  include "macvim"
  include "foreman"
  include "gcc"
  include "homebrew"
  include "ruby"
  include "openssl"
  include "phantomjs"
  include "pkgconfig"
  include "stdlib"
  include "xquartz"
#
  include "iterm2::stable"
  include iterm2::colors::solarized_dark
  include "sysctl"
  include "firefox"
  include "hipchat"
  include "vagrant"
  include "skype"
  include "chrome"
  include "dropbox"
  include "zsh"
  include "tmux"
  include "virtualbox"
  include "heroku"
  include "python"
  include "gitx"
  include "ctags"
  include "textmate"
  include "imagemagick"
  include "qt"
  include "rubymine"
  include "jumpcut"

  include "dotfiles"
}
