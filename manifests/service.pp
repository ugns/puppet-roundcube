# == Class roundcube::service
#
# This class is meant to be called from roundcube
# It ensure the service is running
#
class roundcube::service {
  include roundcube::params

  service { $roundcube::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
