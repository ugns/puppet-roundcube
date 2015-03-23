# == Class roundcube::params
#
# This class is meant to be called from roundcube
# It sets variables according to platform
#
class roundcube::params {
  $conf_file_owner    = 'root'
  $backend            = 'pgsql'
  $database_host      = $::fqdn
  $database_name      = 'roundcube'
  $database_username  = 'roundcube'
  $database_password  = 'roundcube'
  $database_ssl       = false
  $manage_database    = true
  $product_name       = 'RoundCube Webmail'
  $plugins            = [ 'archive', 'zipdownload' ]

  #LB: two different templates for two different versions of RoundCube
  $conf_file_template = "${module_name}/config.inc.php.erb"
  $main_inc_php_erb   = "${module_name}/main.inc.php.erb"

  #LB: default database port should depend on the backend
  $database_port = $backend ? {
    'pgsql' => '5432',
    'mysql' => '3306',
    default => undef,
  }
  #LB: the config file changes in roundcube 1.0. To preserve backwards
  #compatibility with the original module author (who uses Debian) I am attempting
  #to detect the "base version" based on Operating System and use that
  #base version to decide things later on (like which conf file to use).
  if ($::osfamily == 'RedHat') {
    if (($operatingsystem in [ 'RedHat', 'CentOS' ]) and ($::operatingsystemrelease =~ /^6/)) {
      $base_version       = '1.0'
      $package_list       = 'roundcubemail'
      $conf_dir           = '/etc/roundcubemail'
      $conf_file          = 'config.inc.php'
      $conf_file_group    = 'apache'
      $extra_plugins_pkg  = false
    }
  } elsif ($::osfamily == 'debian') {
    $base_version       = '0.x'
    $package_list       = ['roundcube', 'roundcube-core', 'roundcube-plugins']
    $conf_dir           = '/etc/roundcube'
    $conf_file          = 'main.inc.php'
    $conf_file_group    = 'www-data'
    $extra_plugins_pkg  = true
  }
}
