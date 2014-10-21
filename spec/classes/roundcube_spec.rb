require 'spec_helper'

describe 'roundcube' do
  context 'supported Debian operating system' do
    ['pgsql', 'mysql', 'sqlite3'].each do |backend|
      describe "roundcube class with #{backend} backend" do
        let(:params) {{
          :backend => backend,
        }}
        let(:facts) {{
          :osfamily => 'Debian',
          :lsbdistcodename => 'wheezy',
          :operatingsystemmajrelease => 7,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('roundcube::params') }
        it { should contain_class('roundcube::install').that_comes_before('roundcube::config') }
        it { should contain_class('roundcube::config') }

        it { should contain_package('roundcube').with_ensure('present') }
        it { should contain_package('roundcube-core').with_ensure('present') }
        it { should contain_package('roundcube-plugins').with_ensure('present') }
        it { should contain_package("roundcube-#{backend}").with_ensure('present') }
      end
    end
  end
end
