require 'spec_helper'

describe 'roundcube' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "roundcube class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('roundcube::params') }
        it { should contain_class('roundcube::install').that_comes_before('roundcube::config') }
        it { should contain_class('roundcube::config') }
        it { should contain_class('roundcube::service').that_subscribes_to('roundcube::config') }

        it { should contain_service('roundcube') }
        it { should contain_package('roundcube').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'roundcube class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('roundcube') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
