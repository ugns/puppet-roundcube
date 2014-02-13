# == Class roundcube::install
#
class roundcube::install {
  include roundcube::params

  package { $roundcube::params::package_name:
    ensure => present,
  }
}
