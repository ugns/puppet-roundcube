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
}
