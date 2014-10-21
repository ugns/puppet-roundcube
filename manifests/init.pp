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
  $backend = $::roundcube::params::backend,
) inherits roundcube::params {

  # validate parameters here

  class { 'roundcube::install': } ->
  class { 'roundcube::config': } ->
  Class['roundcube']}
