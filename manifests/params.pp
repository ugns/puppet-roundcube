# == Class roundcube::params
#
# This class is meant to be called from roundcube
# It sets variables according to platform
#
class roundcube::params {
  $confdir = '/etc/roundcube'
  $backend = 'pgsql'
  $database_host = $::fqdn
  $database_port = '5432'
  $database_name = 'roundcube'
  $database_username = 'roundcube'
  $database_password = 'roundcube'
  $database_ssl = false

  $main_inc_php_erb = 'roundcube/main.inc.php.erb'
}
