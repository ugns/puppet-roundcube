# == Class roundcube::install
#
class roundcube::install(
  $package_list = $::roundcube::package_list
) inherits roundcube {

  package { $package_list:
    ensure  => present,
  }

  if $::roundcube::extra_plugins_pkg {
    package { 'roundcube-plugins-extra':
      ensure => present,
    }
  }

  #LB: separating Debian specific stuff from original module for backwards compatability
  if ($::osfamily == 'debian') {
    if ! defined(Class[Apt::Backports]) {
      class { 'apt::backports': }
    }

    apt::pin { 'roundcube':
      packages => 'roundcube*',
      priority => 500,
      release  => "${::lsbdistcodename}-backports",
      before   => Package[$package_list],
    }

    package { "roundcube-${roundcube::backend}":
      ensure => present,
      before => Package[$package_list],
    }

    exec { 'reconfigure-roundcube':
      path        => '/usr/sbin:/usr/bin:/sbin:/bin',
      refreshonly => true,
      command     => 'dpkg-reconfigure roundcube-core',
    }
  }
}
