# == Class roundcube::config
#
# This class is called from roundcube
#
class roundcube::config {
  Ini_setting {
    path    => '/etc/dbconfig-common/roundcube.conf',
    ensure  => present,
    section => '',
    notify  => Exec['reconfigure-roundcube'],
    require => Package["roundcube-${roundcube::backend}"],
  }

  ini_setting {'dbtype':
    setting => 'dbc_dbtype',
    value   => "'${roundcube::backend}'",
  }

  exec { 'reconfigure-roundcube':
    path        => '/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
    command     => 'dpkg-reconfigure roundcube',
  }
}
