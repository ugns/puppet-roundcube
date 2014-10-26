require 'spec_helper'

describe 'roundcube' do
  let(:node) { 'test.example.com' }
  let(:facts) {{
    :osfamily        => 'Debian',
    :lsbdistid       => 'Debian',
    :lsbdistcodename => 'wheezy',
  }}

  context 'supported Debian operating system' do
    describe "roundcube class with defaults" do
      let(:params) {{ }}

      it { should compile.with_all_deps }

      it { should contain_class('roundcube::params') }
      it { should contain_class('roundcube::install').that_comes_before('roundcube::config') }
      it { should contain_class('roundcube::config').that_comes_before('roundcube::db::pgsql') }
      it { should contain_class('roundcube::db::pgsql').that_comes_before('roundcube') }
      it { should contain_class('roundcube') }

      it { should contain_class('apt::backports') }
      it { should contain_apt__pin("roundcube").with({
            'packages' => 'roundcube*',
            'priority' => '500',
            'release'  => "wheezy-backports",
          }) }

      it { should create_exec('reconfigure-roundcube')
              .with_refreshonly(true)
              .with_command('dpkg-reconfigure roundcube-core') }

      it { should contain_ini_setting('dbtype').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_dbtype',
            'value'   => "'pgsql'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_ini_setting('dbuser').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_dbuser',
            'value'   => "'roundcube'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_ini_setting('dbpass').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_dbpass',
            'value'   => "'roundcube'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_ini_setting('dbname').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_dbname',
            'value'   => "'roundcube'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_ini_setting('dbserver').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_dbserver',
            'value'   => "'test.example.com'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_ini_setting('dbport').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_dbport',
            'value'   => "'5432'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_ini_setting('dbssl').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_ssl',
            'value'   => "'false'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_file('/etc/roundcube/main.inc.php').with({
            'owner' => 'root',
            'group' => 'www-data',
            'mode'  => '0640',
          }) }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['include_host_config'\] = false;$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['plugins'\] = array\(\);$} }

      it { should contain_package('roundcube').with_ensure('present') }
      it { should contain_package('roundcube-core').with_ensure('present') }
      it { should contain_package('roundcube-plugins').with_ensure('present') }
      it { should contain_package("roundcube-pgsql").with_ensure('present') }
    end

    describe "roundcube class with custom parameters" do
      let(:params) {{
        :database_name       => 'roundcubedb',
        :database_username   => 'roundcubedb',
        :database_password   => 'roundcubedb',
        :default_host        => 'ssl://imap.example.com',
        :smtp_server         => 'tls://smtp.example.com',
        :smtp_port           => '587',
        :session_domain      => '.example.com',
        :username_domain     => '%z',
        :mail_domain         => '%z',
        :force_https         => true,
        :include_host_config => {
          'webmail.example.org' => 'example.org',
          'webmail.example.com' => 'example.com',
        },
        :plugins             => [
          'archive',
          'markasjunk',
        ],
      }}

      it { should compile.with_all_deps }

      it { should contain_ini_setting('dbuser').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_dbuser',
            'value'   => "'roundcubedb'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_ini_setting('dbpass').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_dbpass',
            'value'   => "'roundcubedb'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_ini_setting('dbname').with({
            'ensure'  => 'present',
            'path'    => '/etc/dbconfig-common/roundcube.conf',
            'section' => '',
            'notify'  => 'Exec[reconfigure-roundcube]',
            'setting' => 'dbc_dbname',
            'value'   => "'roundcubedb'",
            'require' => "Package[roundcube-pgsql]",
          }) }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['default_host'\] = 'ssl://imap.example.com';$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['smtp_server'\] = 'tls://smtp.example.com';$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['smtp_port'\] = 587;$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['session_domain'\] = '.example.com';$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['username_domain'\] = '%z';$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['mail_domain'\] = '%z';$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['force_https'\] = true;$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .without_content %r{^\$rcmail_config\['include_host_config'\] = false;$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['include_host_config'\] = array\('webmail.example.com' => 'example.com.inc.php','webmail.example.org' => 'example.org.inc.php'\);$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .without_content %r{^\$rcmail_config\['plugins'\] = array\(\);$} }

      it { should contain_file('/etc/roundcube/main.inc.php')
        .with_content %r{^\$rcmail_config\['plugins'\] = array\('archive','markasjunk'\);$} }

    end
  end
end
