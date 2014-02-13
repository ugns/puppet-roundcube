# == Class roundcube::params
#
# This class is meant to be called from roundcube
# It sets variables according to platform
#
class roundcube::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'roundcube'
      $service_name = 'roundcube'
    }
    'RedHat', 'Amazon': {
      $package_name = 'roundcube'
      $service_name = 'roundcube'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
