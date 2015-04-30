# == Class roundcube::db::psql
#
# This class is called from roundcube
#
class roundcube::db::pgsql {

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

  ini_setting {'dbuser':
    setting => 'dbc_dbuser',
    value   => "'${roundcube::database_username}'",
  }

  ini_setting {'dbpass':
    setting => 'dbc_dbpass',
    value   => "'${roundcube::database_password}'",
  }

  ini_setting {'dbname':
    setting => 'dbc_dbname',
    value   => "'${roundcube::database_name}'",
  }

  ini_setting {'dbserver':
    setting => 'dbc_dbserver',
    value   => "'${roundcube::database_host}'",
  }

  ini_setting {'dbport':
    setting => 'dbc_dbport',
    value   => "'${roundcube::database_port}'",
  }

  ini_setting {'dbssl':
    setting => 'dbc_ssl',
    value   => "'${roundcube::database_ssl}'",
  }

  postgres::validate_db_connection{'validate roundcube postgres connection':
    database_host     => $roundcube::database_host,
    database_username => $roundcube::database_username,
    database_password => $roundcube::database_password,
    database_name     => $roundcube::database_name,
    create_db_first   => false,
  }
}
