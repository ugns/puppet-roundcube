# == Class: roundcube
#
# Full description of class roundcube here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class roundcube (
  $base_version        = $::roundcube::params::base_version,
  $package_list        = $::roundcube::params::package_list,
  $conf_dir            = $::roundcube::params::conf_dir,
  $conf_file           = $::roundcube::params::conf_file,
  $conf_file_owner     = $::roundcube::params::conf_file_owner,
  $conf_file_group     = $::roundcube::params::conf_file_group,
  $conf_file_template  = $::roundcube::params::conf_file_template,
  $backend             = $::roundcube::params::backend,
  $database_host       = $::roundcube::params::database_host,
  $database_port       = $::roundcube::params::database_port,
  $database_name       = $::roundcube::params::database_name,
  $database_username   = $::roundcube::params::database_username,
  $database_password   = $::roundcube::params::database_password,
  $database_ssl        = $::roundcube::params::database_ssl,
  $extra_plugins_pkg   = $::roundcube::params::extra_plugins_pkg,
  $main_inc_php_erb    = $::roundcube::params::main_inc_php_erb,
  $log_logins          = undef,
  $default_host        = undef,
  $default_port        = undef,
  $imap_auth_type      = undef,
  $smtp_server         = undef,
  $smtp_port           = undef,
  $smtp_user           = undef,
  $smtp_pass           = undef,
  $smtp_auth_type      = undef,
  $support_url         = undef,
  $force_https         = undef,
  $session_domain      = undef,
  $ip_check            = undef,
  $referer_check       = undef,
  $des_key             = undef,
  $username_domain     = undef,
  $mail_domain         = undef,
  $product_name        = undef,
  $include_host_config = undef,
  $plugins             = undef,
  $skin                = undef,
  $timezone            = undef,
  $default_font        = undef,
) inherits roundcube::params {

  validate_re($backend, '^(mysql|pgsql|sqlite3)$')
  validate_bool($database_ssl)
  validate_absolute_path($conf_dir)

  if $include_host_config {
    validate_hash($include_host_config)
  }

  if $plugins {
    validate_array($plugins)
  }

  #LB: using new Puppet 3.7 contains method to anchor subclasses to
  #parent class while at the same time allow users to take advantage of
  #automatic module data bindings.
  contain roundcube::install
  contain roundcube::config
  contain "roundcube::db::${backend}"
  
  Class[roundcube::install]
    -> Class[roundcube::config]
    -> Class["roundcube::db::${backend}"]
}
