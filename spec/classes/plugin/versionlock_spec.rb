require 'spec_helper'

shared_examples 'a Zypprepo::plugin::versionlock class' do
  it {
    is_expected.to contain_concat('/etc/zypp/locks').with(
      mode: '0644',
      owner: 'root',
      group: 'root'
    )
  }

  it {
    is_expected.to contain_concat__fragment('versionlock_header').with(
      target: '/etc/zypp/locks',
      content: '# File managed by puppet\n',
      order: '01'
    )
  }
end

describe 'zypprepo::plugin::versionlock' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'without any parameters' do
        it_behaves_like 'a Zypprepo::plugin::versionlock class'
      end
    end
  end
end
