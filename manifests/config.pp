# == Class roundcube::config
#
# This class is called from roundcube
#
class roundcube::config {

  file { "${roundcube::confdir}/main.inc.php":
    ensure  => present,
    owner   => 'root',
    group   => 'www-data',
    mode    => '0640',
    content => template($roundcube::main_inc_php_erb),
  }

  file { "${apache::confd_dir}/roundcube.conf":
    ensure => link,
    target => "${roundcube::conf_dir}/apache.conf",
  }

  file { "${apache::confd_dir}/javascript-common.conf":
    ensure => link,
    target => '/etc/javascript-common/javascript-common.conf',
  }
}
