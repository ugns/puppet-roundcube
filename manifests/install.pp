# == Class roundcube::install
#
class roundcube::install {
  include roundcube::params

  if ! defined(Class[Apt::Backports]) {
    class { 'apt::backports': }
  }

  apt::pin { 'roundcube':
    packages => 'roundcube*',
    priority => 500,
    release  => "${::lsbdistcodename}-backports",
  }->

  package { ['roundcube', 'roundcube-core', 'roundcube-plugins']:
    ensure  => present,
    require => Package["roundcube-${roundcube::backend}"],
  }

  package { "roundcube-${roundcube::backend}":
    ensure => present,
  }

  if $::roundcube::extra_plugins_pkg {
    package { 'roundcube-plugins-extra':
      ensure => present,
    }
  }

}
