# == Class roundcube::install
#
class roundcube::install {
  include roundcube::params

  package { ['roundcube', 'roundcube-core', 'roundcube-plugins']:
    ensure  => present,
    require => Package["roundcube-${roundcube::backend}"],
  }

  package { "roundcube-${roundcube::backend}":
    ensure => present,
  }

}
