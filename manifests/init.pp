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
) inherits roundcube::params {

  # validate parameters here

  class { 'roundcube::install': } ->
  class { 'roundcube::config': } ~>
  class { 'roundcube::service': } ->
  Class['roundcube']
}
