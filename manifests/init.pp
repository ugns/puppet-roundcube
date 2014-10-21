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
  $confdir           = $::roundcube::params::confdir,
  $backend           = $::roundcube::params::backend,
  $database_host     = $::roundcube::params::database_host,
  $database_port     = $::roundcube::params::database_port,
  $database_name     = $::roundcube::params::database_name,
  $database_username = $::roundcube::params::database_username,
  $database_password = $::roundcube::params::database_password,
  $database_ssl      = $::roundcube::params::database_ssl,
  $main_inc_php_erb  = $::roundcube::params::main_inc_php_erb,
) inherits roundcube::params {

  validate_re($backend, '^(mysql|pgsql|sqlite3)$')
  validate_bool($database_ssl)
  validate_absolute_path($confdir)

  class { 'roundcube::install': } ->
  class { 'roundcube::config': } ->
  class { "roundcube::config::${backend}": } ->
  Class['roundcube']
}
